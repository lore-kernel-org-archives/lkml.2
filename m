Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1HEFZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 01:25:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48188 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1HEFZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 01:25:53 -0400
MIME-Version: 1.0
In-Reply-To: <1312521517-31716-1-git-send-email-bs14@csr.com>
References: <1312521517-31716-1-git-send-email-bs14@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 5 Aug 2011 13:25:32 +0800
Message-ID: <CAGsJ_4zC8xk-9wpgstN82eghhXmuLW6SZSMN=bCufN=zrYYQ=Q@mail.gmail.com>
Subject: Re: [PATCH] CPUIDLE: fix compiling error for ARM and SH
To: torvalds@linux-foundation.org, Len Brown <len.brown@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p755QKU5012508

Sorry for missing Mark and David's patch "[PATCH] cpuidle: Consistent
spelling of cpuidle_idle_call()", pls ignore mine.

2011/8/5 Barry Song <bs14@csr.com>:
> commit a0bfa1373859e9d11dc92561a8667588803e42d8 cause compiling errors for ARM and SH
>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Barry Song <baohua.song@csr.com>
> ---
>  arch/arm/kernel/process.c |    2 +-
>  arch/sh/kernel/idle.c     |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index d7ee0d4..1a347f4 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -197,7 +197,7 @@ void cpu_idle(void)
>                                cpu_relax();
>                        } else {
>                                stop_critical_timings();
> -                               if (cpuidle_call_idle())
> +                               if (cpuidle_idle_call())
>                                        pm_idle();
>                                start_critical_timings();
>                                /*
> diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
> index 3c45de1..32114e0 100644
> --- a/arch/sh/kernel/idle.c
> +++ b/arch/sh/kernel/idle.c
> @@ -101,7 +101,7 @@ void cpu_idle(void)
>                        local_irq_disable();
>                        /* Don't trace irqs off for idle */
>                        stop_critical_timings();
> -                       if (cpuidle_call_idle())
> +                       if (cpuidle_idle_call())
>                                pm_idle();
>                        /*
>                         * Sanity check to ensure that pm_idle() returns
> --
> 1.7.1
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
