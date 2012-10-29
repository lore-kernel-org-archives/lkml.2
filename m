Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073Ab2J2IeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 04:34:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46320 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756401Ab2J2IeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 04:34:18 -0400
Date: Mon, 29 Oct 2012 09:34:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Xianhan Yu <aroundight77@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, yxhma <yxhma@163.com>
Subject: Re: [PATCH 1/1] hid:Fix maxcontacts problem on GeneralTouch
 multi-touchscreen.
In-Reply-To: <1351523077-2177-1-git-send-email-aroundight77@gmail.com>
Message-ID: <alpine.LNX.2.00.1210290931580.19184@pobox.suse.cz>
References: <1351523077-2177-1-git-send-email-aroundight77@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2012, Xianhan Yu wrote:

> Fix maxcontacts problem for PWT GeneralTouch multi-touchscreen,modify 
> driver for all GeneralTouch PWT touchscreen.

Could you please provide some more verbose changelog, like what is the 
problem, why the original code was wrong and why the patch fixes the 
problem?

Thanks.

> 
> Signed-off-by: Xianhan Yu <aroundight77@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 3eb02b9..7afeb77 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -210,8 +210,7 @@ static struct mt_class mt_classes[] = {
>  	},
>  	{ .name	= MT_CLS_GENERALTOUCH_PWT_TENFINGERS,
>  		.quirks	= MT_QUIRK_NOT_SEEN_MEANS_UP |
> -			MT_QUIRK_SLOT_IS_CONTACTNUMBER,
> -		.maxcontacts = 10
> +			MT_QUIRK_SLOT_IS_CONTACTNUMBER
>  	},
>  
>  	{ .name = MT_CLS_FLATFROG,
> -- 
> 1.7.9.5
> 

-- 
Jiri Kosina
SUSE Labs
