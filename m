Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2CVGFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 02:05:33 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2086 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab2CVGF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 02:05:28 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 21 Mar 2012 23:05:27 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 22 Mar 2012 11:35:24 +0530
Subject: RE: [PATCH] regulator: Add TPS65090 regulator driver
Thread-Topic: [PATCH] regulator: Add TPS65090 regulator driver
Thread-Index: Ac0HP9MA/i8rbbDZT0O+46f1CfSdLQAsamnw
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD3127F90@BGMAIL02.nvidia.com>
References: <1332315326-11354-1-git-send-email-vbyravarasu@nvidia.com>
 <20120321085125.GA10935@opensource.wolfsonmicro.com>
In-Reply-To: <20120321085125.GA10935@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

As the MFD got merged in linux-next, can you please review the regulator 
driver patch I sent.

Thanks,
Venu

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, March 21, 2012 2:21 PM
> To: Venu Byravarasu
> Cc: lrg@ti.com; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] regulator: Add TPS65090 regulator driver
> 
> * PGP Signed by an unknown key
> 
> On Wed, Mar 21, 2012 at 01:05:26PM +0530, Venu Byravarasu wrote:
> 
> > @@ -30,6 +30,7 @@ obj-$(CONFIG_REGULATOR_MAX8925) += max8925-
> regulator.o
> >  obj-$(CONFIG_REGULATOR_MAX8952) += max8952.o
> >  obj-$(CONFIG_REGULATOR_MAX8997) += max8997.o
> >  obj-$(CONFIG_REGULATOR_MAX8998) += max8998.o
> > +obj-$(CONFIG_REGULATOR_TPS65090) += tps65090-regulator.o
> >  obj-$(CONFIG_REGULATOR_MC13783) += mc13783-regulator.o
> >  obj-$(CONFIG_REGULATOR_MC13892) += mc13892-regulator.o
> 
> This won't apply against current -next...
> 
> > +       rdev = regulator_register(&ri->desc, &pdev->dev,
> > +                               &tps_pdata->regulator, ri);
> 
> ...and won't build either.
> 
> Always submit against current development versions of the kernel.
> 
> * Unknown Key
> * 0x6E30FDDD
