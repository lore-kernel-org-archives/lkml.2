Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab1LTBSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:18:49 -0500
Received: from d1.icnet.pl ([212.160.220.21]:51209 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab1LTBSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:18:46 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 2/7] ARM: OMAP1: ams-delta: convert latches to basic_mmio_gpio
Date: Tue, 20 Dec 2011 02:18:02 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
References: <cover.1324331816.git.jkrzyszt@tis.icnet.pl> <201112200159.36558.jkrzyszt@tis.icnet.pl> <20111220010446.GA6464@atomide.com>
In-Reply-To: <20111220010446.GA6464@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112200218.03283.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of December 2011 at 02:04:46, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 16:28]:
> > On Tuesday 20 of December 2011 at 01:06:00, Tony Lindgren wrote:
> > > 
> > > This part especially looks like it really should be just a regular
> > > device driver under drivers/ somewhere. 
> > 
> > I really don't understand what kind of a driver you might mean here.
> > 
> > The latch_gpios[] table is initially filled with all latch1 and latch2 
> > GPIO pins in order to register and initialize them from the board file 
> > until they are handled by respective existing device drivers (leds, 
> > nand, lcd, serio, serial8250, asoc) instead of those drivers accessing 
> > the latches with those old ams_delta_latch[12]_write() functions. That 
> > table will get almost empty after the transision process is completed, 
> > holding only pins not used by any drivers / connected to unsued devices, 
> > in order to initialize them from the board file for power saving 
> > purposes. A separate driver for the purpose of initializing a few GPIO 
> > pins seems an overkill.
> 
> OK maybe update the comments a bit to describe how that table will
> mostly disappear? It's not obvious from glancing over this patch
> series :)

To be sure, do you mean in-line comments? Or the changelog message?

Janusz
