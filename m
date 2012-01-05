Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2AESKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:10:32 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43207 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2AESKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:10:31 -0500
Message-ID: <4F05E791.3070304@gmail.com>
Date: Thu, 05 Jan 2012 19:10:25 +0100
From: Carla Sella <carla.sella@gmail.com>
Reply-To: carla.sella@gmail.com
Organization: Carla Sella
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20111223 Thunderbird/10.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: suspend/resume does not work on G62 notebook PC
References: <4EB53C46.1060301@gmail.com> <20111108010406.GC16800@kroah.com> <4EC2C53E.7020503@gmail.com> <201111152012.29965.arnd@arndb.de>
In-Reply-To: <201111152012.29965.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 09:12 PM, Arnd Bergmann wrote:
> On Tuesday 15 November 2011, Carla Sella wrote:
>>> Can you try the 3.2-rc1 release?
>>>
>> Hello,
>> I installed kernel 3.2.0-rc1 but I'm having the same problems, this is
>> the output of "sudo /usr/share/checkbox/scripts/suspend_test --full":
>>
> This is most likely the same problem that many people have encountered
> using the acpi cpuidle driver. It should be fixed on 3.2-rc2.
>
> 	Arnd


Hello,
I installed kernel 3.2-rc7 but the problem is not solved, I'm having the 
same problems as before.
This is the output of the test I ran:

letozaf@letozaf-HP-G62:~$ sudo /usr/share/checkbox/scripts/suspend_test 
--full
[sudo] password for letozaf:
This script will attempt to suspend and resume your computer a number of 
times.
Should the machine fail to resume, first attempt to manually resume it.  If
that fails power your system off and on which will generate an apport bug
report automatically.

Press CTRL-C now to abort testing ...

*** TEST 1 -- suspend triggered via dbus message
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** press return

SUSPEND FAILED, did not go to sleep

*** TEST 2 -- suspend with AC disconnected
*** please ensure your AC cord is detached
*** machine will suspend for 20 seconds
*** press return when ready when ready



My notebook did suspend for 20 seconds but got this message:
SUSPEND FAILED, did not go to sleep

*** TEST 3 -- suspend with AC connected
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** press return when ready



My notebook did suspend for 20 seconds but got this message:
SUSPEND FAILED, did not go to sleep

*** TEST 4 -- loss of AC while suspended
*** please remove the AC cord while the machine is suspended
*** machine will suspend for 20 seconds
*** press return when ready



My notebook did suspend for 20 seconds but got this message:
SUSPEND FAILED, did not go to sleep

*** TEST 5 -- return of AC while suspended
*** please insert the AC cord while the machine is suspended
*** machine will suspend for 20 seconds
*** press return when ready



My notebook did suspend for 20 seconds but got this message:
SUSPEND FAILED, did not go to sleep

*** TEST 6 -- battery drain during suspend
*** calculates overall power drain during a long-term suspend
*** please ensure your AC cord is detached
*** machine will suspend for 20 minutes
*** press return when ready

My notebook did suspend for 20 minutes but got this message:
SUSPEND FAILED, did not go to sleep
before: 4064 mWh
after: 4064 mWh
consumed: 0 mW
sleep seconds: 1236 sec
overall usage: 0 mW

*** TEST 7 -- 30 iteration variable delay suspend/resume stress test
*** please ensure your AC cord is attached
*** machine will suspend for 20 seconds
*** NOTE: there will be no further user interaction from this point
*** press return when ready


delay 60 ...
SUSPEND FAILED, did not go to sleep
wait for 60 seconds
delay 58 ...
SUSPEND FAILED, did not go to sleep
wait for 58 seconds
delay 56 ...
SUSPEND FAILED, did not go to sleep
wait for 56 seconds
delay 54 ...
SUSPEND FAILED, did not go to sleep
wait for 54 seconds
delay 52 ...
SUSPEND FAILED, did not go to sleep
wait for 52 seconds
delay 50 ...
SUSPEND FAILED, did not go to sleep
wait for 50 seconds
delay 48 ...
SUSPEND FAILED, did not go to sleep
wait for 48 seconds
delay 46 ...
SUSPEND FAILED, did not go to sleep
wait for 46 seconds
delay 44 ...
SUSPEND FAILED, did not go to sleep
wait for 44 seconds
delay 42 ...
SUSPEND FAILED, did not go to sleep
wait for 42 seconds
delay 40 ...
SUSPEND FAILED, did not go to sleep
wait for 40 seconds
delay 38 ...
SUSPEND FAILED, did not go to sleep
wait for 38 seconds
delay 36 ...
SUSPEND FAILED, did not go to sleep
wait for 36 seconds
delay 34 ...
SUSPEND FAILED, did not go to sleep
wait for 34 seconds
delay 32 ...
SUSPEND FAILED, did not go to sleep
wait for 32 seconds
delay 30 ...
SUSPEND FAILED, did not go to sleep
wait for 30 seconds
delay 28 ...
SUSPEND FAILED, did not go to sleep
wait for 28 seconds
delay 26 ...
SUSPEND FAILED, did not go to sleep
wait for 26 seconds
delay 24 ...
SUSPEND FAILED, did not go to sleep
wait for 24 seconds
delay 22 ...
SUSPEND FAILED, did not go to sleep
wait for 22 seconds
delay 20 ...
SUSPEND FAILED, did not go to sleep
wait for 20 seconds
delay 18 ...
SUSPEND FAILED, did not go to sleep
wait for 18 seconds
delay 16 ...
SUSPEND FAILED, did not go to sleep
wait for 16 seconds
delay 14 ...
SUSPEND FAILED, did not go to sleep
wait for 14 seconds
delay 12 ...
SUSPEND FAILED, did not go to sleep
wait for 12 seconds
delay 10 ...
SUSPEND FAILED, did not go to sleep
wait for 10 seconds
delay 8 ...
SUSPEND FAILED, did not go to sleep
wait for 8 seconds
delay 6 ...
SUSPEND FAILED, did not go to sleep
wait for 6 seconds
delay 4 ...
SUSPEND FAILED, did not go to sleep
wait for 4 seconds
delay 2 ...
SUSPEND FAILED, did not go to sleep
wait for 2 seconds

*** Please report your results on the Ubuntu WIKI:
     https://wiki.ubuntu.com/KernelTeam/SuspendResumeTesting

       Battery Consumption: 0 mW
letozaf@letozaf-HP-G62:~$




On test7 all the suspensions occurred but were signaled as failed.

-- 
Carla Sella
email: carla.sella@gmail.com
https://launchpad.net/~carla-sella

