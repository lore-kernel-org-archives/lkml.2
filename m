Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1KOSmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 13:42:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6537 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1KOSmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 13:42:20 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 15 Nov 2011 10:42:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Date: Tue, 15 Nov 2011 10:42:16 -0800
Subject: RE: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro define
Thread-Topic: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro define
Thread-Index: AcyjexHX0+FkWweST3OrvfouGlF0rAASvByA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805DF4@HQMAIL01.nvidia.com>
References: <1321350910-8685-1-git-send-email-dong.aisheng@linaro.org>
In-Reply-To: <1321350910-8685-1-git-send-email-dong.aisheng@linaro.org>
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

Dong Aisheng wrote at Tuesday, November 15, 2011 2:55 AM:
...
> diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
...
> -#define MXS_SET		0x4
> -#define MXS_CLR		0x8

If the long-term direction on MXS is to move to gpiolib, won't MX_SET_ADDR
etc. and the inline functions that use it eventually be removed from
mach-mxs/include/mach/mxs.h hence requiring the #define be moved back
into the GPIO driver?

-- 
nvpublic

