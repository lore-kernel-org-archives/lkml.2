Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab0FVILa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 04:11:30 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48168 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab0FVIL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:11:28 -0400
Message-ID: <4C20702C.1080405@cs.helsinki.fi>
Date: Tue, 22 Jun 2010 11:11:24 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Sankar P <sankar.curiosity@gmail.com>
CC: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       linux-sh@vger.kernel.org, lrodriguez@atheros.com,
       catalin.marinas@arm.com, rnagarajan@novell.com, teheo@novell.com,
       linux-mm@kvack.org
Subject: Re: [PATCH] mm: kmemleak: Change kmemleak default buffer size
References: <AANLkTimb7rP0rS0OU8nan5uNEhHx_kEYL99ImZ3c8o0D@mail.gmail.com> <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
In-Reply-To: <1277189909-16376-1-git-send-email-sankar.curiosity@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sankar P wrote:
> If we try to find the memory leaks in kernel that is
> compiled with 'make defconfig', the default buffer size
> seem to be inadequate. Change the buffer size from
> 400 to 1000, which is sufficient in most cases.
> 
> Signed-off-by: Sankar P <sankar.curiosity@gmail.com>
> ---
>  arch/sh/configs/sh7785lcr_32bit_defconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
> index 71f39c7..b02e5ae 100644
> --- a/arch/sh/configs/sh7785lcr_32bit_defconfig
> +++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
> @@ -1710,7 +1710,7 @@ CONFIG_SCHEDSTATS=y
>  # CONFIG_DEBUG_OBJECTS is not set
>  # CONFIG_DEBUG_SLAB is not set
>  CONFIG_DEBUG_KMEMLEAK=y
> -CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
> +CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=1000
>  # CONFIG_DEBUG_KMEMLEAK_TEST is not set
>  CONFIG_DEBUG_PREEMPT=y
>  # CONFIG_DEBUG_RT_MUTEXES is not set

I'm pretty sure you want to do this change in lib/Kconfig.debug.
