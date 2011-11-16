Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1KPDbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 22:31:40 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:33177
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752423Ab1KPDbi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 22:31:38 -0500
X-SpamScore: -19
X-BigFish: VS-19(zz9371K1447M542M1432Nzz1202hzz8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro define
Thread-Topic: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro define
Thread-Index: AQHMo3sQH1uSMXK7A0CXBFeCz5DabpWuqjYAgAAqs5A=
Date: Wed, 16 Nov 2011 03:31:34 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7722D0FA4@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1321350910-8685-1-git-send-email-dong.aisheng@linaro.org>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805DF4@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1740805DF4@HQMAIL01.nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Stephen Warren
> Sent: Wednesday, November 16, 2011 2:42 AM
> To: Dong Aisheng; linux-kernel@vger.kernel.org
> Cc: grant.likely@secretlab.ca; arnd@arndb.de; s.hauer@pengutronix.de; Guo
> Shawn-R65073; kernel@pengutronix.de
> Subject: RE: [PATCH 1/1] gpio: gpio-mxs: remove the duplicated micro
> define
> 
> Dong Aisheng wrote at Tuesday, November 15, 2011 2:55 AM:
> ...
> > diff --git a/drivers/gpio/gpio-mxs.c b/drivers/gpio/gpio-mxs.c
> ...
> > -#define MXS_SET		0x4
> > -#define MXS_CLR		0x8
> 
> If the long-term direction on MXS is to move to gpiolib, won't
It looks gpio-mxs driver is already using gpiolib.

> MX_SET_ADDR etc. and the inline functions that use it eventually be
> removed from mach-mxs/include/mach/mxs.h hence requiring the #define be
> moved back into the GPIO driver?
> 
Yes, i agree with you.
Eventually we will remove using <mach/mxs.h>.
Thanks for the comments.

Regards
Dong Aisheng


