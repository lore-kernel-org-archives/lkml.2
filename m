Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1LUVnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:43:00 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:33240 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754230Ab1LUVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:42:54 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18gtu4stpAgYg72NlPF/90EAlhDNhKSmH4Rk72slO
	iLhXPNQHDYW9hv
Message-ID: <4EF252D2.7000206@gmx.de>
Date: Wed, 21 Dec 2011 21:42:42 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Marek Vasut <marek.vasut@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Wolfgang Denk <wd@denx.de>, Stefano Babic <sbabic@denx.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Axel Lin <axel.lin@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH RESEND] MXSFB: Fix driver registration
References: <1324309079-10739-1-git-send-email-marek.vasut@gmail.com>
In-Reply-To: <1324309079-10739-1-git-send-email-marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 03:37 PM, Marek Vasut wrote:
> The driver should be registered with mxsfb_driver, not with mxsfb_devtype.
> This caused obvious null pointer dereference and crash.
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> Cc: Wolfgang Denk <wd@denx.de>
> Cc: Stefano Babic <sbabic@denx.de>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Huang Shijie <b32955@freescale.com>
> Cc: Axel Lin <axel.lin@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Acked-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/mxsfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 18742c2..d29c7c0 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -902,7 +902,7 @@ static struct platform_driver mxsfb_driver = {
>  	},
>  };
>  
> -module_platform_driver(mxsfb_devtype);
> +module_platform_driver(mxsfb_driver);
>  
>  MODULE_DESCRIPTION("Freescale mxs framebuffer driver");
>  MODULE_AUTHOR("Sascha Hauer, Pengutronix");

