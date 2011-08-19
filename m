Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1HSXpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 19:45:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:50499 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab1HSXpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 19:45:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,253,1312182000"; 
   d="scan'208";a="9117955"
Date: Sat, 20 Aug 2011 01:47:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Robert Schwebel <rsc@pengutronix.de>
Subject: Re: [PATCH] mfd wm8350: rename static gpio_set_debounce()
Message-ID: <20110819234743.GC3319@sortiz-mobl>
References: <20110810080549.GX31404@pengutronix.de>
 <20110819095326.GB22865@pengutronix.de>
 <20110819215819.GA3772@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110819215819.GA3772@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 10:58:19PM +0100, Mark Brown wrote:
> On Fri, Aug 19, 2011 at 11:53:26AM +0200, Uwe Kleine-König wrote:
> 
> > Can you please apply this patch? Even though it works around something
> > ugly (IMHO), it fixes a build failure on arm/imx. (Not on a vanilla
> > defconfig though.)
> 
> Samuel generally only applies patches about once a month or so.
Actually once every 2 weeks, usually :) I will be catching up with my mfd
patches backlog this weekend.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
