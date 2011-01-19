Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab1ASWYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:24:24 -0500
Received: from www.tglx.de ([62.245.132.106]:58074 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754828Ab1ASWYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:24:22 -0500
Date: Wed, 19 Jan 2011 23:22:22 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kyle McMartin <kyle@mcmartin.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Hirokazu Takata <takata@linux-m32r.org>, Jeff Dike <jdike@addtoit.com>,
        Michal Simek <monstr@monstr.eu>, Mikael Starvik <starvik@axis.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mundt <lethal@linux-sh.org>,
        Richard Henderson <rth@twiddle.net>, Tony Luck <tony.luck@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [patch 00/37] genirq: Remove __do_IRQ() and cleanup irq related
 Kconfigs
In-Reply-To: <20110119221828.GD27353@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.1101192320530.3211@localhost6.localdomain6>
References: <20110119205258.462759212@linutronix.de> <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com> <20110119221706.GC27353@bombadil.infradead.org> <20110119221828.GD27353@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Jan 2011, Kyle McMartin wrote:

> On Wed, Jan 19, 2011 at 05:17:06PM -0500, Kyle McMartin wrote:
> > I submitted series to clean these 3 up as well (but only got a response
> > from the cris folks...) If the other 2 are effectively unmaintained,

Dammit. Seems they got lost on my side in some mail black hole. I hate
redundant work

> > should I just submit the clean ups to you? (I think there were some
> > build fixes as well, will have to check.)
> > 
> 
> Nevermind, just saw the rest of the series on linux-arch.
> 
> --Kyle
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
