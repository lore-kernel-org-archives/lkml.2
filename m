Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1JCExp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 00:53:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50253 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab1JCExh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 00:53:37 -0400
MIME-Version: 1.0
In-Reply-To: <1317566760-25681-20-git-send-email-arnd@arndb.de>
References: <1317566760-25681-1-git-send-email-arnd@arndb.de> <1317566760-25681-20-git-send-email-arnd@arndb.de>
From: Govindraj <govindraj.ti@gmail.com>
Date: Mon, 3 Oct 2011 10:23:15 +0530
Message-ID: <CAAL8m4xrLXzHBjM4fmOmSnpvHSBYMSvWewKQg=RjcS79Q2ThUg@mail.gmail.com>
Subject: Re: [PATCH 19/30] tty/serial/omap: console can only be built-in
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Govindraj.R" <govindraj.raja@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 8:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> When the omap serial driver is built as a module, we must
> not allow the console driver to be selected, because consoles
> can not be loadable modules.

Agree.

>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Govindraj.R <govindraj.raja@ti.com>

Acked-by: Govindraj.R <govindraj.raja@ti.com>

> ---
>  drivers/tty/serial/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 4dcb37bb..eb04b2f 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1346,7 +1346,7 @@ config SERIAL_OMAP
>
>  config SERIAL_OMAP_CONSOLE
>        bool "Console on OMAP serial port"
> -       depends on SERIAL_OMAP
> +       depends on SERIAL_OMAP=y
>        select SERIAL_CORE_CONSOLE
>        help
>          Select this option if you would like to use omap serial port as
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
