Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1BKNGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 08:06:02 -0500
Received: from www.tglx.de ([62.245.132.106]:41124 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1BKNF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 08:05:59 -0500
Date: Fri, 11 Feb 2011 14:05:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 00/75] genirq: Overhaul for 2.6.39
In-Reply-To: <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1102111359580.31804@localhost6.localdomain6>
References: <20110210222908.661199947@linutronix.de> <AANLkTi=waRQcvdxyKUgcLZ1r-hwUcAVZeVDcBa-apyK2@mail.gmail.com> <alpine.LFD.2.00.1102110058450.31804@localhost6.localdomain6> <AANLkTin3o9eFjpe6TMmKb5LSRUT+0Y2EpD4OU4LzN8Kd@mail.gmail.com>
 <alpine.LFD.2.00.1102110135320.31804@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Fri, 11 Feb 2011, Thomas Gleixner wrote:
> On Thu, 10 Feb 2011, Linus Torvalds wrote:
> So yes, it's net more source lines, but not resulting in any binary
> bloat.

Just checked. When the compat layer goes away it will kill about 500
lines. So it's less code with better encapsulation.

Once all genirq archs convert to the generic irq_show_interrupts(),
this will kill another 1000+ lines.

Thanks,

	tglx
