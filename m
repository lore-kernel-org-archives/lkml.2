Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1BRJt6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:49:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55350 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab1BRJt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:49:56 -0500
Date: Fri, 18 Feb 2011 10:49:49 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/7] Add a mfd IPUv3 driver
Message-ID: <20110218094949.GJ24426@pengutronix.de>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
 <1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
 <871v36pm5r.fsf@lechat.rtp-net.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871v36pm5r.fsf@lechat.rtp-net.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:47:51 up 1 day, 21:45, 50 users,  load average: 1.76, 2.63,
 1.56
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 07:10:24PM +0100, Arnaud Patard wrote:
> > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > index 6bafb51b..ffdb37a 100644
> > --- a/drivers/video/Kconfig
> > +++ b/drivers/video/Kconfig
> > @@ -26,6 +26,8 @@ source "drivers/gpu/drm/Kconfig"
> >  
> >  source "drivers/gpu/stub/Kconfig"
> >  
> > +source "drivers/video/imx-ipu-v3/Kconfig"
> > +
> 
> I don't see such a Kconfig file in this patch. Got lost while moving
> from mfd to video ?

Oops, yes still untracked in my repository. Will add in the next series.

> 
>  
> >  config VGASTATE
> >         tristate
> >         default n
> > diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> > index 8c8fabd..f4921ab 100644
> > --- a/drivers/video/Makefile
> > +++ b/drivers/video/Makefile
> > @@ -153,6 +153,7 @@ obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
> >  obj-$(CONFIG_FB_BFIN_7393)        += bfin_adv7393fb.o
> >  obj-$(CONFIG_FB_MX3)		  += mx3fb.o
> >  obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
> > +obj-$(CONFIG_MFD_IMX_IPU_V3)	  += imx-ipu-v3/
> 
> Now that files are in drivers/video, do we want to keep MFD in the name ?

I asked myself the same question and had no clear answer. Probably
better to remove the MFD.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
