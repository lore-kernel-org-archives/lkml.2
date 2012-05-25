Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2EYLEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:04:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:37720 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2EYLEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:04:20 -0400
Date: Fri, 25 May 2012 13:04:06 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Juri Lelli <juri.lelli@gmail.com>, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com
Subject: Re: [RFC][PATCH 00/15] sched: SCHED_DEADLINE v5
In-Reply-To: <1337942569.9783.183.camel@laptop>
Message-ID: <alpine.LFD.2.02.1205251302540.3231@ionos>
References: <1337809375-24295-1-git-send-email-juri.lelli@gmail.com> <1337942569.9783.183.camel@laptop>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Peter Zijlstra wrote:

> On Wed, 2012-05-23 at 23:42 +0200, Juri Lelli wrote:
> > Still missing/incomplete:
> >   - (c)group based bandwidth management, and maybe scheduling;
> 
> The b/w stuff for cgroups shouldn't be particularly hard, right? It
> shouldn't be more than ensuring the utilization sum of all children
> stays below the set value.
> 
> Or am I missing something?
> 
> >   - bandwidth inheritance (to replace deadline/priority inheritance);
> 
> Yes please, but this is somewhat longer term, I think the band-aids in
> place are sufficient to allow us to move fwd.
> 
> >   - access control for non-root users (and related security concerns to
> >     address). 
> 
> Right, so could you detail what all is needed to allow regular users to
> create dl tasks?
> 
> Aside from this, Ingo, Thomas, Steven do you agree in merging these
> patches as a suitable base to continue work from?

I haven't looked in detail, but I didn't spot horrible things
either. And yes, we should start with that set and improve from there.

Thanks,

	tglx
