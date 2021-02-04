    #!/bin/bash
    stats=¡±¡±
    echo "%   user"
    echo "============"
    # collect the data
    for user in `ps -o ruser=userForLongName -e -o %mem | awk '{print $1}' | sort -u`
    do
      stats="$stats\n`ps -o ruser=userForLongName -e -o %mem | egrep ^$user | awk 'BEGIN{total=0}; \
        {total += $2};END{print total,$1}'`"
    done
    # sort data numerically (largest first)
    echo -e $stats | grep -v ^$ | sort -rn | head