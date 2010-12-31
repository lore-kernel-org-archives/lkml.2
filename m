Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0LaGpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 01:45:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34224 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0LaGpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 01:45:19 -0500
Date: Thu, 30 Dec 2010 23:45:15 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to
 disable.
Message-ID: <20101231064515.GC3733@angua.secretlab.ca>
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com>
 <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293750484-1161-2-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 30, 2010 at 03:07:51PM -0800, Justin P. Mattock wrote:
> The below patch fixes a typo "diable" to "disable". Please let me know if this 
> is correct or not.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

applied, thanks.

g.

> 
> ---
>  drivers/spi/dw_spi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/dw_spi.c b/drivers/spi/dw_spi.c
> index 0838c79..7c3cf21 100644
> --- a/drivers/spi/dw_spi.c
> +++ b/drivers/spi/dw_spi.c
> @@ -592,7 +592,7 @@ static void pump_transfers(unsigned long data)
>  		spi_set_clk(dws, clk_div ? clk_div : chip->clk_div);
>  		spi_chip_sel(dws, spi->chip_select);
>  
> -		/* Set the interrupt mask, for poll mode just diable all int */
> +		/* Set the interrupt mask, for poll mode just disable all int */
>  		spi_mask_intr(dws, 0xff);
>  		if (imask)
>  			spi_umask_intr(dws, imask);
> -- 
> 1.6.5.2.180.gc5b3e
> 
> 
> ------------------------------------------------------------------------------
> Learn how Oracle Real Application Clusters (RAC) One Node allows customers
> to consolidate database storage, standardize their database environment, and, 
> should the need arise, upgrade to a full multi-node Oracle RAC database 
> without downtime or disruption
> http://p.sf.net/sfu/oracle-sfdevnl
> _______________________________________________
> spi-devel-general mailing list
> spi-devel-general@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/spi-devel-general
