Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab1LNPrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 10:47:08 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8888 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab1LNPrE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 10:47:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 14 Dec 2011 07:46:58 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 14 Dec 2011 07:46:56 -0800
Subject: RE: [PATCH] pinctrl: add a group-specific hog macro
Thread-Topic: [PATCH] pinctrl: add a group-specific hog macro
Thread-Index: Acy6OvzTErHAbbsjQ+Oo84SEF5qLwQAPGMWA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF176B446FFD@HQMAIL01.nvidia.com>
References: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1323851530-4171-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Wednesday, December 14, 2011 1:32 AM:
> To create elegant tables for pinmux hogs on the PXA MMP platform,
> we need this hog macro that can specify both function and group in
> one go.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@nvidia.com>

That said, when using this, I'd wrap it in a macro that set .name and
.group to the same thing; for system hogs, I'm not sure what other name
would be useful. Should the macro do that?

-- 
nvpublic

