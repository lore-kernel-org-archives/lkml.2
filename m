Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab1AaIUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 03:20:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab1AaIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 03:20:41 -0500
Date: Mon, 31 Jan 2011 09:20:39 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, liu.y.victor@gmail.com, B02280@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110131082039.GK9041@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
 <20110103154214.GB11033@pengutronix.de>
 <20110107120802.GA2354@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110107120802.GA2354@sortiz-mobl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:18:17 up 15 days, 18:24, 15 users,  load average: 0.25, 0.18,
 0.25
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Fri, Jan 07, 2011 at 01:08:03PM +0100, Samuel Ortiz wrote:
> Hi Sascha,
> 
> On Mon, Jan 03, 2011 at 04:42:14PM +0100, Sascha Hauer wrote:
> > On Mon, Dec 20, 2010 at 11:48:41AM +0100, Sascha Hauer wrote:
> > > The IPU is the Image Processing Unit found on i.MX50/51/53 SoCs. It
> > > features several units for image processing, this patch adds support
> > > for the units needed for Framebuffer support, namely:
> > >
> > > - Display Controller (dc)
> > > - Display Interface (di)
> > > - Display Multi Fifo Controller (dmfc)
> > > - Display Processor (dp)
> > > - Image DMA Controller (idmac)
> > >
> > > This patch is based on the Freescale driver, but follows a different
> > > approach. The Freescale code implements logical idmac channels and
> > > the handling of the subunits is hidden in common idmac code pathes
> > > in big switch/case statements. This patch instead just provides code
> > > and resource management for the different subunits. The user, in this
> > > case the framebuffer driver, decides how the different units play
> > > together.
> > >
> > > The IPU has other units missing in this patch:
> > >
> > > - CMOS Sensor Interface (csi)
> > > - Video Deinterlacer (vdi)
> > > - Sensor Multi FIFO Controler (smfc)
> > > - Image Converter (ic)
> > > - Image Rotator (irt)
> > >
> > > So expect more files to come in this directory.
> > >
> > > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > 
> > Hello Samuel,
> > 
> > I see no further comments on this series. Does this mean you are ok with
> > the patch or didn't you find the time looking at it?
> I'm coming back from my xmas holidays today, and haven't had time to look at
> it yet. Hopefully next week.

Ping. I'd like to get this into the next merge window. Right now there
is still enough time for me to react on comments.

Regards,
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
