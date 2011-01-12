Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1ALUWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:22:45 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33213 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263Ab1ALUWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:22:43 -0500
Message-ID: <4D2E0D89.6030302@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 12:22:33 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmU=?= =?UTF-8?B?Y2tlcg==?= 
	<fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [BUG] perf sched broken
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com> <4D2E0403.7080300@linux.vnet.ibm.com> <AANLkTimwyzFKanSCeki3HOS95-cwWqGCAssX31DNWD3p@mail.gmail.com>
In-Reply-To: <AANLkTimwyzFKanSCeki3HOS95-cwWqGCAssX31DNWD3p@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2011 11:52 AM, Stephane Eranian wrote:
> On Wed, Jan 12, 2011 at 8:41 PM, Corey Ashford
> <cjashfor@linux.vnet.ibm.com>  wrote:
>> On 01/12/2011 01:29 AM, Stephane Eranian wrote:
>>>
>>> Hi,
>>>
>>> I am trying to use perf sched from tip-x86 but it fails for all my
>>> attempts.
>>
>> So far I have been unsuccessful in reproducing this problem, but I suspect
>> that I have the wrong git tree or branch.  The git tree I've cloned is:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>>
> I was using this branch.
> I also tried running the tool on ubuntu lucid (2.6.32-based).
>
> Didn't you have to at least fixup the sched event names to drop :r?
> Once you have the perf.data file, how do you dump it?
>
> I tried:
> - perf sched trace ->  error
> - perf sched replay ->  error
> - perf script sched-migration  ->  hangs
> - perf report -D
>
>> I've tried the branches master, x86/urgent, and x86-urgent-for-linus. All of
>> those produce correct results, as far as I can tell.
>>
>> Which tree / branch should I be using?
>>
>> - Corey
>>

I made a stupid mistake!  When I ran perf, it was picking up the 
executable from /usr/bin instead of the kernel build tree.

I am seeing the problem you are reporting now.

Thanks for your patience,

- Corey
