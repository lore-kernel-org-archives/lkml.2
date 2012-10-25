Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992483Ab2JYQ6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:58:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62145 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933227Ab2JYQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:58:41 -0400
Message-ID: <50896FBE.8050605@gmail.com>
Date: Thu, 25 Oct 2012 09:58:38 -0700
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org
Subject: Re: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v6
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com> <20121025071801.GA3265@gmail.com>
In-Reply-To: <20121025071801.GA3265@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2012 12:18 AM, Ingo Molnar wrote:
>
> * Juri Lelli <juri.lelli@gmail.com> wrote:
>
>>   kernel/sched/dl.c                          | 1650 ++++++++++++++++++++++++++++
>
> I've got a stupid nit here: please make that deadline.c. Same
> for cpudl.c.
>

Sure, no problems with that.

Thanks and Regards,

- Juri
