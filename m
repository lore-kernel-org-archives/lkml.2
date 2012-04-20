Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589Ab2DTOTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:19:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:45268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab2DTOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:19:11 -0400
Date: Fri, 20 Apr 2012 16:19:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
In-Reply-To: <CAFLxGvzgRpJq_BRrfgGh-V-k9XQmSvSN6hmK+6jm86Vy7v3EVg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1204201618320.2542@ionos>
References: <20120420122120.097464672@linutronix.de> <CAFLxGvzgRpJq_BRrfgGh-V-k9XQmSvSN6hmK+6jm86Vy7v3EVg@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, richard -rw- weinberger wrote:

> On Fri, Apr 20, 2012 at 3:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > This converts all architectures except m32r, mn10300, tile and UM to
> > the new core facility. These architecture are calling fork_idle() in
> > the very early boot code in smp_prepare_cpus() for unknown reasons.
> > I haven't analyzed yet, whether this is on purpose or can be moved
> > over to the generic facility. It'd be nice if the responsible maintainers
> > could look into that as well.
> 
> SMP is marked as broken on UM, so I don't have any objections. :-)

Great. So we can break it some more and let the poor sod who tries to
fix UM SMP deal with it :)

Thanks,

	tglx
