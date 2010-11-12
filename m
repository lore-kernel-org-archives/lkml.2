Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab0KLRLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 12:11:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42210 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab0KLRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 12:11:22 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=6f2s1ZIU2zoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=gco0Tvhv4xtgzGCegucA:9 a=4wbY1Qn6dj0bh6T5mQLdaWDpEqUA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 03/22] sched: SCHED_DEADLINE data structures.
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289416239.2084.39.camel@laptop>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333680.8661.142.camel@Palantir>  <1289416239.2084.39.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 12 Nov 2010 12:11:19 -0500
Message-ID: <1289581879.12418.413.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 20:10 +0100, Peter Zijlstra wrote:
> On Fri, 2010-10-29 at 08:28 +0200, Raistlin wrote:
> > +       if (unlikely(prio >= MAX_DL_PRIO && prio < MAX_RT_PRIO))
> 
> Since MAX_DL_PRIO is 0, you can write that as: 
>   ((unsigned)prio) < MAX_RT_PRIO

Does this make a difference? If not, I rather leave it out since it just
makes it less readable, and a bit confusing for reviewers.

-- Steve



