The yaml files in this learning-GitActions are all example of samples to run in .github/workflows/<any of the sample ci.yml>
only one sample ci.yml file in the workflows/ at a time, you can choose to have more than one depending on how many pipeline you are running.
Just copy and paste any of the exercise file in the .github/workflows/, modify the runner to pick the job, push and check in github how the job runs.


DELETE RUNNERS
Should you want to delete the runners, use the "delete-runners.sh or s8mike-deleterunner.sh"
On the commandline use the command >runner.sh to delete the repo or org runners, vim runner.sh and paste the content of delete-runners.sh or s8mike-deleterunner.sh in it. Save and run the script and if all is good, it should delete the runners.