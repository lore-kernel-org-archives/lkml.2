Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1AGMIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:08:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:15302 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1AGMIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:08:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,288,1291622400"; 
   d="scan'208";a="875364917"
Date: Fri, 7 Jan 2011 13:08:03 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, liu.y.victor@gmail.com, B02280@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110107120802.GA2354@sortiz-mobl>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
 <20110103154214.GB11033@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103154214.GB11033@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Jan 03, 2011 at 04:42:14PM +0100, Sascha Hauer wrote:
> On Mon, Dec 20, 2010 at 11:48:41AM +0100, Sascha Hauer wrote:
> > The IPU is the Image Processing Unit found on i.MX50/51/53 SoCs. It
> > features several units for image processing, this patch adds support
> > for the units needed for Framebuffer support, namely:
> >
> > - Display Controller (dc)
> > - Display Interface (di)
> > - Display Multi Fifo Controller (dmfc)
> > - Display Processor (dp)
> > - Image DMA Controller (idmac)
> >
> > This patch is based on the Freescale driver, but follows a different
> > approach. The Freescale code implements logical idmac channels and
> > the handling of the subunits is hidden in common idmac code pathes
> > in big switch/case statements. This patch instead just provides code
> > and resource management for the different subunits. The user, in this
> > case the framebuffer driver, decides how the different units play
> > together.
> >
> > The IPU has other units missing in this patch:
> >
> > - CMOS Sensor Interface (csi)
> > - Video Deinterlacer (vdi)
> > - Sensor Multi FIFO Controler (smfc)
> > - Image Converter (ic)
> > - Image Rotator (irt)
> >
> > So expect more files to come in this directory.
> >
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> Hello Samuel,
> 
> I see no further comments on this series. Does this mean you are ok with
> the patch or didn't you find the time looking at it?
I'm coming back from my xmas holidays today, and haven't had time to look at
it yet. Hopefully next week.


> This patch can go via the mfd tree or I can push this via my i.MX tree.
> Going via the i.MX tree makes life a bit easier for me because we do not
> run into merge order dependencies. Please let me know what you prefer.
I'm usually fine either way. If taking it through your tree makes your life
easier, then we should go for it.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
