Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1CJPlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:41:37 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60896 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1CJPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:41:35 -0500
Message-ID: <4D78F0D8.7000408@ru.mvista.com>
Date: Thu, 10 Mar 2011 18:40:08 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] msm: 8660: Add clock control regions to iomap
References: <1299732274-10742-1-git-send-email-sboyd@codeaurora.org> <1299732274-10742-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1299732274-10742-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-03-2011 7:44, Stephen Boyd wrote:

> Change-Id: I9e72f10d0da1d6aaaaf7df85d33b998edf424f6f

    This shouldn't be here.

> Signed-off-by: Stephen Boyd<sboyd@codeaurora.org>
[...]

> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> index 3b19b8f..ddfc85b 100644
> --- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> +++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
> @@ -53,6 +53,14 @@
>  #define MSM_TLMM_PHYS		0x00800000
>  #define MSM_TLMM_SIZE		SZ_16K
>
> +#define MSM_CLK_CTL_BASE        IOMEM(0xFA010000)
> +#define MSM_CLK_CTL_PHYS        0x00900000
> +#define MSM_CLK_CTL_SIZE        SZ_16K

    Surrounding code separates the macro names from values by tabs, and you're 
using spaces. Should be more consistent...

> +#define MSM_LPASS_CLK_CTL_BASE  IOMEM(0xFA015000)
> +#define MSM_LPASS_CLK_CTL_PHYS  0x28000000
> +#define MSM_LPASS_CLK_CTL_SIZE  SZ_4K
> +
>  #define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
>  #define MSM_SHARED_RAM_SIZE	SZ_1M

WBR, Sergei
