Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181Ab1LOFsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:48:46 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:37333 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab1LOFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:48:44 -0500
X-SpamScore: -15
X-BigFish: VS-15(zz9371Ic89bh542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Guo Shawn-R65073 <r65073@freescale.com>
Subject: RE: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
Thread-Topic: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
Thread-Index: AQHMunjd/61Fyc2SoU2quzVm3Ah6epXb4tOAgACCD7A=
Date: Thu, 15 Dec 2011 05:48:38 +0000
Message-ID: <7FE21149F4667147B645348EC6057885052C1B@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1323878622-26602-1-git-send-email-b29396@freescale.com>
	<1323878622-26602-3-git-send-email-b29396@freescale.com>
 <CAOMZO5DVsk_iNCrMaBbK4kuehhL1C71fKqC65isybJDknzWrRQ@mail.gmail.com>
In-Reply-To: <CAOMZO5DVsk_iNCrMaBbK4kuehhL1C71fKqC65isybJDknzWrRQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBF5mq0W006842

> -----Original Message-----
> From: Fabio Estevam [mailto:festevam@gmail.com]
> Sent: Thursday, December 15, 2011 12:01 AM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linus.walleij@stericsson.com;
> s.hauer@pengutronix.de; rob.herring@calxeda.com;
> grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
> kernel@pengutronix.de; Guo Shawn-R65073
> Subject: Re: [RFC PATCH v2 2/4] pinctrl: imx: add pinmux imx driver
> Importance: High
> 
> On Wed, Dec 14, 2011 at 2:03 PM, Dong Aisheng <b29396@freescale.com>
> wrote:
> 
> > +config PINMUX_IMX53
> > + Â  Â  Â  bool "IMX53 pinmux driver"
> > + Â  Â  Â  depends on ARCH_MX5
> 
> Shouldn't this be SOC_IMX53 instead?
> 
Yes, it should be SOC_IMX53.
Thanks.

Regards
Dong Aisheng

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
