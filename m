Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2BAXhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 18:37:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12861 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab2BAXhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 18:37:51 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 01 Feb 2012 15:37:48 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 1 Feb 2012 15:37:47 -0800
Subject: RE: [PATCH v2] pinctrl: delete raw device pointers in pinmux maps
Thread-Topic: [PATCH v2] pinctrl: delete raw device pointers in pinmux maps
Thread-Index: AczhET3kpWYNrH1PStOmD4UB78Y+IwAKS5iA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178E124918@HQMAIL01.nvidia.com>
References: <1328121721-3438-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1328121721-3438-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, February 01, 2012 11:42 AM:
> After discussion with Mark Brown in an unrelated thread about
> ADC lookups, it came to my knowledge that the ability to pass
> a struct device * in the regulator consumers is just a
> historical artifact, and not really recommended. Since there
> are no in-kernel users of these pointers, we just kill them
> right now, before someone starts to use them.
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Documentation,
Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

