Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab0LONSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 08:18:51 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:36009 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab0LONSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 08:18:50 -0500
Message-ID: <4D08BFFC.3020103@ru.mvista.com>
Date: Wed, 15 Dec 2010 16:17:48 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: davidb@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/7] msm: Physical offset for MSM8960
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1292384961-8851-3-git-send-email-stepanm@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 15-12-2010 6:49, Stepan Moskovchenko wrote:

> Add the physical memory offset value for the Qualcomm
> MSM8960 chip.

> Signed-off-by: Stepan Moskovchenko<stepanm@codeaurora.org>
[...]

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

    Why not:

-#elif defined(CONFIG_ARCH_MSM8X60)
+#elif defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)

WBR, Sergei
