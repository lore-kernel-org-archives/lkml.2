Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab0JZPwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 11:52:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54997 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755231Ab0JZPwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 11:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=O66l28J8iy8IlHvCXq2h2JN+8Np8QKBYcLhGe5JHg9cX39rynt3tuLR5DVQEFrS2eA
         WEDnJy3Yv1iSAfYbihoJsY/cDUsRvZ+Yy7vwWroMWN7ksTeoafZoVY5ll8xn3mKtZv0M
         ILpcjrmwTexGD2dx6GEUh++mBvkpSEoJWTw/A=
Date: Tue, 26 Oct 2010 08:52:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Alessandro Rubini <rubini@cvml.unipv.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] drivers/input/mouse/appletouch.c: Remove
 KERN_DEBUG use from dprintk
Message-ID: <20101026155206.GB13097@core.coreip.homeip.net>
References: <cover.1288059486.git.joe@perches.com>
 <0f8723f18ce30ef726043555baee90d47ee995ca.1288059486.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f8723f18ce30ef726043555baee90d47ee995ca.1288059486.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 07:44:23PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.

> ---
>  drivers/input/mouse/appletouch.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
> index a9cf768..b77f999 100644
> --- a/drivers/input/mouse/appletouch.c
> +++ b/drivers/input/mouse/appletouch.c
> @@ -630,7 +630,7 @@ static void atp_complete_geyser_3_4(struct urb *urb)
>  	/* Just update the base values (i.e. touchpad in untouched state) */
>  	if (dev->data[dev->info->datalen - 1] & ATP_STATUS_BASE_UPDATE) {
>  
> -		dprintk(KERN_DEBUG "appletouch: updated base values\n");
> +		dprintk("appletouch: updated base values\n");
>  
>  		memcpy(dev->xy_old, dev->xy_cur, sizeof(dev->xy_old));
>  		goto exit;
> -- 
> 1.7.3.dirty
> 

-- 
Dmitry
