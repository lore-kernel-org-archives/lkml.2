Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab1HaQMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:12:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:47848 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755985Ab1HaQMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:12:47 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19tno8lQA1tgir5LaUPeF+jggNx3wE6wK7ega5zxd
	5ZRz8vKr998Lye
Subject: Re: [RFC PATCH 00/32] Nohz cpusets (was: Nohz Tasks)
From: Mike Galbraith <efault@gmx.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <CAOtvUMdWu9KUk+ZxOcwEucJ2DHqKEQLuJFpMj1qYkuOeCb=OEQ@mail.gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
	 <CAOtvUMdgPoL_gnOTq8DwS9RxSFagQN_kAze3guD8O3xFHfnfHg@mail.gmail.com>
	 <20110830140648.GL9748@somewhere.redhat.com>
	 <1314762442.4653.5.camel@marge.simson.net>
	 <1314782887.23993.12.camel@twins>
	 <1314786377.4653.19.camel@marge.simson.net>
	 <CAOtvUMdWu9KUk+ZxOcwEucJ2DHqKEQLuJFpMj1qYkuOeCb=OEQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 18:12:40 +0200
Message-ID: <1314807160.4653.48.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 17:05 +0300, Gilad Ben-Yossef wrote:
> > Guess I'll have to try creating a cpuset per cpu, and see how it
> > compares to isolcpus.  cset shield --cpu 4-63 didn't work well enough.
> 
> Try adding:
> 
> # cset shield --kthread on

Yeah, did that.

Killing load balancing in the cpuset should eliminate the problem.
Well, for the test app I was running anyway, which has everything
pinned, and pure RT.

	-Mike

