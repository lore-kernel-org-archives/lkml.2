Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389Ab2JYHSO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:18:14 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33241 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab2JYHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:18:07 -0400
Date: Thu, 25 Oct 2012 09:18:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
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
Message-ID: <20121025071801.GA3265@gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Juri Lelli <juri.lelli@gmail.com> wrote:

>  kernel/sched/dl.c                          | 1650 ++++++++++++++++++++++++++++

I've got a stupid nit here: please make that deadline.c. Same 
for cpudl.c.

(Just to stop future generations from wondering why the Linux 
scheduler has a downloading module.)

Thanks,

	Ingo
