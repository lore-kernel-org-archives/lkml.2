Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2BSWoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 17:44:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:52024 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755301Ab2BSWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 17:44:31 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/zA3VsBZ7z+7O3MpgLwmjlyvyNJSe/7lbrOs1aXN
	G/vok3zZ71stFb
Message-ID: <4F417B3F.2050307@gmx.de>
Date: Sun, 19 Feb 2012 22:44:15 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 5/5] fbdev: s/#if CONFIG/#ifdef CONFIG/
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org> <1329664319-3128-5-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1329664319-3128-5-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 03:11 PM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

Acked-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
(I assume you want that to go mainline via Jiri's tree)


Best regards,

Florian Tobias Schandinat

> Cc: linux-fbdev@vger.kernel.org
> ---
>  drivers/video/au1100fb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/au1100fb.c b/drivers/video/au1100fb.c
> index de9da67..4da1895 100644
> --- a/drivers/video/au1100fb.c
> +++ b/drivers/video/au1100fb.c
> @@ -532,7 +532,7 @@ static int __devinit au1100fb_drv_probe(struct platform_device *dev)
>  	for (page = (unsigned long)fbdev->fb_mem;
>  	     page < PAGE_ALIGN((unsigned long)fbdev->fb_mem + fbdev->fb_len);
>  	     page += PAGE_SIZE) {
> -#if CONFIG_DMA_NONCOHERENT
> +#ifdef CONFIG_DMA_NONCOHERENT
>  		SetPageReserved(virt_to_page(CAC_ADDR((void *)page)));
>  #else
>  		SetPageReserved(virt_to_page(page));

