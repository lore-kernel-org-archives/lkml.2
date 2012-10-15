Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2JOOdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:33:09 -0400
Received: from mail.servus.at ([193.170.194.20]:59385 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898Ab2JOOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:33:07 -0400
Message-ID: <507C1E97.3020006@oberhumer.com>
Date: Mon, 15 Oct 2012 16:32:55 +0200
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.9) Gecko/20121011 Thunderbird/10.0.9
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: akpm@linux-foundation.org, s.hauer@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] lib: decompress_unlzo: Change include file name
References: <1350238390-1549-1-git-send-email-festevam@gmail.com>
In-Reply-To: <1350238390-1549-1-git-send-email-festevam@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Fabio,

that should already be fixed on the "lzo-update" branch at

  git://github.com/markus-oberhumer/linux.git lzo-update

Cheers,
Markus

On 2012-10-14 20:13, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Commit 7c979cebc (lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c) 
> renamed lzo1x_decompress.c file, but missed to update lib/decompress_unlzo.c,
> which breaks imx_v6_v7_defconfig build:
> 
> arch/arm/boot/compressed/../../../../lib/decompress_unlzo.c:34:34: fatal error: lzo/lzo1x_decompress.c: No such file or directory
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  lib/decompress_unlzo.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
> index 4531294..960183d 100644
> --- a/lib/decompress_unlzo.c
> +++ b/lib/decompress_unlzo.c
> @@ -31,7 +31,7 @@
>   */
>  
>  #ifdef STATIC
> -#include "lzo/lzo1x_decompress.c"
> +#include "lzo/lzo1x_decompress_safe.c"
>  #else
>  #include <linux/decompress/unlzo.h>
>  #endif

-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
