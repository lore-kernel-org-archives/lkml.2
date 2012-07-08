Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2GHQ5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 12:57:39 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56180 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2GHQ5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 12:57:38 -0400
MIME-Version: 1.0
In-Reply-To: <1341764963-11402-1-git-send-email-tremyfr@yahoo.fr>
References: <1341764963-11402-1-git-send-email-tremyfr@yahoo.fr>
Date: Sun, 8 Jul 2012 13:57:37 -0300
Message-ID: <CAOMZO5BjcnB=CJ=i=V7Ct9oMvgnnbK8AjWvYJZdoVmZu=+_MQQ@mail.gmail.com>
Subject: Re: [PATCH] Add nand platform on imx27 devicetree
From: Fabio Estevam <festevam@gmail.com>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philippe,

On Sun, Jul 8, 2012 at 1:29 PM, Philippe Reynes <tremyfr@yahoo.fr> wrote:
> Signed-off-by: Philippe Reynes <tremyfr@yahoo.fr>
> ---
>  arch/arm/mach-imx/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
> index eff4db5..565422b 100644
> --- a/arch/arm/mach-imx/Kconfig
> +++ b/arch/arm/mach-imx/Kconfig
> @@ -381,6 +381,7 @@ config MACH_IMX27_DT
>         bool "Support i.MX27 platforms from device tree"
>         select SOC_IMX27
>         select USE_OF
> +       select IMX_HAVE_PLATFORM_MXC_NAND

Bu doing this you end up selecting unnecessary code for dt.

I proposed a fix for this already:
http://patchwork.ozlabs.org/patch/168645/

Regards,

Fabio Estevam
