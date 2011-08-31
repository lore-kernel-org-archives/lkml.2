Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1HaO1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:27:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:57886 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab1HaO1a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:27:30 -0400
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Mike Galbraith <efault@gmx.de>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Date: Wed, 31 Aug 2011 16:26:23 +0200
In-Reply-To: <CAOtvUMe7PphJtMoGRVUQf9zok+0H1VyS1TAckTJXfJ9p8MHyBA@mail.gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
	 <1314762442.4653.5.camel@marge.simson.net>
	 <1314782887.23993.12.camel@twins>
	 <1314786377.4653.19.camel@marge.simson.net>
	 <1314786830.23993.22.camel@twins>
	 <CAOtvUMe7PphJtMoGRVUQf9zok+0H1VyS1TAckTJXfJ9p8MHyBA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314800784.3578.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 17:00 +0300, Gilad Ben-Yossef wrote:
> >> > cpusets? Afaict all it does is not include a number of cpus in the sched
> 
> I think you meant to write cpuisol here :-)

Uhh, yeah ;-)

> >> > domains, creating a bunch of independent scheduling cpus. You can use
> >> > cpusets to get to the same state.
> 
> >>
> >> Guess I'll have to try creating a cpuset per cpu, and see how it
> >> compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.
> >
> > You need to play with the sched_load_balance file, no idea what this
> > cset utility is though, never encountered it before.
> >
> 
> It's just a python wrapper around the /cgroup file system.

ok, just never encountered it.
