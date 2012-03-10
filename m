Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2CJWBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:01:18 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:18030 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2CJWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:01:15 -0500
Date: Sat, 10 Mar 2012 22:59:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
cc: Felipe Balbi <balbi@ti.com>, trivial@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: Kconfig: fix typo for 'different'
In-Reply-To: <1331415859-23291-1-git-send-email-fabio.baltieri@gmail.com>
Message-ID: <alpine.LNX.2.00.1203102259210.1370@swampdragon.chaosbits.net>
References: <1331415859-23291-1-git-send-email-fabio.baltieri@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2012, Fabio Baltieri wrote:

> Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> ---
>  drivers/usb/gadget/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 7ecb68a..b5972e0 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -685,7 +685,7 @@ config USB_G_NCM
>  	help
>  	  This driver implements USB CDC NCM subclass standard. NCM is
>  	  an advanced protocol for Ethernet encapsulation, allows grouping
> -	  of several ethernet frames into one USB transfer and diffferent
> +	  of several ethernet frames into one USB transfer and different
>  	  alignment possibilities.
>  
>  	  Say "y" to link the driver statically, or "m" to build a
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

