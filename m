Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab1A0TEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:04:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40072 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0TEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=FXH6UYIptPejg4g+GpjT4Cbmw8QxtAZFGBuFdlRJXDNZQH4W2yociDvkhlwgsC8ySS
         HXoNgTRXSkoigzmrsSsGuVcR1gSO7fCDXDHEkloGxTuYJ01HFQM0UVWjUspsqqZk7hMl
         40JdsQujW44fb83kfugHj6T1KGa8tmhKpyIHk=
Date: Thu, 27 Jan 2011 21:02:25 +0200
From: Jarkko Nikula <jhnikula@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] arch/arm/mach-omap2/dma.c: Convert IS_ERR result to
 PTR_ERR
Message-Id: <20110127210225.07de155f.jhnikula@gmail.com>
In-Reply-To: <1296143347-17508-1-git-send-email-julia@diku.dk>
References: <1296143347-17508-1-git-send-email-julia@diku.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 16:49:06 +0100
Julia Lawall <julia@diku.dk> wrote:

> diff -u -p a/arch/arm/mach-omap2/dma.c b/arch/arm/mach-omap2/dma.c
> --- a/arch/arm/mach-omap2/dma.c
> +++ b/arch/arm/mach-omap2/dma.c
> @@ -264,7 +264,7 @@ static int __init omap2_system_dma_init_
>  	if (IS_ERR(od)) {
>  		pr_err("%s: Cant build omap_device for %s:%s.\n",
>  			__func__, name, oh->name);
> -		return IS_ERR(od);
> +		return PTR_ERR(od);
>  	}
>  
FWIW,

Acked-by: Jarkko Nikula <jhnikula@gmail.com>
