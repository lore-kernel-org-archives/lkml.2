Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2KSMp4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 07:45:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43302 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2KSMpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 07:45:54 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
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
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>
Subject: RE: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Topic: [PATCH v2 0/3] mtd: nand: OMAP: ELM error correction support
 for BCH ecc
Thread-Index: AQHNtzjAYJXEaMIpjk+PG7tWZP2/spfqfEcAgAaEjeA=
Date: Mon, 19 Nov 2012 12:44:22 +0000
Deferred-Delivery: Mon, 19 Nov 2012 12:44:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9E8178@DBDE01.ent.ti.com>
References: <1351667307-447-1-git-send-email-avinashphilip@ti.com>
 <1352978534.2221.33.camel@sauron.fi.intel.com>
In-Reply-To: <1352978534.2221.33.camel@sauron.fi.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAJCk2mf014936


On Thu, Nov 15, 2012 at 16:52:14, Artem Bityutskiy wrote:
> On Wed, 2012-10-31 at 12:38 +0530, Philip, Avinash wrote:
> > Support to use ELM as BCH 4 & 8 bit error correction module. Also performance
> > enhancement by adding single shot read_page and write_page functions for the
> > nand flashes with page size less than 4 KB.
> > 
> > ELM module can be used to correct errors reported by BCH 4, 8 & 16 bit
> > ECC scheme. For now only 4 & 8 bit support is added.
> > 
> > BCH 4 & 8 bit error detection support is already available in mainline
> > kernel and works with software error correction.
> > 
> > This series is based on [1] and tested with RFC: OMAP GPMC bindings
> > patch series
> > 
> > 1. linux-next/20121030
> 
> Would you please re-send a version which cleanly applies to the
> l2-mtd.git tree? This series has many conflicts. Thanks!

Artem,

Omap nand driver is being changed considerably with Afzal's omap-gpmc cleanup
series for common arm zImage [2] and those changes move many
of the nand related code from platform folders to omap nand driver.

Omap-gpmc changes are present in Tony's " omap-for-v3.8/cleanup-headers-gpmc"
branch [3]and is present in linux-next also, but is not present in l2-mtd.
Tony has signed tag including omap-gpmc cleanup series,
"omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3-signed" [4]

If this series is made over l2-mtd, and it would cause lot of conflict
with omap-gpmc cleanup series.

I am not sure how this dependency has to be handled for this series,
let me know whether you still want it to be made over l2-mtd?

2. http://markmail.org/message/ev67wm7irgc2qc5d#query:+page:1+mid:wgjdv6fsfghnua5z+state:results
3. http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=shortlog;h=refs/heads/omap-for-v3.8/cleanup-headers-gpmc
4. http://git.kernel.org/?p=linux/kernel/git/tmlind/linux-omap.git;a=tag;h=refs/tags/omap-for-v3.8/cleanup-headers-prepare-multiplatform-v3-signed


Thanks
Avinash

> 
> git://git.infradead.org/users/dedekind/l2-mtd.git
> 
> -- 
> Best Regards,
> Artem Bityutskiy
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
