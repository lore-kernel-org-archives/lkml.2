Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab1K1O2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:28:48 -0500
Received: from 64-198-47-7.ip.mcleodusa.net ([64.198.47.7]:14672 "EHLO
	mail02.indesign-llc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1K1O2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:28:47 -0500
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 09:28:47 EST
From: "Barnes, Clifton A." <cabarnes@indesign-llc.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Rapoport <mike@compulab.co.il>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nithish Mahalingam <nithish.mahalingam@intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Balaji Rao <balajirrao@openmoko.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: RE: [PATCH] power_supply: convert drivers/power/* to use
 module_platform_driver()
Thread-Topic: [PATCH] power_supply: convert drivers/power/* to use
 module_platform_driver()
Thread-Index: AQHMq/Be6lnifa8V90eLMNFLK8SPQZXCWdeQ
Date: Mon, 28 Nov 2011 14:25:47 +0000
Message-ID: <A8DC7EA93EFCBD4498E3857AFE65E5F1A5AAB71D@IND07.indesign.net>
References: <1322280070.6458.1.camel@phoenix>
In-Reply-To: <1322280070.6458.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.20.73]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pASESvPW032684

On Fri, Nov 25, 2011, Axel Lin wrote:
> This patch converts the drivers in drivers/power/* to use the
> module_platform_driver() macro which makes the code smaller and a bit 
> simpler.

Acked-by: Clifton Barnes <cabarnes@indesign-llc.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
