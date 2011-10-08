Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1JHKXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:23:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53982 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab1JHKXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-27-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-27-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 18:22:50 +0800
Message-ID: <CAMPhdO_vpHwTaBt06RQYj88FTg9ZOi4xCBoMMJ-roKWd64-jBQ@mail.gmail.com>
Subject: Re: [PATCH 26/26] ARM: pxa: sharpsl pm needs SPI
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The sharpsl code selects the max1111 spi driver, so it must also
> ensure that SPI itself is enabled. The platform does not work
> without max1111.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied.

> ---
>  arch/arm/mach-pxa/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index 3733971..6dee18e 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -710,6 +710,8 @@ config SHARPSL_PM
>  config SHARPSL_PM_MAX1111
>        bool
>        select HWMON
> +       select SPI
> +       select SPI_MASTER
>        select SENSORS_MAX1111
>
>  config PXA_HAVE_ISA_IRQS
> --
> 1.7.5.4
>
>
