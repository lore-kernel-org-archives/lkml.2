Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab2DWJgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:36:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2DWJgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:36:36 -0400
Message-ID: <4F95229F.1050305@gmail.com>
Date: Mon, 23 Apr 2012 11:36:31 +0200
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
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>  <1333696481-3433-4-git-send-email-juri.lelli@gmail.com> <1335173405.28150.102.camel@twins>
In-Reply-To: <1335173405.28150.102.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 11:30 AM, Peter Zijlstra wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>>   /*
>> + * This function validates the new parameters of a -deadline task.
>> + * We ask for the deadline not being zero, and greater or equal
>> + * than the runtime.
>> + */
>> +static bool
>> +__checkparam_dl(const struct sched_param2 *prm)
>> +{
>> +       return prm&&  (&prm->sched_deadline) != 0&&
>> +              (s64)(&prm->sched_deadline -&prm->sched_runtime)>= 0;
>> +}
>
> Shouldn't this also include deadline == period for now?

No notion of period in 03/16. It is inserted in 08/16 and checkparam
changed accordingly.

Thanks,

- Juri
