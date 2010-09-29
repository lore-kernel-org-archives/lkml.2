Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0I2OiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 10:38:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43366 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0I2OiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 10:38:15 -0400
Date: Wed, 29 Sep 2010 10:38:07 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Greg Ungerer <gerg@uclinux.org>, Jeff Dike <jdike@addtoit.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Chris Zankel <chris@zankel.net>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [RFC trollpatch 1/1] genirq: Remove the fits all and nothing
 __do_IRQ() code
Message-ID: <20100929143807.GB18362@bombadil.infradead.org>
References: <20100908152036.643594727@linutronix.de>
 <AANLkTikVHO9DmyTX==CwViDK1rP0masBwjMakHZ0U=kZ@mail.gmail.com>
 <alpine.LFD.2.00.1009271953390.2416@localhost6.localdomain6>
 <987664A83D2D224EAE907B061CE93D5301604712B4@orsmsx505.amr.corp.intel.com>
 <alpine.LFD.2.00.1009272048100.2416@localhost6.localdomain6>
 <987664A83D2D224EAE907B061CE93D530160471328@orsmsx505.amr.corp.intel.com>
 <20100929004607.GA18362@bombadil.infradead.org>
 <987664A83D2D224EAE907B061CE93D530160554808@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D530160554808@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 09:55:01PM -0700, Luck, Tony wrote:
> Yes. Take a look in today's linux-next kernel (tag next-20100929)
> for commit: 5d4bff94f9e0877a85b4dc573eb7a3f1d97c13ae
> 
> Essentially I just added an "unmask_irq()" call into the ->end
> routine, renamed it, and used it as ->unmask.
> 

Ahh, cool, glad to hear it.

--Kyle

> It seems to work okay - I tried migrating interrupts around by
> poking at /proc/irq/NNN/smp_affinity - and that still works.
> 
> -Tony
> 
