Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2DTSzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 14:55:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:46460 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2DTSzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 14:55:17 -0400
Date: Fri, 20 Apr 2012 20:55:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: Re: [patch 04/18] smp: Provide generic idle thread allocation
In-Reply-To: <20120420162103.GA3065@merkur.ravnborg.org>
Message-ID: <alpine.LFD.2.02.1204202054170.2542@ionos>
References: <20120420122120.097464672@linutronix.de> <20120420124557.102478630@linutronix.de> <20120420162103.GA3065@merkur.ravnborg.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012, Sam Ravnborg wrote:
> On Fri, Apr 20, 2012 at 01:05:45PM -0000, Thomas Gleixner wrote:
> > +config GENERIC_SMP_IDLE_THREAD
> > +       bool
> > +
> 
> Symbols we select in arch Kconfig files are often named HAVE_*
> And no matter the name - a comment preceeding the definition of the symbol
> would be nice so it is possible to deduct the use of the symbol
> in a few years time when this thread is long forgotten.

Fair enough. Though I hope that this can go away, when we can convert
the 3 remaining archs over.

Thanks,

	tglx
