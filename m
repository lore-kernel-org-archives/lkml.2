Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab1CRPe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:34:59 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23943 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756556Ab1CRPez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:34:55 -0400
X-SpamScore: -26
X-BigFish: VS-26(zz542N1432N98dN9371Pzz1202hzz8275bhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Fabio Estevam <festevam@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "arnaud.patard@rtp-net.org" <arnaud.patard@rtp-net.org>,
        Vaidyanathan Ranjani-RA5478 <RA5478@freescale.com>,
        Zhang Lily-R58066 <R58066@freescale.com>
Subject: RE: [PATCHv4 2/3] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Topic: [PATCHv4 2/3] ARM: mx51: Implement code to allow mx51 to enter
 WFI
Thread-Index: AQHL5YF+aCubbSW1pU+Wo5DX672Rz5QzOETw
Date: Fri, 18 Mar 2011 15:34:51 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA1B9CD9@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1300461684-21775-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1300461684-21775-2-git-send-email-Dinh.Nguyen@freescale.com>
 <AANLkTimg6uc9cq53e54BqLsRzPXH1DNBF9cThHavdJs=@mail.gmail.com>
In-Reply-To: <AANLkTimg6uc9cq53e54BqLsRzPXH1DNBF9cThHavdJs=@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.72.69]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2IFZ4GP018649

Hi Fabio,

>-----Original Message-----
>From: Fabio Estevam [mailto:festevam@gmail.com]
>Sent: Friday, March 18, 2011 10:31 AM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
>linux@arm.linux.org.uk; s.hauer@pengutronix.de; u.kleine-
>koenig@pengutronix.de; arnaud.patard@rtp-net.org; Vaidyanathan Ranjani-
>RA5478; Zhang Lily-R58066
>Subject: Re: [PATCHv4 2/3] ARM: mx51: Implement code to allow mx51 to
>enter WFI
>
>Hi Dinh,
>
>On Fri, Mar 18, 2011 at 12:21 PM,  <Dinh.Nguyen@freescale.com> wrote:
>...
>> + Â  Â  Â  /* Enable NEON SRPG for all but MX50TO1.0. */
>> + Â  Â  Â  if (cpu_is_mx51() || cpu_is_mx53())
>> + Â  Â  Â  Â  Â  Â  Â  __raw_writel(arm_srpgcr, MXC_SRPG_NEON_SRPGCR);
>
>The comment says that NEON SRPG should not be enabled for MX50 TO1.0,
>but your code does not check the MX50 silicon revision.

There is no mechanism for checking MX50 Revisions yet. I'll work on adding the MX50 revision check.

Dinh
>
>Regards,
>
>Fabio Estevam

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
