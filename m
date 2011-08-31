Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1HaK02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:26:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:38257 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751833Ab1HaK01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:26:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18fU18eut8fowiFDTOLTWLtanAJXlihrjnJ+ZTfFJ
	Vc7x01DOi4mpXS
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1314782887.23993.12.camel@twins>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
	 <1314762442.4653.5.camel@marge.simson.net>
	 <1314782887.23993.12.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 12:26:17 +0200
Message-ID: <1314786377.4653.19.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 11:28 +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-31 at 05:47 +0200, Mike Galbraith wrote:
> > On Tue, 2011-08-30 at 16:06 +0200, Frederic Weisbecker wrote:
> > 
> > > Ah I haven't tested with that isolcpus especially as it's headed toward
> > > removal.
> > 
> > It is?  Is it being replaced by something?  (I find it useful)
> 
> cpusets? Afaict all it does is not include a number of cpus in the sched
> domains, creating a bunch of independent scheduling cpus. You can use
> cpusets to get to the same state.

Guess I'll have to try creating a cpuset per cpu, and see how it
compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.

	-Mike

