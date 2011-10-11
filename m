Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab1JKVzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 17:55:10 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:44256 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751084Ab1JKVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:55:09 -0400
Message-ID: <4E94BB3B.9030508@xenotime.net>
Date: Tue, 11 Oct 2011 14:55:07 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: gpio-regulator add dependency on GENERIC_GPIO
References: <201110112311.02195.heiko@sntech.de>
In-Reply-To: <201110112311.02195.heiko@sntech.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/11 14:11, Heiko Stübner wrote:
> Without GENERIC_GPIO "struct gpio" is undefined leading to errors.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Works for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  drivers/regulator/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> index 5e0c7b6..9713b1b 100644
> --- a/drivers/regulator/Kconfig
> +++ b/drivers/regulator/Kconfig
> @@ -66,6 +66,7 @@ config REGULATOR_USERSPACE_CONSUMER
>  
>  config REGULATOR_GPIO
>  	tristate "GPIO regulator support"
> +	depends on GENERIC_GPIO
>  	help
>  	  This driver provides support for regulators that can be
>  	  controlled via gpios.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
