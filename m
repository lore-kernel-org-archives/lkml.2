Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab2JWKTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 06:19:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60184 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2JWKTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 06:19:30 -0400
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
Subject: RE: [PATCH 1/4] mtd: nand: omap2: Update nerrors using ecc.strength
Thread-Topic: [PATCH 1/4] mtd: nand: omap2: Update nerrors using ecc.strength
Thread-Index: AQHNqwbV4W1+YLx0nEWLE2X1/J2tgpfGssjw
Date: Tue, 23 Oct 2012 10:17:55 +0000
Deferred-Delivery: Tue, 23 Oct 2012 10:17:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3E9D29BE@DBDE01.ent.ti.com>
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
	<1349274589-11389-2-git-send-email-avinashphilip@ti.com>
 <87obk3va1j.fsf@macbook.be.48ers.dk>
In-Reply-To: <87obk3va1j.fsf@macbook.be.48ers.dk>
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

On Tue, Oct 16, 2012 at 00:26:40, Peter Korsgaard wrote:
> >>>>> Philip, Avinash <avinashphilip@ti.com> writes:
> 
>  > Update number of errors using nand ecc strength.
>  > Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX
> 
>  > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
>  > ---
>  > :100644 100644 5b31386... af511a9... M	drivers/mtd/nand/omap2.c
>  >  drivers/mtd/nand/omap2.c |   12 ++++++++----
>  >  1 files changed, 8 insertions(+), 4 deletions(-)
> 
>  > diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
>  > index 5b31386..af511a9 100644
>  > --- a/drivers/mtd/nand/omap2.c
>  > +++ b/drivers/mtd/nand/omap2.c
>  > @@ -111,6 +111,9 @@
>  >  #define	ECCCLEAR			0x100
>  >  #define	ECC1				0x1
>  
>  > +#define BCH8_MAX_ERROR		8	/* upto 8 bit coorectable */
>  > +#define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */
> 
> First 'correctable' misspelled.

I will correct it

> 
> I don't personally think these defines improve readability very much
> compared to to just using 4/8, though.

Thought of removing magic numbers & provide information also.

Thanks
Avinash

> 
> -- 
> Bye, Peter Korsgaard
> 

