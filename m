Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab0IIONE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 10:13:04 -0400
Received: from ns2.allidaho.com ([66.232.90.194]:60714 "EHLO mail.allidaho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab0IIONB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 10:13:01 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 10:13:01 EDT
From: "Dialup Jon Norstog" <thursday@allidaho.com>
To: Mikael Starvik <mikael.starvik@axis.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Jesper Nilsson <jespern@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        Haavard Skinnemoen <hskinnemoen@atmel.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: RE: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing __do_IRQ() code
Date: Thu, 9 Sep 2010 07:44:36 -0600
Message-Id: <20100909134113.M84121@allidaho.com>
In-Reply-To: <4BEA3FF3CAA35E408EA55C7BE2E61D05583CE93218@xmail3.se.axis.com>
References: <20100908152036.643594727@linutronix.de> <4BEA3FF3CAA35E408EA55C7BE2E61D05583CE93218@xmail3.se.axis.com>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 24.116.219.19 (thursday)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




---------- Original Message -----------
From: Mikael Starvik <mikael.starvik@axis.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-k 
>  The following architectures are still using __do_IRQ():
> 
>   alpha, cris, ia64, h8300, m32r, m68knommu, parisc, um
> 
> So now the question arises what to do with __do_IRQ().
> 
> Removing it would be the right thing, but that'll break 8 archs, so
> it's probably not considered a good idea, though for most of them the
> conversion should be reasonably trivial.
> 
> I'm happy to move that code into kernel/irq/cruft.c forever if there
> is no way to get the remaining users converted in the forseeable
> future. It looks like they can cope with the annoying build warning
> nicely.
> 
> Either that or moving everything what breaks into staging/arch/* and
> hand it over to GregKH :)
> 
> Thoughts ?
 

To the lists:

My thought is, put something in the readme - like Jay Estabrook's note in the
current Alpha Core build.  At least so those of us who get wierd msgs during a
kernel build can know what they are all about.

TIA

jn
