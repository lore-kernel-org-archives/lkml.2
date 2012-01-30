Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2A3Nzt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:55:49 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24219 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2A3Nzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:55:48 -0500
Date: Mon, 30 Jan 2012 14:56:03 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Masanari Iida <standby24x7@gmail.com>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] net: Fix typo in ipw2x00/libipw_rx.c
In-Reply-To: <1327931530-1880-1-git-send-email-standby24x7@gmail.com>
Message-ID: <alpine.LNX.2.00.1201301455280.30118@swampdragon.chaosbits.net>
References: <1327931530-1880-1-git-send-email-standby24x7@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Masanari Iida wrote:

> Correct spelling in "suppported" to "supported" in
> drivers/net/wireless/ipw2x00/libipw_rx.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Looks good to me.

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


> ---
>  drivers/net/wireless/ipw2x00/libipw_rx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2x00/libipw_rx.c b/drivers/net/wireless/ipw2x00/libipw_rx.c
> index 32a9966..c4955d2 100644
> --- a/drivers/net/wireless/ipw2x00/libipw_rx.c
> +++ b/drivers/net/wireless/ipw2x00/libipw_rx.c
> @@ -172,7 +172,7 @@ libipw_rx_frame_mgmt(struct libipw_device *ieee, struct sk_buff *skb,
>  			u16 stype)
>  {
>  	if (ieee->iw_mode == IW_MODE_MASTER) {
> -		printk(KERN_DEBUG "%s: Master mode not yet suppported.\n",
> +		printk(KERN_DEBUG "%s: Master mode not yet supported.\n",
>  		       ieee->dev->name);
>  		return 0;
>  /*
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

