Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2ABH1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:27:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45915 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2ABH12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:27:28 -0500
Date: Mon, 2 Jan 2012 00:27:25 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] gpio: Fix typo in comment in Samsung driver
Message-ID: <20120102072725.GD13015@ponder.secretlab.ca>
References: <20111207162256.GI22355@opensource.wolfsonmicro.com>
 <1323275041-25493-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1323275041-25493-2-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323275041-25493-2-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 12:23:59AM +0800, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Applied, thanks.

g.

> ---
>  drivers/gpio/gpio-samsung.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-samsung.c b/drivers/gpio/gpio-samsung.c
> index f1c1ecd..f44c020 100644
> --- a/drivers/gpio/gpio-samsung.c
> +++ b/drivers/gpio/gpio-samsung.c
> @@ -233,7 +233,7 @@ static int samsung_gpio_setcfg_2bit(struct samsung_gpio_chip *chip,
>   * @chip: The gpio chip that is being configured.
>   * @off: The offset for the GPIO being configured.
>   *
> - * The reverse of samsung_gpio_setcfg_2bit(). Will return a value whicg
> + * The reverse of samsung_gpio_setcfg_2bit(). Will return a value which
>   * could be directly passed back to samsung_gpio_setcfg_2bit(), from the
>   * S3C_GPIO_SPECIAL() macro.
>   */
> -- 
> 1.7.7.3
> 
