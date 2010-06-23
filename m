Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806Ab0FWP6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 11:58:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:49879 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab0FWP6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 11:58:45 -0400
Date: Wed, 23 Jun 2010 16:58:43 +0100 (BST)
From: James Simmons <jsimmons@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: linux-fbdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbcon: deinline large static function get_color()
In-Reply-To: <1277233556-14827-1-git-send-email-vda.linux@googlemail.com>
Message-ID: <alpine.LFD.2.00.1006231658320.7462@casper.infradead.org>
References: <1277233556-14827-1-git-send-email-vda.linux@googlemail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This function's body is good two screenfuls and it has six callsites.
> No apparent reason why it is marked "iniline".
> 
> Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>

Signed-off-by: James Simmons <jsimmons@infradead.org>

> ---
>  drivers/video/console/fbcon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
> index b0a3fa0..24983e4 100644
> --- a/drivers/video/console/fbcon.c
> +++ b/drivers/video/console/fbcon.c
> @@ -286,7 +286,7 @@ static inline int fbcon_is_inactive(struct vc_data *vc, struct fb_info *info)
>  		vc->vc_mode != KD_TEXT || ops->graphics);
>  }
>  
> -static inline int get_color(struct vc_data *vc, struct fb_info *info,
> +static int get_color(struct vc_data *vc, struct fb_info *info,
>  	      u16 c, int is_fg)
>  {
>  	int depth = fb_get_color_depth(&info->var, &info->fix);
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
