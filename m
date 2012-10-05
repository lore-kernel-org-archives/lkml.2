Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2JEH3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 03:29:18 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:17027 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2JEH3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 03:29:16 -0400
Date: Fri, 5 Oct 2012 09:28:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel J Blueman <daniel@quora.org>
Cc: "Ben Dooks" <ben-linux@fluff.org>, "Wolfram Sang" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Intel PIIX4 I2C driver build failure
Message-ID: <20121005092857.3403af0c@endymion.delvare>
In-Reply-To: <1349410871-17140-1-git-send-email-daniel@quora.org>
References: <1349410871-17140-1-git-send-email-daniel@quora.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Oct 2012 12:21:11 +0800, Daniel J Blueman wrote:
> Fix build failure in Intel PIIX4 I2C driver.
> 
> Signed-off-by: Daniel J Blueman <daniel@quora.org>
> ---
>  drivers/i2c/busses/i2c-piix4.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/i2c/busses/i2c-piix4.c b/drivers/i2c/busses/i2c-piix4.c
> index ef511df..8bbd6ec 100644
> --- a/drivers/i2c/busses/i2c-piix4.c
> +++ b/drivers/i2c/busses/i2c-piix4.c
> @@ -37,6 +37,7 @@
>  #include <linux/stddef.h>
>  #include <linux/ioport.h>
>  #include <linux/i2c.h>
> +#include <linux/slab.h>
>  #include <linux/init.h>
>  #include <linux/dmi.h>
>  #include <linux/acpi.h>

Good catch. Applied, thanks.

-- 
Jean Delvare
