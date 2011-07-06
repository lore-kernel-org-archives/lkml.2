Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab1GFSbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:31:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:8013 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1GFSbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:31:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,488,1304319600"; 
   d="scan'208";a="22251820"
Date: Wed, 6 Jul 2011 20:32:08 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] regulator/tps65912: storing error codes in u8
Message-ID: <20110706183208.GK3021@sortiz-mobl>
References: <20110623055715.GM14591@shale.localdomain>
 <1309795618.3272.9.camel@odin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309795618.3272.9.camel@odin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Mon, Jul 04, 2011 at 05:06:58PM +0100, Liam Girdwood wrote:
> On Thu, 2011-06-23 at 08:57 +0300, Dan Carpenter wrote:
> > get_ctrl_reg() returns -EINVAL so the error handling won't work here
> > if reg is a u8.
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
> > index d2c6542..3a9313e 100644
> > --- a/drivers/regulator/tps65912-regulator.c
> > +++ b/drivers/regulator/tps65912-regulator.c
> > @@ -417,7 +417,7 @@ static int tps65912_reg_enable(struct regulator_dev *dev)
> >  	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
> >  	struct tps65912 *mfd = pmic->mfd;
> >  	int id = rdev_get_id(dev);
> > -	u8 reg;
> > +	int reg;
> >  
> >  	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
> >  		return -EINVAL;
> 
> Samuel, would you mind taking this since tps65912 is upstreaming via
> mfd.
Sure. Would you mind sending the patch to me ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
