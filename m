Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab2CKPw6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 11:52:58 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:51620 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753453Ab2CKPwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 11:52:55 -0400
Message-ID: <4F5CCA59.3060905@xenotime.net>
Date: Sun, 11 Mar 2012 08:52:57 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regmap: Rejig struct declarations for stubbed API
References: <1331467010-5608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1331467010-5608-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2012 04:56 AM, Mark Brown wrote:

> Ensure we have a forward declaration of struct regmap that isn't just
> the return value of regmap_init() and make the definition of the
> register defaults available.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  include/linux/regmap.h |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 33d5f1d..14b8252 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -16,11 +16,10 @@
>  #include <linux/device.h>
>  #include <linux/list.h>
>  
> -#ifdef CONFIG_REGMAP
> -
>  struct module;
>  struct i2c_client;
>  struct spi_device;
> +struct regmap;
>  
>  /* An enum of all the supported cache types */
>  enum regcache_type {
> @@ -42,6 +41,8 @@ struct reg_default {
>  	unsigned int def;
>  };
>  
> +#ifdef CONFIG_REGMAP
> +
>  /**
>   * Configuration for the register map of a device.
>   *



-- 
~Randy
