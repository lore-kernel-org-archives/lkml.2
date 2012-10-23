Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2JWONG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:13:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34731 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753717Ab2JWOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:13:03 -0400
Date: Tue, 23 Oct 2012 10:13:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2]staging: "ehci-w90x900" Fix typos.
In-Reply-To: <1350973342-3868-1-git-send-email-justinmattock@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1210231011450.1635-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2012, Justin P. Mattock wrote:

> From: "Justin P. Mattock" <justinmattock@gmail.com>
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
> 
> The below patch fixes a typo in staging: "ehci-w90x900"

What does ehci-w90x900 have to do with staging?

>  drivers/usb/host/ehci-w90x900.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ehci-w90x900.c b/drivers/usb/host/ehci-w90x900.c
> index ec59808..a9c28a0 100644
> --- a/drivers/usb/host/ehci-w90x900.c
> +++ b/drivers/usb/host/ehci-w90x900.c
> @@ -13,7 +13,7 @@
>  
>  #include <linux/platform_device.h>
>  
> -/*ebable phy0 and phy1 for w90p910*/
> +/*enable phy0 and phy1 for w90p910*/

Why bother to correct the spelling without also correcting the missing 
whitespace?

>  #define	ENPHY		(0x01<<8)
>  #define PHY0_CTR	(0xA4)
>  #define PHY1_CTR	(0xA8)

Alan Stern

