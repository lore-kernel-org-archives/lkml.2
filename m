Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab0LOPbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 10:31:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:53444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab0LOPb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 10:31:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Date: Wed, 15 Dec 2010 16:31:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, davidb@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org> <1292384961-8851-2-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1292384961-8851-2-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012151631.11574.arnd@arndb.de>
X-Provags-ID: V02:K0:UwpWJjabAgvkyskO6cr6+xGK0AFbAvChniWu3G3bzPw
 XRzTFiXaJ8BsUVs8kSXzYxZuHWMAFwBotvKiHTrOfiG9vcSe+Q
 +lzjqiIQQwd5tqkQPFCUX0r4Pmm6G7fInaJ3KT7ljcY7TPCaKk
 wImQEYvhgNJV0/FONGiUyLHIL4bfXunWgeXRQG41MtxoSCmB4o
 5nQlyd7/KDgs8EkYozWPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 December 2010, Stepan Moskovchenko wrote:
> diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
> index 8e24dd8..4154a0a 100644
> --- a/arch/arm/mach-msm/include/mach/msm_iomap.h
> +++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
> @@ -49,6 +49,8 @@
>  #include "msm_iomap-8x50.h"
>  #elif defined(CONFIG_ARCH_MSM8X60)
>  #include "msm_iomap-8x60.h"
> +#elif defined(CONFIG_ARCH_MSM8960)
> +#include "msm_iomap-8960.h"
>  #else
>  #include "msm_iomap-7x00.h"
>  #endif

As a general comment, try to make the config options like this nonexclusive,
so you can build kernels to run on multiple CPUs.

In this particular case, it's rather confusing, because one would assume
that MSM8960 is a subset of MSM8X60!

	Arnd
