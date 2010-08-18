Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab0HRN3w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:29:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64096 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0HRN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:29:48 -0400
Subject: Re: [PATCH] regulator: tps6507x - remove incorrect comments
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1281796333.3780.4.camel@phoenix>
References: <1281796333.3780.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 14:29:44 +0100
Message-ID: <1282138184.3117.425.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-14 at 22:32 +0800, Axel Lin wrote:
> This driver is a platform driver, not a i2c driver.
> Thus remove incorrect tps6507x_remove comments.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps6507x-regulator.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/regulator/tps6507x-regulator.c b/drivers/regulator/tps6507x-regulator.c
> index c239f42..020f587 100644
> --- a/drivers/regulator/tps6507x-regulator.c
> +++ b/drivers/regulator/tps6507x-regulator.c
> @@ -626,12 +626,6 @@ fail:
>  	return error;
>  }
>  
> -/**
> - * tps6507x_remove - TPS6507x driver i2c remove handler
> - * @client: i2c driver client device structure
> - *
> - * Unregister TPS driver as an i2c client device driver
> - */
>  static int __devexit tps6507x_pmic_remove(struct platform_device *pdev)
>  {
>  	struct tps6507x_dev *tps6507x_dev = platform_get_drvdata(pdev);

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

