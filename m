Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab2CBIDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 03:03:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5543 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2CBIDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 03:03:09 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 02 Mar 2012 00:02:37 -0800
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>
Date: Fri, 2 Mar 2012 13:32:34 +0530
Subject: RE: [PATCH v6 1/2] mfd: Add anatop mfd driver
Thread-Topic: [PATCH v6 1/2] mfd: Add anatop mfd driver
Thread-Index: Acz4SWAmZswewnW7RAu9KRXg6gueLgAAVmFg
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD2912265@BGMAIL02.nvidia.com>
References: <1330593052-15184-1-git-send-email-paul.liu@linaro.org>
 <1330671641-6439-1-git-send-email-paul.liu@linaro.org>
 <D958900912E20642BCBC71664EFECE3E6DD2912252@BGMAIL02.nvidia.com>
 <4F507C1B.1050909@linaro.org>
In-Reply-To: <4F507C1B.1050909@linaro.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2283vS3015793

> I cannot fully understand. Anatop is not SPI or I2C device. It is
> internally embedded into the SoC. It is directly accessed by memory I/O.

Sorry, I missed this.

> Do you mean I should implement a regmap_bus which uses memory I/O and
> then use regmap?
> 
> Regards,
> Paul
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
