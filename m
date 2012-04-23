Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2DWK3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:29:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49827 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab2DWK3M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:29:12 -0400
Message-ID: <1335176929.28150.111.camel@twins>
Subject: Re: [PATCH 03/16] sched: SCHED_DEADLINE data structures.
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        cfriesen@nortel.com, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com
Date: Mon, 23 Apr 2012 12:28:49 +0200
In-Reply-To: <4F952C11.2000109@gmail.com>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-4-git-send-email-juri.lelli@gmail.com>
	 <1335173641.28150.104.camel@twins> <4F952C11.2000109@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 12:16 +0200, Juri Lelli wrote:
> On 04/23/2012 11:34 AM, Peter Zijlstra wrote:
> > On Fri, 2012-04-06 at 09:14 +0200, Juri Lelli wrote:
> >> +               p->sched_class =&dl_sched_class;
> >
> > Does this patch actually compile? I've only seen a fwd declaration of
> > this variable but here you take an actual reference to it.
> 
> The patch compiles (just tested), although this sounds strange to
> me too..

I just realized that its a proper definition without an initializer. So
no harm done, just a brain that still needs to wake up or so.. :-)
