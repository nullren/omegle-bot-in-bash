#!/bin/bash

VIDEO="http://www.youtube.com/watch?&v=bNKZTVvgTjY"
THINGSTOSAY=(
    "hi there"
    "heyyo"
    "hi"
    "do you want to protect the internet?"
    "are you not a man that stands up for what he believes in?"
)

OMEGLE="curl -s http://www.omegle.com/"

escape(){
    echo $(perl -MURI::Escape -e "print uri_escape(\"${1}\");")
}
a_thing(){
    for i in "${THINGSTOSAY[@]}"; do
      echo $i
    done | sort -R | head -n 1
}

omegle(){
    case $1 in
      start) echo $($OMEGLE"start") | sed 's/"//g' ;;
      typing) echo $($OMEGLE"typing" -d id=$CODE) ;;
      spam) 
        echo $(omegle say "$(a_thing)")
#        sleep 1
#        echo $(omegle say "$VIDEO");
        ;;
      say) 
        MSG=$(escape "$2")
        echo $($OMEGLE"send" -d msg=$MSG -d id=$CODE) 
        ;;
      events) sleep 1; echo $($OMEGLE"events" -d id=$CODE) ;;
      disc*) echo $($OMEGLE"disconnect" -d id=$CODE) ;;   
    esac
}

while true; do
    CODE=$(omegle start)
    echo $CODE: events: $(omegle events)
    echo $CODE: message sent: $(omegle spam)
    echo $CODE: disconnect: $(omegle disconnect)

    sleep 10
done
