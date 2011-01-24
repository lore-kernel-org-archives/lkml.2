Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab1AXK1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:27:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51051 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab1AXK1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:27:00 -0500
Date: Mon, 24 Jan 2011 10:26:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, konkers@android.com,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 28/28] ARM: tegra: clock: Add forward reference to
	struct clk
Message-ID: <20110124102647.GF16202@n2100.arm.linux.org.uk>
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-29-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295834493-5019-29-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 23, 2011 at 06:01:33PM -0800, Colin Cross wrote:
> diff --git a/arch/arm/mach-tegra/include/mach/clkdev.h b/arch/arm/mach-tegra/include/mach/clkdev.h
> index 412f5c6..66cd3f4 100644
> --- a/arch/arm/mach-tegra/include/mach/clkdev.h
> +++ b/arch/arm/mach-tegra/include/mach/clkdev.h
> @@ -20,6 +20,8 @@
>  #ifndef __MACH_CLKDEV_H
>  #define __MACH_CLKDEV_H
>  
> +struct clk;
> +
>  static inline int __clk_get(struct clk *clk)
>  {
>  	return 1;

If you're having to add that, I suspect this include is being
inappropriately included by files.
