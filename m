Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab1FUR2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 13:28:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19868 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab1FUR2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 13:28:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 21 Jun 2011 10:27:59 -0700
From: Stephen Warren <swarren@nvidia.com>
To: John Bonesio <bones@secretlab.ca>, Ken Radtke <kradtke@nvidia.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>
Date: Tue, 21 Jun 2011 10:27:57 -0700
Subject: RE: [PATCH] ARM: Tegra: i2c driver
Thread-Topic: [PATCH] ARM: Tegra: i2c driver
Thread-Index: AcwvqXAoR1eTTdk5ShmLzw20RAjhtwAjrsCw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049D2EB8AD@HQMAIL01.nvidia.com>
References: <20110621002318.8086.48367.stgit@riker>
In-Reply-To: <20110621002318.8086.48367.stgit@riker>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5LHSKZI018258

John Bonesio wrote at Monday, June 20, 2011 6:23 PM:
> This patch modifies the tegra i2c driver so that it can be initiailized
> using the device tree along with the devices connected to the i2c bus.

The patch title "ARM: Tegra: i2c driver" doesn't really describe what the
patch does and has the wrong tag; It sounds like adding a new driver.
Perhaps "i2c: Tegra: Add DeviceTree support"?

The code looks fine.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
