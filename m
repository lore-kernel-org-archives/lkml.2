Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1KXSiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:38:07 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:54180 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752587Ab1KXSiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:38:05 -0500
Message-ID: <4ECE8E71.1080606@xenotime.net>
Date: Thu, 24 Nov 2011 10:35:29 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-next@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: serpent-sse2 - should select CRYPTO_CRYPTD
References: <4ECD527E.8000506@xenotime.net> <20111124063741.17986.23462.stgit@localhost6.localdomain6>
In-Reply-To: <20111124063741.17986.23462.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 10:37 PM, Jussi Kivilinna wrote:
> Since serpent_sse2_glue.c uses cryptd, CRYPTO_SERPENT_SSE2_X86_64 and
> CRYPTO_SERPENT_SSE2_586 should be selecting CRYPTO_CRYPTD.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  crypto/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 16e0c13..b8d1b10 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -770,6 +770,7 @@ config CRYPTO_SERPENT_SSE2_X86_64
>  	tristate "Serpent cipher algorithm (x86_64/SSE2)"
>  	depends on X86 && 64BIT
>  	select CRYPTO_ALGAPI
> +	select CRYPTO_CRYPTD
>  	select CRYPTO_SERPENT
>  	help
>  	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
> @@ -787,6 +788,7 @@ config CRYPTO_SERPENT_SSE2_586
>  	tristate "Serpent cipher algorithm (i586/SSE2)"
>  	depends on X86 && !64BIT
>  	select CRYPTO_ALGAPI
> +	select CRYPTO_CRYPTD
>  	select CRYPTO_SERPENT
>  	help
>  	  Serpent cipher algorithm, by Anderson, Biham & Knudsen.
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
