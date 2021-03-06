function [ final_balance, mean_returns, vol_returns, hits_count ] = Martingale( suite_next_bet, takeProfit, money )
    
    if(takeProfit == 0)
       takeProfit = Inf; 
    end

    p = 18/37; %0.4865
    idx_next_bet = 1;
    money_process(1) = money;
    next_bet = suite_next_bet(idx_next_bet);
    hits_count = 0;
    while((money > 0) && (money - next_bet > 0) && (money < takeProfit))
        win = binornd(1,p);
        if(win)
            money = money + next_bet;
            idx_next_bet = 1;
        else
            money = money - next_bet;
            idx_next_bet = idx_next_bet + 1;
            if(idx_next_bet > length(suite_next_bet))
                money_process(end+1) = money;
                hits_count = hits_count + 1;
                break; 
            end
        end
        last_bet = next_bet;
        next_bet = suite_next_bet(idx_next_bet);
        %fprintf('money=%i, last_bet=%i, next_bet=%i, status=%i\n', money, last_bet, next_bet, win);
        money_process(end+1) = money;
        hits_count = hits_count + 1;
    end
    %bar(money_process);
    final_balance       = money_process(end);
    returns             = diff(money_process);
    vol_returns         = std(returns);
    mean_returns        = mean(returns);
end

