Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab1LSSaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:30:20 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16487 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab1LSSaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:30:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 Dec 2011 10:30:13 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Date: Mon, 19 Dec 2011 10:29:52 -0800
Subject: RE: [PATCH] pinctrl: rename U300 ans SIRF pin controllers
Thread-Topic: [PATCH] pinctrl: rename U300 ans SIRF pin controllers
Thread-Index: Acy91xAcSQFuSpBrRDuuRERKSI2O+gApNHRQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176BE92A8E@HQMAIL01.nvidia.com>
References: <1324248425-26552-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1324248425-26552-1-git-send-email-linus.walleij@stericsson.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Sunday, December 18, 2011 3:47 PM:
> For stringen order, rename the pinmux-* pin controllers to

I'm not sure what "stringen order" is; perhaps "consistency"?

> pinctrl-* and also rename the Kconfig symbols and in-kernel
> users.
> 
> Cc: Rongjun Ying <Rongjun.Ying@csr.com>
> Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@nvidia.com>

Just one question though:

> diff --git a/drivers/pinctrl/pinmux-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
> similarity index 100%
> rename from drivers/pinctrl/pinmux-sirf.c
> rename to drivers/pinctrl/pinctrl-sirf.c
> diff --git a/drivers/pinctrl/pinmux-u300.c b/drivers/pinctrl/pinctrl-u300.c
> similarity index 100%
> rename from drivers/pinctrl/pinmux-u300.c
> rename to drivers/pinctrl/pinctrl-u300.c

Do you want to change the DRIVER_NAME define in those two drivers and
s/pinmux/pinctrl/ there? Perhaps that's not a good idea, but I thought
I'd ask in case you meant to.

-- 
nvpublic

