Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2JWKTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:19:36 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60187 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab2JWKTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:19:33 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Thread-Topic: [PATCH 3/4] ARM: OMAP2: gpmc: Add support for BCH ECC scheme
Thread-Index: AQHNqwbqdlAuQrnYe0yMlvLTrfYpApfGss1w
Date: Tue, 23 Oct 2012 10:18:02 +0000
Deferred-Delivery: Tue, 23 Oct 2012 10:17:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9D29C8@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
	<1349274589-11389-4-git-send-email-avinashphilip@ti.com>
 <87vcebvaf5.fsf@macbook.be.48ers.dk>
In-Reply-To: <87vcebvaf5.fsf@macbook.be.48ers.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 00:18:30, Peter Korsgaard wrote:
> >>>>> Philip, Avinash <avinashphilip@ti.com> writes:
> 
>  > Add support for BCH ECC scheme to gpmc driver and also enabling multi
>  > sector read/write. This helps in doing single shot NAND page read and
>  > write.
> 
>  > ECC engine configurations
>  > BCH 4 bit support
>  > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
>  > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
>  > 13 and ecc_size1 as 1.
> 
>  > BCH 8 bit support
>  > 1. write => ECC engine configured in wrap mode 6 and with ecc_size0 as 32.
>  > 2. read  => ECC engine configured in wrap mode 1 and with ecc_size0 as
>  > 26 and ecc_size1 as 2.
> 
>  > Note: For BCH8 ECC bytes set to 14 to make compatible with RBL.
> 
> On what device? In the am335x TRM (spruh73f.pdf) figure 26-15 (pg 4273)
> the rom code is documented to not use any padding on the ECC bytes
> (E.G. oob 2..53):
> 
> http://www.ti.com/litv/pdf/spruh73f
> 
> I see the driver in the u-boot-am33x tree (ti81xx_nand.c) seems to use
> 4x14 bytes as well though, so perhaps that's a bug in the documentation
> instead?

Yes, RBL uses 4x14 bytes.

Thanks
Avinash

> 
> -- 
> Bye, Peter Korsgaard
> 

