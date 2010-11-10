Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0KJVkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:40:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:15628 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0KJVko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:40:44 -0500
Date: Wed, 10 Nov 2010 22:29:02 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stefan Weil <weil@mail.berlios.de>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix spelling in MODULE_ALIAS
In-Reply-To: <1289164471-9080-1-git-send-email-weil@mail.berlios.de>
Message-ID: <alpine.LNX.2.00.1011102227590.625@swampdragon.chaosbits.net>
References: <1289164471-9080-1-git-send-email-weil@mail.berlios.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Stefan Weil wrote:

> platfrom -> platform
> 
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-usb@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/usb/host/ohci-jz4740.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-jz4740.c b/drivers/usb/host/ohci-jz4740.c
> index 10e1872..931d588 100644
> --- a/drivers/usb/host/ohci-jz4740.c
> +++ b/drivers/usb/host/ohci-jz4740.c
> @@ -273,4 +273,4 @@ static struct platform_driver ohci_hcd_jz4740_driver = {
>  	},
>  };
>  
> -MODULE_ALIAS("platfrom:jz4740-ohci");
> +MODULE_ALIAS("platform:jz4740-ohci");
> 

Looks fine to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

