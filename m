Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab2DKO2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 10:28:44 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37017 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322Ab2DKO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 10:28:43 -0400
Message-ID: <4F859516.2070901@gmail.com>
Date: Wed, 11 Apr 2012 16:28:38 +0200
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Subject: Re: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v4
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com> <1334153822.23924.245.camel@gandalf.stny.rr.com>
In-Reply-To: <1334153822.23924.245.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 04:17 PM, Steven Rostedt wrote:
> On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
>
>> The development is taking place at:
>>     https://github.com/jlelli/sched-deadline
>>
>> Check the repositories frequently if you're interested, and feel free to
>> e-mail me for any issue you run into.
>>
>
> BTW, which branch should I be looking at?
>

  * sched-dl-V4 contains the patchset as posted on LKML
  * 3.2.13-rt23-dl is the "development" one with commits not merged in bigger
    patches

Currently, they are equivalent for testing purposes.

I most probably have to simplify and clean the whole repo..

Thanks and Regards,

- Juri
  
