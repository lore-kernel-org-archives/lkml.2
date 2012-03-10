Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2CJD5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 22:57:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2CJD5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 22:57:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4][RESEND] spi-topcliff-pch: supports a spi mode setup and bit order setup by IO control
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Wolfram Sang <w.sang@pengutronix.de>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>
In-Reply-To: <1323404009-3476-2-git-send-email-tomoya.rohm@gmail.com>
References: <1323404009-3476-1-git-send-email-tomoya.rohm@gmail.com> <1323404009-3476-2-git-send-email-tomoya.rohm@gmail.com>
Date: Fri, 09 Mar 2012 20:57:41 -0700
Message-Id: <20120310035741.F39203E06B6@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 13:13:28 +0900, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> This patch supports a spi mode setup and bit order setup by IO control.
>     spi mode:     mode 0 to mode 3
>     bit order:    LSB first, MSB first
> 
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Applied, thanks.

g.

> ---
>  drivers/spi/spi-topcliff-pch.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
> index 7339765..1864555 100644
> --- a/drivers/spi/spi-topcliff-pch.c
> +++ b/drivers/spi/spi-topcliff-pch.c
> @@ -1430,6 +1430,7 @@ static int __devinit pch_spi_pd_probe(struct platform_device *plat_dev)
>  	master->num_chipselect = PCH_MAX_CS;
>  	master->setup = pch_spi_setup;
>  	master->transfer = pch_spi_transfer;
> +	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
>  
>  	data->board_dat = board_dat;
>  	data->plat_dev = plat_dev;
> -- 
> 1.7.4.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
