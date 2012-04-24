Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2DXRPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:15:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59346 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828Ab2DXRPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:15:05 -0400
Message-ID: <4F96DF93.4050000@gmail.com>
Date: Tue, 24 Apr 2012 19:14:59 +0200
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
Subject: Re: [PATCH 10/16] sched: add resource limits for -deadline tasks.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-11-git-send-email-juri.lelli@gmail.com>  <1335280075.28150.202.camel@twins> <4F96C52C.7030606@gmail.com> <1335284820.28150.203.camel@twins>
In-Reply-To: <1335284820.28150.203.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 06:27 PM, Peter Zijlstra wrote:
> On Tue, 2012-04-24 at 17:22 +0200, Juri Lelli wrote:
>
>> Ok, but considering what you said regarding setscheduler security problems:
>
>> Are you suggesting to drop/postpone this to some later time?
>
> Yeah, I think we can put this on the end of the queue and try and get
> some of the basic infrastructure merged first.

Perfect, no rants on my side ;-).

Thanks,

- Juri
