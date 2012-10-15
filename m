Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2JOS4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:56:47 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41598 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab2JOS4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:56:45 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Philip\, Avinash" <avinashphilip@ti.com>
Cc: <dwmw2@infradead.org>, <artem.bityutskiy@linux.intel.com>,
        <tony@atomide.com>, afzal@ti.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, ivan.djelic@parrot.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] mtd: nand: omap2: Update nerrors using ecc.strength
References: <1349274589-11389-1-git-send-email-avinashphilip@ti.com>
	<1349274589-11389-2-git-send-email-avinashphilip@ti.com>
Date: Mon, 15 Oct 2012 20:56:40 +0200
In-Reply-To: <1349274589-11389-2-git-send-email-avinashphilip@ti.com> (Avinash
	Philip's message of "Wed, 3 Oct 2012 19:59:46 +0530")
Message-ID: <87obk3va1j.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Philip, Avinash <avinashphilip@ti.com> writes:

 > Update number of errors using nand ecc strength.
 > Also add macro definitions BCH8_ERROR_MAX & BCH4_ERROR_MAX

 > Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
 > ---
 > :100644 100644 5b31386... af511a9... M	drivers/mtd/nand/omap2.c
 >  drivers/mtd/nand/omap2.c |   12 ++++++++----
 >  1 files changed, 8 insertions(+), 4 deletions(-)

 > diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
 > index 5b31386..af511a9 100644
 > --- a/drivers/mtd/nand/omap2.c
 > +++ b/drivers/mtd/nand/omap2.c
 > @@ -111,6 +111,9 @@
 >  #define	ECCCLEAR			0x100
 >  #define	ECC1				0x1
 
 > +#define BCH8_MAX_ERROR		8	/* upto 8 bit coorectable */
 > +#define BCH4_MAX_ERROR		4	/* upto 4 bit correctable */

First 'correctable' misspelled.

I don't personally think these defines improve readability very much
compared to to just using 4/8, though.

-- 
Bye, Peter Korsgaard
