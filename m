Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2H0Sj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:39:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40076 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab2H0Sj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:39:58 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-5-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-5-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 11:39:56 -0700
Message-ID: <CACRpkdaG1Px6bQjhMSZxRByw70cFtKU6uywXeAsZRqG76LjxeQ@mail.gmail.com>
Subject: Re: [RFC PATCH 4/17] input: RMI4 configs and makefiles
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

> diff --git a/drivers/input/Makefile b/drivers/input/Makefile
> index 09614ce..cfb383e 100644
> --- a/drivers/input/Makefile
> +++ b/drivers/input/Makefile
> @@ -23,6 +23,6 @@ obj-$(CONFIG_INPUT_TABLET)    += tablet/
>  obj-$(CONFIG_INPUT_TOUCHSCREEN)        += touchscreen/
>  obj-$(CONFIG_INPUT_MISC)       += misc/
>
> -obj-$(CONFIG_INPUT_APMPOWER)   += apm-power.o
> +obj-$(CONFIG_INPUT_RMI4) += rmi4/
>
> -obj-$(CONFIG_XEN_KBDDEV_FRONTEND)      += xen-kbdfront.o
> +obj-$(CONFIG_INPUT_APMPOWER)   += apm-power.o

Don't touch the other stuff, you just deleted the Xen Kbddev here!

> diff --git a/drivers/input/rmi4/Kconfig b/drivers/input/rmi4/Kconfig
(...)
> +config RMI4_BUS
> +       bool "Synaptics RMI4 bus support"
> +       help
> +         Say Y here if you want to support the Synaptics RMI4 bus.  This is
> +         required for all RMI4 device support.
> +
> +         If unsure, say Y.

Are RMI4 devices so common that this should be the recommendation?

Also put the debug options into this file instead of random local
#defines in the other files.

Yours,
Linus Walleij
