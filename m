Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2C0MbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 08:31:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:34804 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752115Ab2C0MbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 08:31:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ughdXA3WuwlfYBk16lBIMOZ4ZoefW4L0XSw2bIJ
	6/CTFUTv8j1V91
Message-ID: <1332851466.7679.32.camel@marge.simpson.net>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, LKML <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Tue, 27 Mar 2012 14:31:06 +0200
In-Reply-To: <20120327115630.GD13196@somewhere>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210949440.20482@router.home>
	 <1332389033.5759.52.camel@marge.simpson.net>
	 <20120327112254.GC13196@somewhere>
	 <1332849183.7679.21.camel@marge.simpson.net>
	 <20120327115630.GD13196@somewhere>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-27 at 13:56 +0200, Frederic Weisbecker wrote: 
> Ok but there is a difference between idle nohz and busy nohz.
> Idle nohz may let the CPU enter into low power mode. busy nohz
> (implemented by this patchset) doesn't because it stops the tick
> when the CPU runs.

Yeah.  Your set is tagged important here (stare at, and play with;).

-Mike

