Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2DCSH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:07:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52346 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab2DCSH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:07:57 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Oliver Hartkopp <socketcan@hartkopp.net>
CC: "m.kleine-budde@pengutronix.de" <m.kleine-budde@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Gole, Anant" <anantgole@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH] ARM: OMAP: AM33XX: CAN: d_can: Add support for Bosch
 D_CAN controller
Thread-Topic: [PATCH] ARM: OMAP: AM33XX: CAN: d_can: Add support for Bosch
 D_CAN controller
Thread-Index: AQHNEZXW4WifiYIc20mGGxLe7+r04paJCedg///azYCAAHzvcA==
Date: Tue, 3 Apr 2012 18:07:22 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC1317D8A38@DBDE01.ent.ti.com>
References: <1333456339-9372-1-git-send-email-anilkumar@ti.com>
 <331ABD5ECB02734CA317220B2BBEABC1317D84CC@DBDE01.ent.ti.com>
 <4F7B1D2F.40409@hartkopp.net>
In-Reply-To: <4F7B1D2F.40409@hartkopp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Thanks for the comments,

On Tue, Apr 03, 2012 at 21:24:23, Oliver Hartkopp wrote:
> On 03.04.2012 14:39, AnilKumar, Chimata wrote:
>
> > Hi All,
> >
> > Subject line of this patch should be
> > "ARM: CAN: d_can: Add support for Bosch D_CAN controller"
>
>
> No, the d_can IP core is generally not limited to ARM.
>
>       "can: Add support for Bosch D_CAN controller"
>
> would be perfectly fine.

Agree, I will change the subject line in my next version of patch

>
> The correct way is:
>
> 1. post your new CAN driver to linux-can ML
> 2. When the major reviews & style fixes are done and the driver is fit for
> mainline you can post it on ti-omap ML too
>
> But an initial cross-posting of this CAN driver to netdev ML and linux-kernel
> ML does not help anyone - it only increases traffic & confusion
>

It's true, I will take care from next time onwards

Thanks
AnilKumar
