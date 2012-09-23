Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab2IWTge (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:36:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60395 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753959Ab2IWTgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:36:33 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX183STckNeo3uYdntz0ltFg4xTPZpbmlh+2zsIsuKZ
	ZcV2bQEY/D4qgF
Message-ID: <505F64B6.9020901@gmx.de>
Date: Sun, 23 Sep 2012 19:36:22 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Damien Cassou <damien.cassou@lifl.fr>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: mbxfb: Include linux/io.h instead of asm/io.h
References: <1346420343.3107.0.camel@phoenix>
In-Reply-To: <1346420343.3107.0.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2012 01:39 PM, Axel Lin wrote:
> This fixes below build error:
> 
>   CC [M]  drivers/video/mbx/mbxfb.o
> drivers/video/mbx/mbxfb.c: In function 'mbxfb_probe':
> drivers/video/mbx/mbxfb.c:942:2: error: implicit declaration of function 'devm_ioremap_nocache' [-Werror=implicit-function-declaration]
> drivers/video/mbx/mbxfb.c:942:22: warning: assignment makes pointer from integer without a cast [enabled by default]
> drivers/video/mbx/mbxfb.c:952:21: warning: assignment makes pointer from integer without a cast [enabled by default]
> cc1: some warnings being treated as errors
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied. Thanks for pointing this out and fixing it.


Best regards,

Florian Tobias Schandinat

> ---
>  drivers/video/mbx/mbxfb.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index 9229acf..6563e50 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -26,8 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/uaccess.h>
> -
> -#include <asm/io.h>
> +#include <linux/io.h>
>  
>  #include <video/mbxfb.h>
>  

