Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab1LSXPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 18:15:04 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33782 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752453Ab1LSXO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 18:14:59 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX180eLwmeXk09A6eYPoEL6WQ0gaMxyidHpwpe7vHmk
	wPtnauUUTFEyKz
Message-ID: <4EEFC56F.3000409@gmx.de>
Date: Mon, 19 Dec 2011 23:14:55 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 1/3] video: convert mbxfb to use module_platform_driver()
References: <1323395873.3740.4.camel@phoenix>
In-Reply-To: <1323395873.3740.4.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 01:57 AM, Axel Lin wrote:
> This patch converts mbxfb to use the module_platform_driver() macro
> which makes the code smaller and a bit simpler.
> 
> Cc: Mike Rapoport <mike@compulab.co.il>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/mbx/mbxfb.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
> index 6ce3416..55bf619 100644
> --- a/drivers/video/mbx/mbxfb.c
> +++ b/drivers/video/mbx/mbxfb.c
> @@ -1053,18 +1053,7 @@ static struct platform_driver mbxfb_driver = {
>  	},
>  };
>  
> -int __devinit mbxfb_init(void)
> -{
> -	return platform_driver_register(&mbxfb_driver);
> -}
> -
> -static void __devexit mbxfb_exit(void)
> -{
> -	platform_driver_unregister(&mbxfb_driver);
> -}
> -
> -module_init(mbxfb_init);
> -module_exit(mbxfb_exit);
> +module_platform_driver(mbxfb_driver);
>  
>  MODULE_DESCRIPTION("loadable framebuffer driver for Marathon device");
>  MODULE_AUTHOR("Mike Rapoport, Compulab");

