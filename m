Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab1FEHna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 03:43:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36167 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab1FEHn3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 03:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xse54RUsIueTcmSK3aTJ+hkQW/li7JFTB1pD3H6V9CMqf7+hJ41uQT6Uj0dRXP5T3F
         wNOkBKLGe2+BbWWP26gR2Hx9JXlfCmm6rGU0aXqLRECy1zd9AqIuMFdxPWmk28tJs71e
         a6ph0SDNglxXP+725Dr2JhaK28KotYtbXxMwE=
MIME-Version: 1.0
In-Reply-To: <20110605071725.26517.11573.stgit@ponder>
References: <20110605071725.26517.11573.stgit@ponder>
Date: Sun, 5 Jun 2011 13:13:28 +0530
Message-ID: <BANLkTinoEQf2a65KwQZOVK_4H9DSfqybjA@mail.gmail.com>
Subject: Re: [PATCH] spi: reorganize drivers
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 12:48 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> [repost: I had a typo on the spi-devel-general mailing list address]
>
> Sort the SPI makefile and enforce the naming convention spi_*.c for
> spi drivers.
>
> This change also rolls the contents of atmel_spi.h into the .c file
> since there is only one user of that particular include file.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/spi/Makefile            |   80 ++++++++-----------
>  drivers/spi/atmel_spi.h         |  167 ---------------------------------------
>  drivers/spi/spi_ath79.c         |    0
>  drivers/spi/spi_atmel.c         |  155 ++++++++++++++++++++++++++++++++++++
>  drivers/spi/spi_au1550.c        |    0
>  drivers/spi/spi_coldfire_qspi.c |    0
>  drivers/spi/spi_davinci.c       |    0
>  drivers/spi/spi_dw.c            |    2
>  drivers/spi/spi_dw.h            |    0
>  drivers/spi/spi_dw_mid.c        |    2
>  drivers/spi/spi_dw_mmio.c       |    2
>  drivers/spi/spi_dw_pci.c        |    2
>  drivers/spi/spi_ep93xx.c        |    0
>  drivers/spi/spi_mpc512x_psc.c   |    0
>  drivers/spi/spi_mpc52xx.c       |    0
>  drivers/spi/spi_mpc52xx_psc.c   |    0
>  drivers/spi/spi_omap2_mcspi.c   |    0
>  drivers/spi/spi_omap_100k.c     |    0
>  drivers/spi/spi_omap_uwire.c    |    0
>  drivers/spi/spi_orion.c         |    0
>  drivers/spi/spi_pl022.c         |    0
>  drivers/spi/spi_pxa2xx.c        |    0
>  drivers/spi/spi_pxa2xx_pci.c    |    0
>  drivers/spi/spi_ti_ssp.c        |    0
>  drivers/spi/spi_tle62x0.c       |    0
>  drivers/spi/spi_xilinx.c        |    0

Though the spi_ prefix seems redundant considering the files are in
'spi' directory.
Just a thought, no objection.
