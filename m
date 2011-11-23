Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab1KWGwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:52:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:37445 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755611Ab1KWGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:52:18 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18DJWZDfzYD5SPHFIsmY9noq5ukMz39GcSs4jsHFI
	xM79iW97UelV/i
Message-ID: <4ECC981E.9030703@gmx.de>
Date: Wed, 23 Nov 2011 06:52:14 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Zac Storer <zac.3.14159@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Drivers: video: controlfb: fixed a brace coding style
 issue
References: <1321590896-8249-1-git-send-email-zac.3.14159@gmail.com>
In-Reply-To: <1321590896-8249-1-git-send-email-zac.3.14159@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 04:34 AM, Zac Storer wrote:
> Fixed a brace coding style issue.
> 
> Signed-off-by: Zac Storer <zac.3.14159@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/controlfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
> index 7b2c40a..0c189b3 100644
> --- a/drivers/video/controlfb.c
> +++ b/drivers/video/controlfb.c
> @@ -420,7 +420,7 @@ static int __init init_control(struct fb_info_control *p)
>  
>  	/* Try to pick a video mode out of NVRAM if we have one. */
>  #ifdef CONFIG_NVRAM
> -	if (default_cmode == CMODE_NVRAM){
> +	if (default_cmode == CMODE_NVRAM) {
>  		cmode = nvram_read_byte(NV_CMODE);
>  		if(cmode < CMODE_8 || cmode > CMODE_32)
>  			cmode = CMODE_8;

