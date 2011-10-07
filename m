Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1JGIWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 04:22:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37926 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1JGIWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 04:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-15-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-15-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 7 Oct 2011 16:21:59 +0800
Message-ID: <CAMPhdO-wKa7ULnMZCp0mYadref-VB4-+X87te_9Vnr8gno_=xA@mail.gmail.com>
Subject: Re: [PATCH 14/26] mtd: nand_h1900 never worked
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> This driver has been broken through all of git history and
> cannot even be built. Better mark it as broken. Next stop is
> removing from the tree.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Artem Bityutskiy <dedekind1@gmail.com>
> Cc: Jamie Iles <jamie@jamieiles.com>

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/mtd/nand/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index 4c342523..f85af18 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -92,7 +92,7 @@ config MTD_NAND_EDB7312
>
>  config MTD_NAND_H1900
>        tristate "iPAQ H1900 flash"
> -       depends on ARCH_PXA
> +       depends on ARCH_PXA && BROKEN
>        help
>          This enables the driver for the iPAQ h1900 flash.
>
> --
> 1.7.5.4
>
>
