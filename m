Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2FIMpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2012 08:45:53 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49377 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2FIMpv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2012 08:45:51 -0400
MIME-Version: 1.0
In-Reply-To: <1339217404-26009-1-git-send-email-devendra.aaru@gmail.com>
References: <1339217404-26009-1-git-send-email-devendra.aaru@gmail.com>
Date: Sat, 9 Jun 2012 18:15:49 +0530
Message-ID: <CAK9yfHye4YShGSu9fBqgAP+cEpw-fedpJ7jUJpj+jwo0_V4tng@mail.gmail.com>
Subject: Re: [PATCH] staging/gdm72xx: Remove version.h includes
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sage Ahn <syahn@gctsemi.com>, Ben Chan <benchan@chromium.org>,
        Paul Stewart <pstew@chromium.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Devendra,

I have already submitted a similar patch for the same.

http://permalink.gmane.org/gmane.linux.drivers.driver-project.devel/27044

Regards
Sachin

On 9 June 2012 10:20, Devendra Naga <devendra.aaru@gmail.com> wrote:
> here are the version.h warnings that are reported when ran with
>            make versioncheck
>
> /home/devendra/linux/drivers/staging/gdm72xx/gdm_qos.c: 14 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/gdm_sdio.c: 17 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/gdm_usb.c: 15 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/gdm_wimax.c: 14 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/gdm_wimax.h: 18 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/netlink_k.c: 14 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/sdio_boot.c: 15 linux/version.h not needed.
> /home/devendra/linux/drivers/staging/gdm72xx/usb_boot.c: 16 linux/version.h not needed.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/gdm72xx/gdm_qos.c   |    1 -
>  drivers/staging/gdm72xx/gdm_sdio.c  |    1 -
>  drivers/staging/gdm72xx/gdm_usb.c   |    1 -
>  drivers/staging/gdm72xx/gdm_wimax.c |    1 -
>  drivers/staging/gdm72xx/gdm_wimax.h |    1 -
>  drivers/staging/gdm72xx/netlink_k.c |    1 -
>  drivers/staging/gdm72xx/sdio_boot.c |    1 -
>  drivers/staging/gdm72xx/usb_boot.c  |    1 -
>  8 files changed, 8 deletions(-)
>
> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
> index 0217680..e7134e2 100644
> --- a/drivers/staging/gdm72xx/gdm_qos.c
> +++ b/drivers/staging/gdm72xx/gdm_qos.c
> @@ -11,7 +11,6 @@
>  * GNU General Public License for more details.
>  */
>
> -#include <linux/version.h>
>  #include <linux/etherdevice.h>
>  #include <asm/byteorder.h>
>
> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
> index e1a3dd2..5e19b09 100644
> --- a/drivers/staging/gdm72xx/gdm_sdio.c
> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
> @@ -14,7 +14,6 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>
>  #include <linux/mmc/core.h>
>  #include <linux/mmc/card.h>
> diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
> index 1e9dc0d..880f67d 100644
> --- a/drivers/staging/gdm72xx/gdm_usb.c
> +++ b/drivers/staging/gdm72xx/gdm_usb.c
> @@ -12,7 +12,6 @@
>  */
>
>  #include <linux/module.h>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/usb.h>
>  #include <asm/byteorder.h>
> diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
> index f1936b9..110bdbc 100644
> --- a/drivers/staging/gdm72xx/gdm_wimax.c
> +++ b/drivers/staging/gdm72xx/gdm_wimax.c
> @@ -11,7 +11,6 @@
>  * GNU General Public License for more details.
>  */
>
> -#include <linux/version.h>
>  #include <linux/etherdevice.h>
>  #include <asm/byteorder.h>
>  #include <linux/ip.h>
> diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
> index 023e649..6ec0ab4 100644
> --- a/drivers/staging/gdm72xx/gdm_wimax.h
> +++ b/drivers/staging/gdm72xx/gdm_wimax.h
> @@ -15,7 +15,6 @@
>  #define __GDM_WIMAX_H__
>
>  #include <linux/netdevice.h>
> -#include <linux/version.h>
>  #include <linux/types.h>
>  #include "wm_ioctl.h"
>  #if defined(CONFIG_WIMAX_GDM72XX_QOS)
> diff --git a/drivers/staging/gdm72xx/netlink_k.c b/drivers/staging/gdm72xx/netlink_k.c
> index 292af0f..1c74b08 100644
> --- a/drivers/staging/gdm72xx/netlink_k.c
> +++ b/drivers/staging/gdm72xx/netlink_k.c
> @@ -11,7 +11,6 @@
>  * GNU General Public License for more details.
>  */
>
> -#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/etherdevice.h>
>  #include <linux/netlink.h>
> diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
> index 6ff4dc3..760efee 100644
> --- a/drivers/staging/gdm72xx/sdio_boot.c
> +++ b/drivers/staging/gdm72xx/sdio_boot.c
> @@ -12,7 +12,6 @@
>  */
>
>  #include <linux/module.h>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/mm.h>
> diff --git a/drivers/staging/gdm72xx/usb_boot.c b/drivers/staging/gdm72xx/usb_boot.c
> index 5a0e030..c163bcc 100644
> --- a/drivers/staging/gdm72xx/usb_boot.c
> +++ b/drivers/staging/gdm72xx/usb_boot.c
> @@ -13,7 +13,6 @@
>
>  #include <linux/uaccess.h>
>  #include <linux/module.h>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/mm.h>
>  #include <linux/usb.h>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
