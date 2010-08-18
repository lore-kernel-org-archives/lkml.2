Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0HRLY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:24:56 -0400
Received: from smtp0.epfl.ch ([128.178.224.219]:43360 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752645Ab0HRLYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:24:54 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Aug 2010 07:24:53 EDT
From: Philippe =?iso-8859-1?q?R=E9tornaz?= <philippe.retornaz@epfl.ch>
Organization: EPFL - STI - LSRO1
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3] dmaengine: Add Freescale i.MX SDMA support
Date: Wed, 18 Aug 2010 13:17:48 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.13-desktop-1mnb; KDE/4.3.5; x86_64; ; )
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Baruch Siach <baruch@tkos.co.il>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1281956870-12463-1-git-send-email-s.hauer@pengutronix.de> <20100817043612.GA9631@jasper.tkos.co.il> <20100817064734.GS27749@pengutronix.de>
In-Reply-To: <20100817064734.GS27749@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008181317.48948.philippe.retornaz@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi, 17 août 2010 08.47:34, Sascha Hauer a écrit :
> On Tue, Aug 17, 2010 at 07:36:12AM +0300, Baruch Siach wrote:
> > Hi Sascha,
> >
> > On Mon, Aug 16, 2010 at 04:15:40PM +0200, Sascha Hauer wrote:
> > > On Mon, Aug 16, 2010 at 02:21:06PM +0200, Linus Walleij wrote:
> > > > 2010/8/16 Sascha Hauer <s.hauer@pengutronix.de>:
> > > > > The SDMA engine is a scatter/gather DMA engine which is implemented
> > > > > as a seperate coprocessor. SDMA needs its own firmware which is
> > > > > requested using the standard request_firmware mechanism. The
> > > > > firmware has different entry points for each peripheral type, so
> > > > > drivers have to pass the peripheral type to the DMA engine which in
> > > > > turn picks the correct firmware entry point from a table contained
> > > > > in the firmware image itself.
> > > >
> > > > Quite fun, if the spec for the microcode is open this opens up
> > > > for dynamic firmware generation for specific DMA jobs does it
> > > > not?
> > >
> > > Unfortunately the specs are not open, so we are sticked to the binary
> > > microcode from Freescale. I'm pretty sure though that the SDMA engine
> > > could do at least a device_prep_dma_xor operation.
> >
> > Chapter 38 in the i.MX25 Reference Manual seems to include almost
> > everything there is to know about the SDMA. Isn't this enough for writing
> > custom SDMA microcodes?
> 
> Unfortunately not, the assembler is missing.
> 

I think the instruction list and encoding is available in the imx31 reference 
manual at section 40.19.

BTW, I tested the non-dmaengine version of your patch on imx31, works great !

Regards,

Philippe
