Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0JHSd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:33:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50418 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0JHSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:33:54 -0400
Date: Fri, 8 Oct 2010 12:33:51 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: matt mooney <mfm@muteddisk.com>
Cc: kernel-janitors@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 22/24] spi: change to new flag variable
Message-ID: <20101008183351.GK3863@angua.secretlab.ca>
References: <e0bdab5d2e8c52041c003de68ba774c3e706716c.1285355033.git.mfm@muteddisk.com>
 <58b418c2e7311bffb13606a6b94e33ddb7569346.1285355033.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58b418c2e7311bffb13606a6b94e33ddb7569346.1285355033.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 12:17:32PM -0700, matt mooney wrote:
> Replace EXTRA_CFLAGS with ccflags-y.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>

Applied, thanks.

g.

> ---
>  drivers/spi/Makefile |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/spi/Makefile b/drivers/spi/Makefile
> index e9cbd18..66c0c47 100644
> --- a/drivers/spi/Makefile
> +++ b/drivers/spi/Makefile
> @@ -2,9 +2,7 @@
>  # Makefile for kernel SPI drivers.
>  #
>  
> -ifeq ($(CONFIG_SPI_DEBUG),y)
> -EXTRA_CFLAGS += -DDEBUG
> -endif
> +ccflags-$(CONFIG_SPI_DEBUG) := -DDEBUG
>  
>  # small core, mostly translating board-specific
>  # config declarations into driver model code
> -- 
> 1.7.2.1
> 
