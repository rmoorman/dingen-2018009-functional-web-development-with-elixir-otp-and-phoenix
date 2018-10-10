import {Socket} from "phoenix"

const socket = new Socket("/socket", {})
socket.connect()

//// Now that you are connected, you can join channels with a topic:
//let channel = socket.channel("topic:subtopic", {})
//channel.join()
//  .receive("ok", resp => { console.log("Joined successfully", resp) })
//  .receive("error", resp => { console.log("Unable to join", resp) })

const new_channel = (player, screen_name) =>
  socket.channel(`game:${player}`, {screen_name})

const join = channel => (
  channel
  .join()
  .receive("ok", response => console.log("Joined successfully", response))
  .receive("error", response => console.log("Unable to join", response))
)

window.new_channel = new_channel
window.join = join

export default socket
