Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2FXOFp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 10:05:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56926 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2FXOFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 10:05:44 -0400
MIME-Version: 1.0
In-Reply-To: <1340545637-5449-6-git-send-email-stigge@antcom.de>
References: <1340545637-5449-1-git-send-email-stigge@antcom.de>
	<1340545637-5449-6-git-send-email-stigge@antcom.de>
Date: Sun, 24 Jun 2012 11:05:41 -0300
Message-ID: <CAAAP30Epd3S9EdKqam2rtL0HH3CXDk30A54sFVN+swOe6ZF2Bw@mail.gmail.com>
Subject: Re: [PATCH 5/7] ARM: LPC32xx: Defconfig update
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        rinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 10:47 AM, Roland Stigge <stigge@antcom.de> wrote:
> This defconfig update for LPC32xx adds interrupt and polled gpio keyboard
> drivers.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  arch/arm/configs/lpc32xx_defconfig |    2 ++
>  1 file changed, 2 insertions(+)
>
> --- linux-2.6.orig/arch/arm/configs/lpc32xx_defconfig
> +++ linux-2.6/arch/arm/configs/lpc32xx_defconfig
> @@ -18,6 +18,7 @@ CONFIG_MODULE_UNLOAD=y
>  # CONFIG_BLK_DEV_BSG is not set
>  CONFIG_PARTITION_ADVANCED=y
>  CONFIG_ARCH_LPC32XX=y
> +CONFIG_KEYBOARD_GPIO_POLLED=y
>  CONFIG_PREEMPT=y
>  CONFIG_AEABI=y
>  CONFIG_ZBOOT_ROM_TEXT=0x0
> @@ -89,6 +90,7 @@ CONFIG_INPUT_MOUSEDEV_SCREEN_X=240
>  CONFIG_INPUT_MOUSEDEV_SCREEN_Y=320
>  CONFIG_INPUT_EVDEV=y
>  # CONFIG_KEYBOARD_ATKBD is not set
> +CONFIG_KEYBOARD_GPIO=y
>  CONFIG_KEYBOARD_LPC32XX=y
>  # CONFIG_INPUT_MOUSE is not set
>  CONFIG_INPUT_TOUCHSCREEN=y
