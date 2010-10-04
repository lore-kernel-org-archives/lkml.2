Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0JDAhy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 20:37:54 -0400
Received: from gate.crashing.org ([63.228.1.57]:55550 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573Ab0JDAhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 20:37:53 -0400
Subject: Re: [patch 46/47] powerpc: Use new irq allocator
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <m1pqvqdd8s.fsf@fess.ebiederm.org>
References: <20100930221351.682772535@linutronix.de>
	 <20100930221743.014571381@linutronix.de> <1285893737.2463.4.camel@pasglop>
	 <alpine.LFD.2.00.1010011504380.2416@localhost6.localdomain6>
	 <m1bp7bfc9n.fsf@fess.ebiederm.org> <1286146459.2463.308.camel@pasglop>
	 <m1pqvqdd8s.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 11:37:16 +1100
Message-ID: <1286152636.2463.311.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-03 at 17:15 -0700, Eric W. Biederman wrote:
> 
> >  - Appart from the risk of breaking crap that
> parses /proc/interrupts,
> > adding the HW irq information there would be trivial and solve your
> > problem.
> 
> At this point in time getting things into sysfs seems the way to
> handle
> that. 

Right. For now, we have it in debugfs on powerpc, but I agree this
should probably move to sysfs.

Cheers,
Ben.

