Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2FTIEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:04:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6839 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2FTIEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:04:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jun 2012 01:01:47 -0700
From: Danny Huang <dahuang@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 20 Jun 2012 16:04:26 +0800
Subject: RE: regulator: tps6586x: What is the meaning of
 TPS6586X_SLEW_RATE_SET setting?
Thread-Topic: regulator: tps6586x: What is the meaning of
 TPS6586X_SLEW_RATE_SET setting?
Thread-Index: Ac1ODNfXIXdePBXsRESmcJhSHAcfAAAqy6GA
Message-ID: <1BA5D2DFD2730747A2B3725B59933B93C18C29D8B4@HKMAIL01.nvidia.com>
References: <1340104522.3964.1.camel@phoenix>
In-Reply-To: <1340104522.3964.1.camel@phoenix>
Accept-Language: zh-TW, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5K84wOJ000773

Hi Axel,

The TPS6586X_SLEW_RATE_SET is not related with hardware register.
It was used to make sure that the slew rate won't be changed by accident.

Thanks,
Danny

-----Original Message-----
From: Axel Lin [mailto:axel.lin@gmail.com] 
Sent: Tuesday, June 19, 2012 19:15
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport; Danny Huang; Liam Girdwood; Mark Brown
Subject: regulator: tps6586x: What is the meaning of TPS6586X_SLEW_RATE_SET setting?

Hi Mike,
While looking at the datasheet (tps65860 and tps65862),
I don't understand why we have TPS6586X_SLEW_RATE_SET (0x08) in the code.

According to the datasheet, BIT3 of SM1SL/SM0SL is not used:

SM1SL [Addr 0x25]
SM0SL [Addr 0x28]
        BIT[2:0] SM0/SM1 SUPPLY RAMP RATE
        BIT[7:3] NOT USED

So why we need to check the "unused bit" in tps6586x_regulator_set_slew_rate()?

        if (!(setting->slew_rate & TPS6586X_SLEW_RATE_SET))
                return 0;

Regards,
Axel

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
