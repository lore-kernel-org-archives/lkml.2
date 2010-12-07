Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0LGWXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:23:12 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60020 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0LGWXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:23:11 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] omap1: pm_bus: Fix compilation warning.
Organization: Deep Root Systems, LLC
References: <1291641828-19909-1-git-send-email-marek.belisko@open-nandra.com>
Date: Tue, 07 Dec 2010 14:23:02 -0800
In-Reply-To: <1291641828-19909-1-git-send-email-marek.belisko@open-nandra.com>
	(Marek Belisko's message of "Mon, 6 Dec 2010 14:23:48 +0100")
Message-ID: <87lj41jk8p.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marek Belisko <marek.belisko@open-nandra.com> writes:

> Fix following compilation warning:
> arch/arm/mach-omap1/pm_bus.c: In function 'omap1_pm_runtime_resume':
> arch/arm/mach-omap1/pm_bus.c:51: warning: unused variable 'ret'
>
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

> ---
>  arch/arm/mach-omap1/pm_bus.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-omap1/pm_bus.c b/arch/arm/mach-omap1/pm_bus.c
> index 8b66392..f97c6e9 100644
> --- a/arch/arm/mach-omap1/pm_bus.c
> +++ b/arch/arm/mach-omap1/pm_bus.c
> @@ -48,7 +48,6 @@ static int omap1_pm_runtime_suspend(struct device *dev)
>  
>  static int omap1_pm_runtime_resume(struct device *dev)
>  {
> -	int ret = 0;
>  	struct clk *iclk, *fclk;
>  
>  	dev_dbg(dev, "%s\n", __func__);
