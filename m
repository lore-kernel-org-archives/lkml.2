Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab2AWQTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:19:33 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33837 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752332Ab2AWQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:19:32 -0500
Message-ID: <4F1D9644.7090707@xenotime.net>
Date: Mon, 23 Jan 2012 09:17:56 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 14/14] docbook: fix sched source file names in device-drivers
 book
References: <4F1B0BFC.2010105@xenotime.net> <1327308902.2442.256.camel@twins>
In-Reply-To: <1327308902.2442.256.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2012 12:55 AM, Peter Zijlstra wrote:
> On Sat, 2012-01-21 at 11:03 -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@xenotime.net>
>>
>> Fix warning since kernel scheduler functions and kernel-doc
>> notation were moved to other files.
>>
>> docproc: lnx-33-rc1/kernel/sched.c: No such file or directory
>>
>> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> ---
>>  Documentation/DocBook/device-drivers.tmpl |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> --- lnx-33-rc1.orig/Documentation/DocBook/device-drivers.tmpl
>> +++ lnx-33-rc1/Documentation/DocBook/device-drivers.tmpl
>> @@ -50,7 +50,9 @@
>>  
>>       <sect1><title>Delaying, scheduling, and timer routines</title>
>>  !Iinclude/linux/sched.h
>> -!Ekernel/sched.c
>> +!Ekernel/sched/core.c
>> +!Ikernel/sched/cpupri.c
>> +!Ikernel/sched/fair.c
> 
> There's more files in there, they might not include proper kerneldoc
> comments, but shouldn't they be included anyway?

Only the ones that have kernel-doc comments are listed here.

> Also, what the difference between Ekernel and Ikernel?

!Efilename
is for files that contain exported symbols and it only lists the exports.
!Ifilename
is for files that contain kernel-doc for internal functions.

It is OK to use both of them for one filename so that both exports and
internal functions are listed in the generated output.

>>  !Iinclude/linux/completion.h
>>  !Ekernel/timer.c
>>       </sect1>
> 
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
