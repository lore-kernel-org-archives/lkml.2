Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2EHTuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:50:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53278 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755244Ab2EHTuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:50:13 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SEOEy+WLSfEg4mqm+IQYHA1yQ2Ll+dmNMsMwWgx
	F77P1uhCPqRLxD
Message-ID: <1336506601.7400.21.camel@marge.simpson.net>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Lameter <cl@linux.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 08 May 2012 21:50:01 +0200
In-Reply-To: <1336493768.8226.29.camel@twins>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
	 <1335830115-14335-8-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1205071053070.1060@router.home>
	 <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
	 <1336488626.16236.41.camel@twins>
	 <alpine.DEB.2.00.1205081016370.27713@router.home>
	 <1336490832.8226.5.camel@twins>
	 <alpine.DEB.2.00.1205081035550.27713@router.home>
	 <1336492081.8226.13.camel@twins>
	 <alpine.DEB.2.00.1205081054310.27713@router.home>
	 <1336493768.8226.29.camel@twins>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 18:16 +0200, Peter Zijlstra wrote: 
> On Tue, 2012-05-08 at 10:57 -0500, Christoph Lameter wrote:

> isolcpus is a very limited hack that adds more pain that its worth. Its
> yet another mask to check and its functionality is completely available
> through cpusets.

Agreed.

> You cannot create multi-cpu partitions using isolcpus, you cannot
> dynamically reconfigure it.

Big plus for cpusets.

> And on the scheduler side cpusets doesn't add runtime overhead to normal
> things, only sched_setaffinity() and a few other rare operations get
> slightly more expensive. And it allows to reduce runtime overhead by
> making the load-balancer domains smaller.

Very big deal if you have a load that doesn't do all the performance 'i'
dotting and 't' crossing it maybe could have, but ends up on a big box.

-Mike

