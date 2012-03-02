Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2CBRRX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:17:23 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3515 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab2CBRRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:17:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 02 Mar 2012 09:17:18 -0800
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
Date: Fri, 2 Mar 2012 09:17:17 -0800
Subject: RE: [PATCH] pinctrl: fix the pin descriptor kerneldoc
Thread-Topic: [PATCH] pinctrl: fix the pin descriptor kerneldoc
Thread-Index: Acz4jLoKiUVn046DTUKqwW7G7fjXkQAC3Nlw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BE861969@HQMAIL01.nvidia.com>
References: <1330703621-4044-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1330703621-4044-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Friday, March 02, 2012 8:54 AM:
> The introduction of the owner field on the pin descriptor was not
> properly documented so fix this up.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I did have this fix buried later in my patch series, but it's probably a
good idea to patch it separately before then.

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

