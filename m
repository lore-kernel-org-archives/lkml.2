Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab2EGWKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:10:18 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:29774 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2EGWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:10:10 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+a6P4zHeTY3Mw18K4luSGw
Date: Mon, 7 May 2012 15:10:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.4-rc4] ARM: OMAP1: Amstrad Delta: Fix wrong IRQ base
 in FIQ handler
Message-ID: <20120507221007.GN5088@atomide.com>
References: <1335806769-23711-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20120504165948.GC5613@atomide.com>
 <1470735.vzc89Ry7Ka@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1470735.vzc89Ry7Ka@acer>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [120507 14:21]:
> Dnia piątek, 4 maja 2012 09:59:49 Tony Lindgren pisze:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [120430 10:30]:
> > > Commit 384ebe1c2849160d040df3e68634ec506f13d9ff, "gpio/omap: Add DT
> > > support to GPIO driver", introduced dynamic IRQ numbering of OMAP 
> GPIO
> > > interrupts, breaking all IH_GPIO_BASE based IRQ number calculations.
> > > This issue was corrected in the OMAP GPIO driver and the related 
> header
> > > file with commit 25db711df3258d125dc1209800317e5c0ef3c870, 
> "gpio/omap:
> > > Fix IRQ handling for SPARSE_IRQ".
> > > 
> > > However, the Amstrad Delta FIQ handler, which replaces the gpio-omap
> > > driver in serving GPIO interrupts on this board, still uses that
> > > outdated method. Fix it.
> > 
> > Thanks applying into fixes.
> 
> Hi Tony,
> Thanks for taking this patch, but I ca't see it applied into your fixes 
> branch (the last one sitting there is "Linux 3.4-rc4" by Linus). Am I 
> missing something?

Oops, sorry forgot to push it out. Pushed out now, so it should appear
on the mirrors shortly.

Tony
