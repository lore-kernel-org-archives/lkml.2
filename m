Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0KOD5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:57:47 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43928 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab0KOD5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:57:46 -0500
Date: Sun, 14 Nov 2010 20:57:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Wan ZongShun <mcuos.com@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 28/44] drivers/spi: Remove unnecessary semicolons
Message-ID: <20101115035742.GA19965@angua.secretlab.ca>
References: <cover.1289789604.git.joe@perches.com>
 <fe5e5e0efbd97eaa32530eef5ed47efdc3252dad.1289789605.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe5e5e0efbd97eaa32530eef5ed47efdc3252dad.1289789605.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 14, 2010 at 07:04:47PM -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

applied, thanks.

g.

> ---
>  drivers/spi/amba-pl022.c |    2 +-
>  drivers/spi/spi_nuc900.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/amba-pl022.c b/drivers/spi/amba-pl022.c
> index fb3d1b3..2e50631 100644
> --- a/drivers/spi/amba-pl022.c
> +++ b/drivers/spi/amba-pl022.c
> @@ -956,7 +956,7 @@ static int configure_dma(struct pl022 *pl022)
>  		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
>  		break;
>  	case WRITING_U32:
> -		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;;
> +		tx_conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
>  		break;
>  	}
>  
> diff --git a/drivers/spi/spi_nuc900.c b/drivers/spi/spi_nuc900.c
> index dff63be..d5be18b 100644
> --- a/drivers/spi/spi_nuc900.c
> +++ b/drivers/spi/spi_nuc900.c
> @@ -449,7 +449,7 @@ err_iomap:
>  	release_mem_region(hw->res->start, resource_size(hw->res));
>  	kfree(hw->ioarea);
>  err_pdata:
> -	spi_master_put(hw->master);;
> +	spi_master_put(hw->master);
>  
>  err_nomem:
>  	return err;
> -- 
> 1.7.3.1.g432b3.dirty
> 
