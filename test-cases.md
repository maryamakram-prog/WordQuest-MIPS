# WordQuest MIPS – Test Cases

| Test | Input / Action | Expected Result |
|---|---|---|
| TC-01 | Start game | Welcome screen appears |
| TC-02 | Enter correct word | Player wins |
| TC-03 | Enter incorrect five-letter word | Attempts decrease by one |
| TC-04 | Enter incorrect word | Score decreases by 10 |
| TC-05 | Enter fewer than five letters | Invalid input message |
| TC-06 | Use all six attempts | Game over message |
| TC-07 | Select replay option 1 | New game starts |
| TC-08 | Select replay option 0 | Program finishes |

## Test Status

Basic execution: Passed

Correct and incorrect guess flow: Tested

Replay and exit: Tested

Input validation: Pending complete verification