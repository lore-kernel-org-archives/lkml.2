Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1AZDTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 22:19:35 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1AZDTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 22:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <1295834493-5019-29-git-send-email-ccross@android.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-29-git-send-email-ccross@android.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 25 Jan 2011 20:19:12 -0700
X-Google-Sender-Auth: dOoISKseQUE93cVhSAG1-vN9WAw
Message-ID: <AANLkTimKqkKFuKCKPV2jSjUtPqo4tbonwR1iO2rsrK1r@mail.gmail.com>
Subject: Re: [PATCH v2 28/28] ARM: tegra: clock: Add forward reference to
 struct clk
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, konkers@android.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 7:01 PM, Colin Cross <ccross@android.com> wrote:
> Signed-off-by: Colin Cross <ccross@android.com>

Hi Colin,

This build warning exists in current mainline.  It should go out to
Linus now instead of waiting for 2.6.29.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

> ---
>  arch/arm/mach-tegra/include/mach/clk.h    |    2 ++
>  arch/arm/mach-tegra/include/mach/clkdev.h |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-tegra/include/mach/clk.h b/arch/arm/mach-tegra/include/mach/clk.h
> index d772395..a217f68 100644
> --- a/arch/arm/mach-tegra/include/mach/clk.h
> +++ b/arch/arm/mach-tegra/include/mach/clk.h
> @@ -20,6 +20,8 @@
>  #ifndef __MACH_CLK_H
>  #define __MACH_CLK_H
>
> +struct clk;
> +
>  void tegra_periph_reset_deassert(struct clk *c);
>  void tegra_periph_reset_assert(struct clk *c);
>
> diff --git a/arch/arm/mach-tegra/include/mach/clkdev.h b/arch/arm/mach-tegra/include/mach/clkdev.h
> index 412f5c6..66cd3f4 100644
> --- a/arch/arm/mach-tegra/include/mach/clkdev.h
> +++ b/arch/arm/mach-tegra/include/mach/clkdev.h
> @@ -20,6 +20,8 @@
>  #ifndef __MACH_CLKDEV_H
>  #define __MACH_CLKDEV_H
>
> +struct clk;
> +
>  static inline int __clk_get(struct clk *clk)
>  {
>        return 1;
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
