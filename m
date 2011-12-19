Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab1LSNv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:51:27 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49354 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab1LSNv0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:51:26 -0500
MIME-Version: 1.0
In-Reply-To: <1324169888-6687-1-git-send-email-marek.vasut@gmail.com>
References: <1324169888-6687-1-git-send-email-marek.vasut@gmail.com>
Date: Mon, 19 Dec 2011 21:51:24 +0800
Message-ID: <CAAQ0ZWSJ0Yzr2Gk9MBQ0nvVCWxr0yWF_RFTy3isqc0pgEDdRxw@mail.gmail.com>
Subject: Re: [PATCH] MXSFB: Fix driver registration
From: Shawn Guo <shawn.guo@linaro.org>
To: Marek Vasut <marek.vasut@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Wolfgang Denk <wd@denx.de>,
        Stefano Babic <sbabic@denx.de>, Huang Shijie <b32955@freescale.com>,
        Axel Lin <axel.lin@gmail.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-fbdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc-ed Florian and linux-fbdev@vger.kernel.org, as I guess Florian is
the person who will take this patch.

-- Regards,Shawn
On 18 December 2011 08:58, Marek Vasut <marek.vasut@gmail.com> wrote:
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
> ---
>  drivers/video/mxsfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/video/mxsfb.c b/drivers/video/mxsfb.c
> index 18742c2..d29c7c0 100644
> --- a/drivers/video/mxsfb.c
> +++ b/drivers/video/mxsfb.c
> @@ -902,7 +902,7 @@ static struct platform_driver mxsfb_driver = {
>        },
>  };
>
> -module_platform_driver(mxsfb_devtype);
> +module_platform_driver(mxsfb_driver);
>
>  MODULE_DESCRIPTION("Freescale mxs framebuffer driver");
>  MODULE_AUTHOR("Sascha Hauer, Pengutronix");
> --
> 1.7.6.4
>
