Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab2LJGp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:45:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49031 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2LJGpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:45:24 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: RE: [PATCH v3 1/3] mtd: nand: omap2: Update nerrors using
 ecc.strength
Thread-Topic: [PATCH v3 1/3] mtd: nand: omap2: Update nerrors using
 ecc.strength
Thread-Index: AQHNzic/oyygUlc/tEivdk+KDbZRxpgJyJuAgABfSOCAAq4JAIAExGZw
Date: Mon, 10 Dec 2012 06:44:02 +0000
Deferred-Delivery: Mon, 10 Dec 2012 06:44:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA1FA1B@DBDE01.ent.ti.com>
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com>
 <1354189595-12784-2-git-send-email-avinashphilip@ti.com>
 <50BF3819.9010200@ti.com>
 <518397C60809E147AF5323E0420B992E3EA1139B@DBDE01.ent.ti.com>
 <50C1C784.4040209@ti.com>
In-Reply-To: <50C1C784.4040209@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBA6jXTA003570

On Fri, Dec 07, 2012 at 16:10:04, Nori, Sekhar wrote:
> On 12/5/2012 6:13 PM, Philip, Avinash wrote:
> > On Wed, Dec 05, 2012 at 17:33:37, Nori, Sekhar wrote:
> >> Hi Avinash,
> >>
> >> On 11/29/2012 5:16 PM, Philip, Avinash wrote:
> >>> Update number of errors using nand ecc strength.
> >>> Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX
> >>
> >> Can you please describe why the original method of setting nerrors was
> >> incorrect? Was it causing any issues in any particular configuration?
> > 
> > It affects the reusability of the code. For example BCH8 with AM335x RBL 
> > compatibility requires  14 bytes instead of 13 byte. So setting nerrors
> > with
> > 	nerrors = (info->nand.ecc.bytes == 13) ? 8 : 4;
> > will break am335x RBL compatibility.
> 
> This should be summarized in the patch description so the motivation is
> clear to those who read the history later.

Ok I will add the details in patch description in next version.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
