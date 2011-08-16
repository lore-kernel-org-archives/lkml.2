Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab1HPQ1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:27:42 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11465 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab1HPQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:27:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 16 Aug 2011 09:27:22 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "Russell King - ARM Linux (linux@arm.linux.org.uk)" 
	<linux@arm.linux.org.uk>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 16 Aug 2011 09:27:05 -0700
Subject: RE: [PATCH] ARM: tegra: Add missing include of linux/erron.h and
 linux/types.h
Thread-Topic: [PATCH] ARM: tegra: Add missing include of linux/erron.h and
 linux/types.h
Thread-Index: Acxb05PwtFrP63SJTw+MNge5e4p+7AAXVPhg
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA25328@HQMAIL01.nvidia.com>
References: <1313471744.5824.2.camel@phoenix>
In-Reply-To: <1313471744.5824.2.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p7GGRxZk030012

Axel Lin wrote at Monday, August 15, 2011 11:16 PM:
> Include linux/erron.h to fix below build error.
...
> Include linux/types.h to fix below build error.
...
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> This patch is against linux-next (next-20110815), it fixes the build error with "make
> tegra_defconfig".

Axel,

I posted this same thing a little while back. Russell asked me to perform
some rework on gpio.h that removed the need for errno.h instead. I did
that in:

http://www.spinics.net/lists/linux-tegra/msg01996.html

I'm just waiting for an Ack from Grant Likely on the GPIO driver changes,
and then will place the series into the ARM patch system as Russell
requested.

Thanks for caring about Tegra compile issues:-)

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
