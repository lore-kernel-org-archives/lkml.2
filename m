Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0HQGrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:47:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58816 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0HQGrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:47:40 -0400
Date: Tue, 17 Aug 2010 08:47:34 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] dmaengine: Add Freescale i.MX SDMA support
Message-ID: <20100817064734.GS27749@pengutronix.de>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <1281956870-12463-4-git-send-email-s.hauer@pengutronix.de> <AANLkTi=pO-ZJ33FrL=4bVRYa2o9HA0_h5tBYG7wdMuwz@mail.gmail.com> <20100816141540.GQ27749@pengutronix.de> <20100817043612.GA9631@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817043612.GA9631@jasper.tkos.co.il>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:46:39 up 44 days, 21:57, 25 users,  load average: 0.38, 0.25,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:36:12AM +0300, Baruch Siach wrote:
> Hi Sascha,
> 
> On Mon, Aug 16, 2010 at 04:15:40PM +0200, Sascha Hauer wrote:
> > On Mon, Aug 16, 2010 at 02:21:06PM +0200, Linus Walleij wrote:
> > > 2010/8/16 Sascha Hauer <s.hauer@pengutronix.de>:
> > > > The SDMA engine is a scatter/gather DMA engine which is implemented
> > > > as a seperate coprocessor. SDMA needs its own firmware which is
> > > > requested using the standard request_firmware mechanism. The firmware
> > > > has different entry points for each peripheral type, so drivers
> > > > have to pass the peripheral type to the DMA engine which in turn
> > > > picks the correct firmware entry point from a table contained in
> > > > the firmware image itself.
> > > 
> > > Quite fun, if the spec for the microcode is open this opens up
> > > for dynamic firmware generation for specific DMA jobs does it
> > > not?
> > 
> > Unfortunately the specs are not open, so we are sticked to the binary
> > microcode from Freescale. I'm pretty sure though that the SDMA engine
> > could do at least a device_prep_dma_xor operation.
> 
> Chapter 38 in the i.MX25 Reference Manual seems to include almost everything 
> there is to know about the SDMA. Isn't this enough for writing custom SDMA 
> microcodes?

Unfortunately not, the assembler is missing.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
