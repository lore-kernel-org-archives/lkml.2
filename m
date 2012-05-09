Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab2EIPdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:33:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53941 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759694Ab2EIPdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:33:50 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18SrmIi614Svu01vPNfC0gd2B3FKYc2VflPnm9IAF
	OpNEE9aIv+ngiv
Message-ID: <1336577622.16079.39.camel@marge.simpson.net>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
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
Date: Wed, 09 May 2012 17:33:42 +0200
In-Reply-To: <alpine.DEB.2.00.1205091001480.10177@router.home>
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
	 <1336506601.7400.21.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1205081541010.1391@router.home>
	 <1336537289.7365.62.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1205090915430.8171@router.home>
	 <1336574836.16079.17.camel@marge.simpson.net>
	 <alpine.DEB.2.00.1205091001480.10177@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:05 -0500, Christoph Lameter wrote:

> I do not get how a cpuset could be used by an application with load
> balancing disabled. Seems to defeat the purpose of the cpuset (which IMHO
> is to generate a custom load balancing domain after all). You would
> have to manually pin the processes to processors of the cpuset anyways.
> 
> If you already have to pin then why would you want a cpuset on top of
> that?

You don't have to turn load balancing completely off.  I have at least
one customer with modest isolation requirements, an exclusive set with
load balancing enabled is perfect for them.  OTOH, for tight constraint
RT, I have no choice but to turn everything I can get my hands on off.
Any such app manages itself or is busted crud, so all is well, cpusets
work nicely.

I don't like cgroups much, but I've become rather fond of cpusets.

-Mike


