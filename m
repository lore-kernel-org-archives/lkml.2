Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab1H3Pgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:36:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1H3Pgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:36:32 -0400
Subject: Re: [PATCH 15/32] nohz/cpuset: Restart tick when switching to idle
 task
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Tue, 30 Aug 2011 17:35:59 +0200
In-Reply-To: <20110830150430.GS9748@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <1313423549-27093-16-git-send-email-fweisbec@gmail.com>
	 <1314632620.2816.100.camel@twins>
	 <20110830150430.GS9748@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314718559.5812.19.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-30 at 17:04 +0200, Frederic Weisbecker wrote:
> > ... so basically you say:
> > 
> >   Restart the tick when we switch to idle.
> > 
> > Now all that needs is an explanation of why..
> 
> In the end we don't want to restart the tick when we switch to idle.
> But to support that I'll need to tweak various things on idle time
> accounting, otherwise the [cpu] time spent in idle is going to be
> accounted as system time.

Ok, so then the changelog should say so, preferably with a little bit
more detail on how exactly the idle time accounting would go tits-up.
