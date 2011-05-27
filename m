Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab1E0DcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:32:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42930 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1E0DcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:32:03 -0400
Date: Thu, 26 May 2011 21:32:01 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:mmc:add the NO_IRQ define to of_mmc_spi.c
Message-ID: <20110527033201.GM5032@ponder.secretlab.ca>
References: <1306242202-9252-1-git-send-email-wanlong.gao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306242202-9252-1-git-send-email-wanlong.gao@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 09:03:22PM +0800, Wanlong Gao wrote:
> For archs that don't support NO_IRQ (such as mips),
> provide a dummy value. Fix the build error for mips.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  drivers/mmc/host/of_mmc_spi.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
> index e2aecb7..ab66f24 100644
> --- a/drivers/mmc/host/of_mmc_spi.c
> +++ b/drivers/mmc/host/of_mmc_spi.c
> @@ -25,6 +25,11 @@
>  #include <linux/mmc/core.h>
>  #include <linux/mmc/host.h>
>  
> +/* For archs that don't support NO_IRQ (such as mips), provide a dummy value */
> +#ifndef NO_IRQ
> +#define NO_IRQ 0
> +#endif
> +
>  MODULE_LICENSE("GPL");
>  
>  enum {
> -- 
> 1.7.4.1
> 
