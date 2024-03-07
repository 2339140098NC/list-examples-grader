CPATH='.;../lib/hamcrest-core-1.3.jar;../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo "finished cloning"

if [[ -f student-submission/ListExamples.java ]]
then
    cp student-submission/ListExamples.java grading-area/
    cp TestListExamples.java grading-area/
else
    echo "Missing student-submission/ListExamples.java, you might've forget the file or misname it"
    exit 1
fi

pwd
cd grading-area/
pwd

javac -cp $CPATH *.java 2> tmp

if [[ $? -ne 0 ]]
then
    echo "The program failed to compile, see compile error above"
    exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > junit-output.txt

lastline=$(cat junit-output.txt | tail -n 2 | head -n 1)
tests=$(echo $lastline | awk -F'[, ]' '{print $3}')
failures=$(echo $lastline | awk -F'[, ]' '{print $6}')
if grep -q "OK" junit-output.txt
then
  echo "Your score is $tests / $tests"
  exit 1
fi
successes=$(($tests - $failures))
echo "Your score is $successes / $tests"
