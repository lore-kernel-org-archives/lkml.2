Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1HaKeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:34:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47971 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1HaKeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:34:16 -0400
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
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
Date: Wed, 31 Aug 2011 12:33:50 +0200
In-Reply-To: <1314786377.4653.19.camel@marge.simson.net>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
	 <1314762442.4653.5.camel@marge.simson.net>
	 <1314782887.23993.12.camel@twins>
	 <1314786377.4653.19.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314786830.23993.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 12:26 +0200, Mike Galbraith wrote:
> On Wed, 2011-08-31 at 11:28 +0200, Peter Zijlstra wrote:
> > On Wed, 2011-08-31 at 05:47 +0200, Mike Galbraith wrote:
> > > On Tue, 2011-08-30 at 16:06 +0200, Frederic Weisbecker wrote:
> > > 
> > > > Ah I haven't tested with that isolcpus especially as it's headed toward
> > > > removal.
> > > 
> > > It is?  Is it being replaced by something?  (I find it useful)
> > 
> > cpusets? Afaict all it does is not include a number of cpus in the sched
> > domains, creating a bunch of independent scheduling cpus. You can use
> > cpusets to get to the same state.
> 
> Guess I'll have to try creating a cpuset per cpu, and see how it
> compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.

You need to play with the sched_load_balance file, no idea what this
cset utility is though, never encountered it before.
