import styles from './styles/style.css'
import Quizzes from './Quizzes.coffee'

status =
    quiz: null
    question: 0
    score: 0

getQuiz = (code) ->
    Quizzes.filter((quiz) -> quiz.code == code).map(
        (quiz) ->
            code: quiz.code,
            name: quiz.name,
            questions: quiz.questions.sort((a, b) -> Math.random() > 0.5)
    )[0]

getCurrentQuestion = () ->
    status.quiz.questions[status.question]

startQuiz = (code) ->
    status =
        quiz: getQuiz(code)
        question: 0
        score: 0
    generateView()

answerQuestion = (answer) ->
    status.score = if answer == getCurrentQuestion().meaning then status.score + 1 else status.score
    if status.question == status.quiz.questions.length - 1
        endQuiz()
    else
        status.question += 1
    generateView()

endQuiz = () ->
    status.question = -1

reset = () ->
    status =
        quiz: null
        question: 0
        score: 0 
    generateView()

generateView = () ->
    unless status.quiz?
        quizQuestion = document.getElementById("quiz-question")
        quizEnd = document.getElementById("quiz-end")
        quizQuestion.classList.add("hidden")
        quizEnd.classList.add("hidden")

        mainMenu = document.getElementById("main-menu")
        mainMenu.classList.remove("hidden")

        buttons = Array.from(document.querySelectorAll("#main-menu button"))
        Quizzes.forEach((quiz, index) ->
            button = buttons[index]
            button.innerHTML = quiz.name
            button.onclick = () ->
                startQuiz(quiz.code)
        )
    else if status.question != -1
        mainMenu = document.getElementById("main-menu")
        quizEnd = document.getElementById("quiz-end")
        mainMenu.classList.add("hidden")
        quizEnd.classList.add("hidden")

        quizQuestion = document.getElementById("quiz-question")
        quizQuestion.classList.remove("hidden")

        buttons = document.querySelectorAll(".choices button")
        Array.from(buttons).forEach((button, index) ->
            option = getCurrentQuestion().options[index]
            button.innerHTML = option
            button.onclick = () ->
                answerQuestion(option)
        )

        h2 = document.querySelector("#quiz-question h2")
        h2.innerHTML = "What does <strong>#{getCurrentQuestion().word}</strong> mean?"

        span = document.querySelector("#quiz-question span")
        span.innerHTML = "#{status.question + 1} / #{status.quiz.questions.length}"
    else
        mainMenu = document.getElementById("main-menu")
        quizQuestion = document.getElementById("quiz-question")
        mainMenu.classList.add("hidden")
        quizQuestion.classList.add("hidden")

        quizEnd = document.getElementById("quiz-end")
        quizEnd.classList.remove("hidden")
        h2 = document.querySelector("#quiz-end h2")
        h2.innerHTML = if status.score >= 9 then "Congratulations! You've scored #{status.score}/#{status.quiz.questions.length}" else "You've scored #{status.score}/#{status.quiz.questions.length}"

        button = document.querySelector("#quiz-end button")
        button.onclick = () ->
            reset()
        

generateView()
        