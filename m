Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2KUHaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 02:30:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51708 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KUHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 02:30:02 -0500
Date: Tue, 20 Nov 2012 23:29:59 -0800
From: Olof Johansson <olof@lixom.net>
To: Doug Anderson <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: exynos: add UART3 to DEBUG_LL ports
Message-ID: <20121121072959.GK7615@quad.lixom.net>
References: <1353451739-6317-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353451739-6317-1-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 02:48:58PM -0800, Doug Anderson wrote:
> From: Olof Johansson <olof@lixom.net>
> 
> UART3 is used for debugging on exynos5250-snow.
> 
> [dianders: cleaned commit message.]
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

> 
> ---
>  arch/arm/Kconfig.debug        |   11 +++++++++++
>  arch/arm/plat-samsung/Kconfig |    1 +
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> index 33a8930..35ba7dc 100644
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@ -355,6 +355,17 @@ choice
>  		  The uncompressor code port configuration is now handled
>  		  by CONFIG_S3C_LOWLEVEL_UART_PORT.
>  
> +	config DEBUG_S3C_UART3
> +		depends on PLAT_SAMSUNG


Sorry, the reason I hadn't re-posted this is that Kukjin had proposed
to protect users of <= 3 UART platforms to select it. An added "Depends
on ARCH_EXYNOS4 || ARCH_EXYNOS5" should cover that. Can you add and
repost, please?


-Olof
