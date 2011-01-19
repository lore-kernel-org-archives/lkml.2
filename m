Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1ASWRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:17:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:37044 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1ASWRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:17:19 -0500
Date: Wed, 19 Jan 2011 17:17:06 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Ungerer <gerg@uclinux.org>,
        Hirokazu Takata <takata@linux-m32r.org>, Jeff Dike <jdike@addtoit.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Michal Simek <monstr@monstr.eu>,
        Mikael Starvik <starvik@axis.com>, Mike Frysinger <vapier@gentoo.org>,
        Paul Mundt <lethal@linux-sh.org>, Richard Henderson <rth@twiddle.net>,
        Tony Luck <tony.luck@intel.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: Re: [patch 00/37] genirq: Remove __do_IRQ() and cleanup irq related
 Kconfigs
Message-ID: <20110119221706.GC27353@bombadil.infradead.org>
References: <20110119205258.462759212@linutronix.de>
 <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTineduG23qitc8ggDKShYJi=2vJgXbYJDjLGZKk3@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 02:13:07PM -0800, Linus Torvalds wrote:
> >  arch/cris, arch/h8300, arch/m32r
> 
> I'm certainly ok with this series. It would be good to finally get rid
> of this legacy interface, and there's no longer any reason to hold it
> up. And getting rid of hundreds of lines of code is good too.
> 

I submitted series to clean these 3 up as well (but only got a response
from the cris folks...) If the other 2 are effectively unmaintained,
should I just submit the clean ups to you? (I think there were some
build fixes as well, will have to check.)

--Kyle
