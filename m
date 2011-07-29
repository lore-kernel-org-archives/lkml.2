Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1G2Ogx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 10:36:53 -0400
Received: from void.printf.net ([89.145.121.20]:46962 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1G2Ogw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:36:52 -0400
From: Chris Ball <cjb@laptop.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: sdhci-s3c: Fix build for header change
References: <1311950100-7508-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Fri, 29 Jul 2011 10:36:47 -0400
In-Reply-To: <1311950100-7508-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	(Mark Brown's message of "Fri, 29 Jul 2011 15:35:00 +0100")
Message-ID: <m27h71cfwg.fsf@bob.laptop.org>
User-Agent: Gnus/5.110018 (No Gnus v0.18) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Jul 29 2011, Mark Brown wrote:
> A header change has removed an implicit inclusion of module.h, breaking
> the build due to the use of THIS_MODULE. Fix that.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mmc/host/sdhci-s3c.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
> index 03da44a..2bd7bf4 100644
> --- a/drivers/mmc/host/sdhci-s3c.c
> +++ b/drivers/mmc/host/sdhci-s3c.c
> @@ -19,6 +19,7 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/gpio.h>
> +#include <linux/module.h>
>  
>  #include <linux/mmc/host.h>

Thanks, pushed to mmc-next for 3.1.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
