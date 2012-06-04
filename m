Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2FDEMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:12:07 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:54963 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750843Ab2FDEMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:12:05 -0400
Message-ID: <4FCC358E.4000905@xenotime.net>
Date: Sun, 03 Jun 2012 21:11:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH 2/2 v2] crypto: bfin_crc: CRC hardware driver for BF60x
 family processors.
References: <1338782431-24305-1-git-send-email-sonic.adi@gmail.com>
In-Reply-To: <1338782431-24305-1-git-send-email-sonic.adi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2012 09:00 PM, Sonic Zhang wrote:

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 69fdf18..3a05ba9 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -306,4 +306,11 @@ if CRYPTO_DEV_UX500
>  	source "drivers/crypto/ux500/Kconfig"
>  endif # if CRYPTO_DEV_UX500
>  
> +config CRYPTO_DEV_BFIN_CRC
> +	tristate "Support for Blackfin CRC hareware"


	                                   hardware


> +	depends on BF60x
> +	help
> +	  Newer Blackfin processors have CRC hardware. Select this if you
> +	  want to use the Blackfin CRC module.
> +
>  endif # CRYPTO_HW

-- 
~Randy
