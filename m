Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2GITZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:25:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39720 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2GITZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:25:45 -0400
Date: Mon, 9 Jul 2012 12:25:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] staging/ft1000: fix the spaces issue at the start of
 line
Message-ID: <20120709192541.GA5671@kroah.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
 <1341662719-25752-2-git-send-email-devendra.aaru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341662719-25752-2-git-send-email-devendra.aaru@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 05:35:13PM +0530, Devendra Naga wrote:
> The following warns fixed
> 
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2032: ERROR: code indent should use tabs where possible
> drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2032: WARNING: please, no spaces at the start of a line
> 
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> index 0bd080c..c709671 100644
> --- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> +++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
> @@ -2029,7 +2029,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
>  	ft1000_write_reg(dev, FT1000_REG_SUP_ISR, tempword);
>  
>          // Read interrupt type
> -        inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);
> +		inttype = ft1000_read_reg (dev, FT1000_REG_SUP_ISR);

Did you just indent this one too many tabs?  Remember, a tab is 8
spaces, this should have lined up wit the line above it.  Which, for
some odd reason, is also using spaces, so why didn't that get fixed
also?

thanks,

greg k-h
