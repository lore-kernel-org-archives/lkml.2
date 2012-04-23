Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab2DWKda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:33:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54620 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2DWKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:33:29 -0400
Message-ID: <4F952FF4.8020303@gmail.com>
Date: Mon, 23 Apr 2012 12:33:24 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>  <1335173641.28150.104.camel@twins> <4F952C11.2000109@gmail.com> <1335176929.28150.111.camel@twins>
In-Reply-To: <1335176929.28150.111.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 12:28 PM, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 12:16 +0200, Juri Lelli wrote:
>> On 04/23/2012 11:34 AM, Peter Zijlstra wrote:
>>> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>>> +               p->sched_class =&dl_sched_class;
>>>
>>> Does this patch actually compile? I've only seen a fwd declaration of
>>> this variable but here you take an actual reference to it.
>>
>> The patch compiles (just tested), although this sounds strange to
>> me too..
>
> I just realized that its a proper definition without an initializer. So
> no harm done, just a brain that still needs to wake up or so.. :-)

Ouch.. right! A struct sched_class after all! Regarding brains, mine should
be enough woken up at this time :-|.

Thanks,

- Juri
