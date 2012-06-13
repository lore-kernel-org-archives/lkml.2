Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2FMOUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:20:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FMOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:20:33 -0400
Message-ID: <4FD8A1AE.3040003@linaro.org>
Date: Wed, 13 Jun 2012 15:20:30 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH] regmap: Remove warning on stubbed dev_get_regmap()
References: <1339594736-6712-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1339594736-6712-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/12 14:38, Mark Brown wrote:
> It's perfectly sensible to ask if there's a regmap for a device which
> doesn't have one so the stubbed version shouldn't complain, the caller
> should be prepared for this.
>
> Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> ---
>   include/linux/regmap.h |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 4c9e642..c3508d0 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -388,7 +388,6 @@ static inline int regmap_register_patch(struct regmap *map,
>   static inline struct regmap *dev_get_regmap(struct device *dev,
>   					    const char *name)
>   {
> -	WARN_ONCE(1, "regmap API is disabled");
>   	return NULL;
>   }

Thanks Mark.

Reported-by: Lee Jones <lee.jones@linaro.org>
Tested-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
