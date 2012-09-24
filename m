Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab2IXPuL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:50:11 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:37835 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755956Ab2IXPuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:50:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dyVVdlaYahcGv6m2of8o7CC49m1Ljm4U=
Date: Mon, 24 Sep 2012 11:50:02 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the l2-mtd
 tree
Message-ID: <20120924155002.GP5469@titan.lakedaemon.net>
References: <20120924193934.76d4feafb689b265ff49c5c3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924193934.76d4feafb689b265ff49c5c3@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 07:39:34PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the arm-soc tree got a conflict in
> drivers/mtd/nand/orion_nand.c between commit 11a3910e730e ("mtd:
> orion_nand: remove <mach/hardware.h> include") from the l2-mtd tree and
> commit c02cecb92ed4 ("ARM: orion: move platform_data definitions") from
> the arm-soc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The change below is correct, thanks.

thx,

Jason.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/mtd/nand/orion_nand.c
> index 9ee436d,131b58a..0000000
> --- a/drivers/mtd/nand/orion_nand.c
> +++ b/drivers/mtd/nand/orion_nand.c
> @@@ -21,7 -21,8 +21,7 @@@
>   #include <linux/err.h>
>   #include <asm/io.h>
>   #include <asm/sizes.h>
> - #include <plat/orion_nand.h>
>  -#include <mach/hardware.h>
> + #include <linux/platform_data/mtd-orion_nand.h>
>   
>   static void orion_nand_cmd_ctrl(struct mtd_info *mtd, int cmd, unsigned int ctrl)
>   {



> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

