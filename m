Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0FUK0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:26:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:48904 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab0FUK0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:26:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="291111936"
Date: Mon, 21 Jun 2010 12:26:28 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100621102627.GB22491@sortiz-mobl>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
 <20100616143041.GC24491@rakim.wolfsonmicro.main>
 <1276719403.3028.50.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276719403.3028.50.camel@odin>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Wed, Jun 16, 2010 at 09:16:43PM +0100, Liam Girdwood wrote:
> On Wed, 2010-06-16 at 15:30 +0100, Mark Brown wrote:
> > On Wed, Jun 16, 2010 at 09:04:16AM +0200, Marek Szyprowski wrote:
> > > From: Kyungmin Park <kyungmin.park@samsung.com>
> > > 
> > > This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> > > is used on Samsung Aquila and GONI boards and provides following
> > > functionalities:
> > > - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
> > >   controllers
> > > - battery charger
> > > 
> > > This patch adds basic driver for voltage regulators and MAX 8998 MFD core.
> > > 
> > > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > 
> > Looks good!
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Samuel, I can take the whole patch via regulator if necessary (providing
> I have your SoB for the mfd part).
Yes, I just replied to Marek's v3 of the patch, by ACKing it.
Thanks for carrying it via your tree.

Cheers,
Samuel.


> Thanks
> 
> Liam
> -- 
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
