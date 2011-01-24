Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab1AXXcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:32:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53196 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1AXXcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:32:18 -0500
Date: Mon, 24 Jan 2011 23:31:38 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Sergei Shtylyov <sshtylyov@mvista.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/11] msm: Physical offset for MSM8960
Message-ID: <20110124233138.GS24104@n2100.arm.linux.org.uk>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1295468747-22796-1-git-send-email-davidb@codeaurora.org> <1295468747-22796-6-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295468747-22796-6-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 12:25:41PM -0800, David Brown wrote:
> From: Stepan Moskovchenko <stepanm@codeaurora.org>
> 
> Add the physical memory offset value for the Qualcomm
> MSM8960 chip.
> 
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
>  arch/arm/mach-msm/include/mach/memory.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
> index 070e17d..014bbd3 100644
> --- a/arch/arm/mach-msm/include/mach/memory.h
> +++ b/arch/arm/mach-msm/include/mach/memory.h
> @@ -25,6 +25,8 @@
>  #define PHYS_OFFSET		UL(0x00200000)
>  #elif defined(CONFIG_ARCH_MSM8X60)
>  #define PHYS_OFFSET		UL(0x40200000)
> +#elif defined(CONFIG_ARCH_MSM8960)
> +#define PHYS_OFFSET		UL(0x40200000)

Note that this will all change during the next merge window to
PLAT_PHYS_OFFSET.

