Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587Ab2EGVRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:17:31 -0400
Received: from d1.icnet.pl ([212.160.220.21]:39372 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab2EGVR1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:17:27 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.4-rc4] ARM: OMAP1: Amstrad Delta: Fix wrong IRQ base in FIQ handler
Date: Mon, 07 May 2012 23:16:25 +0200
Message-ID: <1470735.vzc89Ry7Ka@acer>
Organization: Tele-Info-System, Poznan, PL
User-Agent: KMail/4.7.4 (Linux/3.1.10-gentoo-r1; KDE/4.7.4; i686; ; )
In-Reply-To: <20120504165948.GC5613@atomide.com>
References: <1335806769-23711-1-git-send-email-jkrzyszt@tis.icnet.pl> <20120504165948.GC5613@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia piątek, 4 maja 2012 09:59:49 Tony Lindgren pisze:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [120430 10:30]:
> > Commit 384ebe1c2849160d040df3e68634ec506f13d9ff, "gpio/omap: Add DT
> > support to GPIO driver", introduced dynamic IRQ numbering of OMAP 
GPIO
> > interrupts, breaking all IH_GPIO_BASE based IRQ number calculations.
> > This issue was corrected in the OMAP GPIO driver and the related 
header
> > file with commit 25db711df3258d125dc1209800317e5c0ef3c870, 
"gpio/omap:
> > Fix IRQ handling for SPARSE_IRQ".
> > 
> > However, the Amstrad Delta FIQ handler, which replaces the gpio-omap
> > driver in serving GPIO interrupts on this board, still uses that
> > outdated method. Fix it.
> 
> Thanks applying into fixes.

Hi Tony,
Thanks for taking this patch, but I ca't see it applied into your fixes 
branch (the last one sitting there is "Linux 3.4-rc4" by Linus). Am I 
missing something?

Regards,
Janusz
