Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2KVUKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:10:12 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55980 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2KVUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:10:10 -0500
MIME-Version: 1.0
In-Reply-To: <1353541372.12585.14.camel@laptop>
References: <1353541372.12585.14.camel@laptop>
Date: Wed, 21 Nov 2012 20:08:55 -0800
Message-ID: <CAN8TOE-10VYTOS8EbPWxs0HyhdeZBzxL_8gmJsMmXPO1ti_6bQ@mail.gmail.com>
Subject: Re: [PATCH] mtd cs553x_nand: Initialise ecc.strength before nand_scan()
From: Brian Norris <computersforpeace@gmail.com>
To: Nathan Williams <nathan@traverse.com.au>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Dunn <mikedunn@newsguy.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 3:42 PM, Nathan Williams <nathan@traverse.com.au> wrote:
> Loading cs553x_nand with Hynix H27U1G8F2BTR NAND flash causes this bug:
>
> kernel BUG at drivers/mtd/nand/nand_base.c:3345!
...
> Initialising ecc.strength before the call to nand_scan() fixes this.

Acked-by: Brian Norris <computersforpeace@gmail.com>

BTW, I made a quick read through of the other NAND drivers to look for
similar errors. I think this is the only one where the only
ecc.strenght initialization occurred after the nand_scan() or
nand_scan_tail() call.

Thanks,
Brian
