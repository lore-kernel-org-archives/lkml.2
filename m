Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935471Ab2JYJxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:53:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36329 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884Ab2JYJxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:53:38 -0400
Date: Thu, 25 Oct 2012 11:53:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org
Subject: Re: [RFC][PATCH 00/16] sched: SCHED_DEADLINE v6
Message-ID: <20121025095335.GB17169@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
	peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com,
	rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
	darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
	linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
	michael@amarulasolutions.com, fchecconi@gmail.com,
	tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
	luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
	paulmck@linux.vnet.ibm.com, raistlin@linux.it,
	insop.song@ericsson.com, liming.wang@windriver.com,
	jkacur@redhat.com, harald.gustafsson@ericsson.com,
	vincent.guittot@linaro.org
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
 <20121025071801.GA3265@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121025071801.GA3265@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 09:18:01AM +0200, Ingo Molnar wrote:
> 
> * Juri Lelli <juri.lelli@gmail.com> wrote:
> 
> >  kernel/sched/dl.c                          | 1650 ++++++++++++++++++++++++++++
> 
> I've got a stupid nit here: please make that deadline.c. Same 
> for cpudl.c.
> 
> (Just to stop future generations from wondering why the Linux 
> scheduler has a downloading module.)

Why not?

In case it needs to download vendor- or system-specific scheduling
policies.

:-)

-- 
Regards/Gruss,
    Boris.
