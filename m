Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab2EIC76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 22:59:58 -0400
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:56970
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789Ab2EIC75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 22:59:57 -0400
X-SpamScore: -8
X-BigFish: VS-8(zz1432Nzz1202hzz8275bh5eeeKz2dh2a8h668h839h8e2h8e3h93fhd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Chen Peter-B29397 <B29397@freescale.com>
To: =?utf-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Li Yang-R58472 <r58472@freescale.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: RE: [PATCH 1/2] usb: fsl_mxc_udc.c: add workaround for ENGcm09152
 for i.MX25
Thread-Topic: [PATCH 1/2] usb: fsl_mxc_udc.c: add workaround for ENGcm09152
 for i.MX25
Thread-Index: AQHNLOrSgxZZssN9KUeqLLBY89v7VZbAxKeQ
Date: Wed, 9 May 2012 02:59:52 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649803B91ED2@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1336461510-30190-1-git-send-email-eric@eukrea.com>
In-Reply-To: <1336461510-30190-1-git-send-email-eric@eukrea.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.2]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4930qHs030877

 
> 
> this patch gives the possibility to workaround bug ENGcm09152
> on i.MX25 when the hardware workaround is also implemented on
> the board.
> It covers the workaround described on page 42 of the following Errata,
> titled "USB: UTMI_USBPHY VBUS input impedance implementation error" :
> http://cache.freescale.com/files/dsp/doc/errata/IMX25CE.pdf
> 

The two patches are ok, I am not sure if sascha is ok for these two
as there is cpu_is_xxx code although it is bug fix.

 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
