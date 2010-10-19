Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab0JSHH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 03:07:56 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59728 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933685Ab0JSHHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:07:55 -0400
Date: Tue, 19 Oct 2010 16:08:14 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 5/9 v2] ARM: S3C64XX: add support for mach-mini6410
In-reply-to: <20100929193406.25307.33007.stgit@darius-desktop>
To: "'Darius Augulis'" <augulis.darius@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org
Message-id: <052801cb6f5c$67216fb0$35644f10$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActgDX5MBZRIvEkjRg+nJaB8GUYO3wPOxiZg
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193406.25307.33007.stgit@darius-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> Add support for mini6410 board from FriendlyARM
> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
> 
> Changelog since v1:
>  - Ben's comments about coding style fixed
> 
>  arch/arm/mach-s3c64xx/Kconfig         |   10 ++
>  arch/arm/mach-s3c64xx/Makefile        |    1
>  arch/arm/mach-s3c64xx/mach-mini6410.c |  157
> +++++++++++++++++++++++++++++++++
>  3 files changed, 168 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-s3c64xx/mach-mini6410.c
> 

(snip)

> +
> +MACHINE_START(MINI6410, "MINI6410")
> +	/* Maintainer: Darius Augulis <augulis.darius@gmail.com> */
> +	.phys_io	= S3C_PA_UART & 0xfff00000,
> +	.io_pg_offst	= (((u32)S3C_VA_UART) >> 18) & 0xfffc,

Now, we no need to add above two members since commit 861bd81ee62a0d6759144c22909a8a3938951656 ("arm: remove machine_desc.io_pg_offst and .phys_io") from the arm tree

> +	.boot_params	= S3C64XX_PA_SDRAM + 0x100,
> +
> +	.init_irq	= s3c6410_init_irq,
> +	.map_io		= mini6410_map_io,
> +	.init_machine	= mini6410_machine_init,
> +	.timer		= &s3c24xx_timer,
> +MACHINE_END

Others, looks ok.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

