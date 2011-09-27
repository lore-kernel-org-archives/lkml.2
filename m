Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab1I0CIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:08:48 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:34819
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab1I0CIr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:08:47 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz98dKzz1202hzzz2dh2a8h668h839h8e2h8e3h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Tabi Timur-B04825 <B04825@freescale.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: fsl: Fix error handling if platform_device_add
 fails
Thread-Topic: [PATCH] ASoC: fsl: Fix error handling if platform_device_add
 fails
Thread-Index: AQHMd2Q18HB+Qo1MyUeUv/xrAcVwPpVg2cyA
Date: Tue, 27 Sep 2011 02:08:44 +0000
Message-ID: <4E81302B.8060903@freescale.com>
References: <1316502540.4269.1.camel@phoenix>
In-Reply-To: <1316502540.4269.1.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:6.0.2)
 Gecko/20110902 Firefox/6.0.2 SeaMonkey/2.3.3
x-originating-ip: [68.203.10.197]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <7A8BFE884E3AD4449E4CCA22377163A6@freescale.net>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> Call platform_device_put() instead of platform_device_unregister() if
> platform_device_add() fails.

What's wrong with calling platform_device_unregister()?

-- 
Timur Tabi
Linux kernel developer at Freescale
