Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0IBLN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 07:13:26 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50543 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab0IBLNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 07:13:25 -0400
Date: Thu, 2 Sep 2010 12:13:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH 20/24] msm: MSM8X60 simulator board support
Message-ID: <20100902111310.GY26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org> <1282712273-344-21-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282712273-344-21-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 09:57:49PM -0700, Jeff Ohlstein wrote:
> From: Steve Muckle <smuckle@codeaurora.org>
> 
> Board configuration for MSM8X60 simulation.
> 
> Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig         |    7 +++++++
>  arch/arm/mach-msm/Makefile        |    1 +
>  arch/arm/mach-msm/board-msm8x60.c |   10 +++++++++-
>  3 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
> index 3017e12..d2610a3 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -105,6 +105,13 @@ config MACH_MSM8X60_SURF
>  	help
>  	  Support for the Qualcomm MSM8x60 SURF eval board.
>  
> +config MACH_MSM8X60_SIM
> +	depends on ARCH_MSM8X60
> +	default n

All these 'default n' statements can be removed - n is the default anyway.
