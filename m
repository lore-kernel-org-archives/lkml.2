Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2IFUXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 16:23:22 -0400
Received: from sting.hengli.com.au ([178.18.18.71]:54778 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932179Ab2IFUXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 16:23:20 -0400
Date: Thu, 6 Sep 2012 13:23:15 -0700
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v3 1/2] hw_random: mxc-rnga: Adapt clocks to new i.mx
 clock framework
Message-ID: <20120906202315.GL24269@gondor.apana.org.au>
References: <1346794522-25289-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346794522-25289-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 06:35:21PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Adapt clocks to the new i.mx clock framework and fix the following warning:
> 
> ------------[ cut here ]------------
> WARNING: at drivers/clk/clk.c:511 __clk_enable+0x9c/0xac()
> Modules linked in:
> Backtrace:
> [<800124c8>] (dump_backtrace+0x0/0x10c) from [<804172dc>] (dump_stack+0x18/0x1c)
>  r7:00000009 r6:000001ff r5:8032cb50 r4:00000000
> [<804172c4>] (dump_stack+0x0/0x1c) from [<80021834>] (warn_slowpath_common+0x54)
> [<800217e0>] (warn_slowpath_common+0x0/0x6c) from [<80021870>] (warn_slowpath_n)
>  r9:80581cac r8:8700a9c0 r7:805ab070 r6:80000013 r5:806133d4
> r4:8700a9c0
> [<8002184c>] (warn_slowpath_null+0x0/0x2c) from [<8032cb50>] (__clk_enable+0x9c)
> [<8032cab4>] (__clk_enable+0x0/0xac) from [<8032cb88>] (clk_enable+0x28/0x44)
>  r5:806133d4 r4:8700a9c0
> [<8032cb60>] (clk_enable+0x0/0x44) from [<80560f14>] (mxc_rnga_probe+0x68/0x164)
>  r7:805ab070 r6:8706ec00 r5:80611314 r4:00000000
> [<80560eac>] (mxc_rnga_probe+0x0/0x164) from [<8025914c>] (platform_drv_probe+0)
> [<8025912c>] (platform_drv_probe+0x0/0x24) from [<80257c7c>] (driver_probe_devi)
> [<80257bfc>] (driver_probe_device+0x0/0x204) from [<80257e94>] (__driver_attach)
>  r9:80581cac r8:0000008e r7:00000000 r6:8706ec3c r5:805ab070
> r4:8706ec08
> [<80257e00>] (__driver_attach+0x0/0x98) from [<8025642c>] (bus_for_each_dev+0x6)
>  r7:00000000 r6:80257e00 r5:87035e98 r4:805ab070
> [<802563c4>] (bus_for_each_dev+0x0/0x94) from [<80257adc>] (driver_attach+0x20/)
>  r7:00000000 r6:873f2380 r5:805ab338 r4:805ab070
> [<80257abc>] (driver_attach+0x0/0x28) from [<80256d50>] (bus_add_driver+0x18c/0)
> [<80256bc4>] (bus_add_driver+0x0/0x268) from [<802584c4>] (driver_register+0x80)
> [<80258444>] (driver_register+0x0/0x134) from [<802594f4>] (platform_driver_reg)
>  r7:00000000 r6:805c2e00 r5:00000007 r4:805ab05c
> [<802594a8>] (platform_driver_register+0x0/0x60) from [<80259528>] (platform_dr)
> [<80259508>] (platform_driver_probe+0x0/0xa4) from [<80560ea0>] (mod_init+0x18/)
>  r7:00000000 r6:805c2e00 r5:00000007 r4:87034000
> [<80560e88>] (mod_init+0x0/0x24) from [<800086b4>] (do_one_initcall+0x40/0x194)
> [<80008674>] (do_one_initcall+0x0/0x194) from [<8053d3f4>] (kernel_init+0xfc/0x)
> [<8053d2f8>] (kernel_init+0x0/0x1cc) from [<80027190>] (do_exit+0x0/0x7ec)
> ---[ end trace 4198eed02050f461 ]---
> 
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Both patches applied.  Thanks Fabio.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
