Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab2EJJVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:21:21 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:33092 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932172Ab2EJJVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:21:18 -0400
Message-ID: <1336641674.8605.1.camel@odin>
Subject: Re: [PATCH 1/2] regulator: dummy: Specify a struct device
From: Liam Girdwood <lrg@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 10 May 2012 10:21:14 +0100
In-Reply-To: <1336497380-8341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1336497380-8341-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-08 at 18:16 +0100, Mark Brown wrote:
> This will be becoming mandatory.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/dummy.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/regulator/dummy.c b/drivers/regulator/dummy.c
> index 1571bee..86f655c 100644
> --- a/drivers/regulator/dummy.c
> +++ b/drivers/regulator/dummy.c
> @@ -42,6 +42,7 @@ static int __devinit dummy_regulator_probe(struct platform_device *pdev)
>  	struct regulator_config config = { };
>  	int ret;
>  
> +	config.dev = &pdev->dev;
>  	config.init_data = &dummy_initdata;
>  
>  	dummy_regulator_rdev = regulator_register(&dummy_desc, &config);

Both

Acked-by: Liam Girdwood <lrg@ti.com>

