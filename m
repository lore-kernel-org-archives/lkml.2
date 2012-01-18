Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2ARAaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:30:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54488 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab2ARAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:30:18 -0500
Date: Tue, 17 Jan 2012 16:30:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: swarren@nvidia.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: tegra-kbc - remove pre Tegra20 definitions
Message-ID: <20120118003012.GA27489@core.coreip.homeip.net>
References: <1326842810-12039-1-git-send-email-riyer@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326842810-12039-1-git-send-email-riyer@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 03:26:50PM -0800, Rakesh Iyer wrote:
> Add support for Tegra30 by correcting definitions. This is necessary to
> make driver useful in Tegra30.

So what about older versions? There still could be users...

> 
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
> ---
>  arch/arm/mach-tegra/include/mach/kbc.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
> index 4f3572a..3610568 100644
> --- a/arch/arm/mach-tegra/include/mach/kbc.h
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -24,13 +24,8 @@
>  #include <linux/types.h>
>  #include <linux/input/matrix_keypad.h>
>  
> -#ifdef CONFIG_ARCH_TEGRA_2x_SOC
>  #define KBC_MAX_GPIO	24
>  #define KBC_MAX_KPENT	8
> -#else
> -#define KBC_MAX_GPIO	20
> -#define KBC_MAX_KPENT	7
> -#endif
>  
>  #define KBC_MAX_ROW	16
>  #define KBC_MAX_COL	8
> -- 
> 1.7.4.1
> 

-- 
Dmitry
