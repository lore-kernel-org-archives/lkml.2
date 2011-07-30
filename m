Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1G3TJk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 15:09:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52056 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab1G3TJe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110729211430.6c4830bd.rdunlap@xenotime.net>
References: <20110729173827.716f57ff6e00095a3efc6449@canb.auug.org.au>
	<20110729211430.6c4830bd.rdunlap@xenotime.net>
Date: Sat, 30 Jul 2011 15:09:32 -0400
Message-ID: <CAP=VYLrtumuSM_ncO6sEr7=HciiKcOsB=yN4NZnAxesjSSOgMw@mail.gmail.com>
Subject: Re: [PATCH -next] i2c: i2c-pxa-pci.c needs module.h
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-i2c@vger.kernel.org,
        akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, khali@linux-fr.org,
        ben-linux@fluff.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 12:14 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
>
> i2c-pxa-pci.c uses interfaces from linux/module.h, so it should
> include that file.  This fixes build errors.

Applied to module.h-split, thanks.

P.

>
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/i2c/busses/i2c-pxa-pci.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20110729.orig/drivers/i2c/busses/i2c-pxa-pci.c
> +++ linux-next-20110729/drivers/i2c/busses/i2c-pxa-pci.c
> @@ -3,6 +3,7 @@
>  * It does not support slave mode, the register slightly moved. This PCI
>  * device provides three bars, every contains a single I2C controller.
>  */
> +#include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c/pxa-i2c.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
