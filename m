Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2AXVVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:21:34 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:58907 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756653Ab2AXVVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:21:32 -0500
Message-ID: <4F1F2E85.1010505@xenotime.net>
Date: Tue, 24 Jan 2012 14:19:49 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: mc13xxx-regulator-core: Fix the build when
 driver is selected as module
References: <1327437436-10937-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1327437436-10937-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2012 12:37 PM, Fabio Estevam wrote:
> Fix the following build error when mc138xxx driver is built as module:
> 
> ERROR: "mc13xxx_parse_regulators_dt" [drivers/regulator/mc13892-regulator.ko] undefined!
> ERROR: "mc13xxx_get_num_regulators_dt" [drivers/regulator/mc13892-regulator.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/regulator/mc13xxx-regulator-core.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
> index 80ecafe..62dcd0a 100644
> --- a/drivers/regulator/mc13xxx-regulator-core.c
> +++ b/drivers/regulator/mc13xxx-regulator-core.c
> @@ -254,6 +254,7 @@ int __devinit mc13xxx_get_num_regulators_dt(struct platform_device *pdev)
>  
>  	return num;
>  }
> +EXPORT_SYMBOL_GPL(mc13xxx_get_num_regulators_dt);
>  
>  struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
>  	struct platform_device *pdev, struct mc13xxx_regulator *regulators,
> @@ -291,6 +292,7 @@ struct mc13xxx_regulator_init_data * __devinit mc13xxx_parse_regulators_dt(
>  
>  	return data;
>  }
> +EXPORT_SYMBOL_GPL(mc13xxx_parse_regulators_dt);
>  #endif
>  
>  MODULE_LICENSE("GPL v2");


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
