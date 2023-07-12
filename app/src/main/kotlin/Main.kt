import java.io.FileInputStream

fun main(args: Array<String>) {

    println("Kotlin Program arguments: ${args.joinToString()}")
    val inputStream = FileInputStream(args[0])
    val content = inputStream.readBytes().toString(Charsets.UTF_8)
    println("Content of the read file is:")
    println(content)
}