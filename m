Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1BRMHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:07:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:3516 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1BRMHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:07:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,186,1297065600"; 
   d="scan'208";a="888876692"
Date: Fri, 18 Feb 2011 13:07:17 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>,
        linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/7] Add a mfd IPUv3 driver
Message-ID: <20110218120716.GC15832@sortiz-mobl>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
 <1297865452-32181-2-git-send-email-s.hauer@pengutronix.de>
 <871v36pm5r.fsf@lechat.rtp-net.org>
 <20110218094949.GJ24426@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218094949.GJ24426@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Fri, Feb 18, 2011 at 10:49:49AM +0100, Sascha Hauer wrote:
> On Thu, Feb 17, 2011 at 07:10:24PM +0100, Arnaud Patard wrote:
> > > diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> > > index 6bafb51b..ffdb37a 100644
> > > --- a/drivers/video/Kconfig
> > > +++ b/drivers/video/Kconfig
> > > @@ -26,6 +26,8 @@ source "drivers/gpu/drm/Kconfig"
> > >  
> > >  source "drivers/gpu/stub/Kconfig"
> > >  
> > > +source "drivers/video/imx-ipu-v3/Kconfig"
> > > +
> > 
> > I don't see such a Kconfig file in this patch. Got lost while moving
> > from mfd to video ?
> 
> Oops, yes still untracked in my repository. Will add in the next series.
> 
> > 
> >  
> > >  config VGASTATE
> > >         tristate
> > >         default n
> > > diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> > > index 8c8fabd..f4921ab 100644
> > > --- a/drivers/video/Makefile
> > > +++ b/drivers/video/Makefile
> > > @@ -153,6 +153,7 @@ obj-$(CONFIG_FB_BFIN_T350MCQB)	  += bfin-t350mcqb-fb.o
> > >  obj-$(CONFIG_FB_BFIN_7393)        += bfin_adv7393fb.o
> > >  obj-$(CONFIG_FB_MX3)		  += mx3fb.o
> > >  obj-$(CONFIG_FB_DA8XX)		  += da8xx-fb.o
> > > +obj-$(CONFIG_MFD_IMX_IPU_V3)	  += imx-ipu-v3/
> > 
> > Now that files are in drivers/video, do we want to keep MFD in the name ?
> 
> I asked myself the same question and had no clear answer. Probably
> better to remove the MFD.
Definitely, yes.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
