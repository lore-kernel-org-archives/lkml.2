Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137Ab2CUUMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:12:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2CUUMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1203211604050.24151@xanadu.home>
References: <alpine.LFD.2.02.1203211604050.24151@xanadu.home>
Date: Wed, 21 Mar 2012 13:12:41 -0700
X-Google-Sender-Auth: 9zWotpyEAek5D0oMl3OQ9WANG64
Message-ID: <CAMbhsRQiuyhSFd9khE6h5qNFeQ0ax587aoALGCdRCGp-9-ktRQ@mail.gmail.com>
Subject: Re: [PATCH] cpu_pm.c: fix various typos
From: Colin Cross <ccross@android.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 1:09 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>
>
> diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
> index 249152e153..9656a3c365 100644
> --- a/kernel/cpu_pm.c
> +++ b/kernel/cpu_pm.c
> @@ -81,7 +81,7 @@ int cpu_pm_unregister_notifier(struct notifier_block *nb)
>  EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
>
>  /**
> - * cpm_pm_enter - CPU low power entry notifier
> + * cpu_pm_enter - CPU low power entry notifier
>  *
>  * Notifies listeners that a single CPU is entering a low power state that may
>  * cause some blocks in the same power domain as the cpu to reset.
> @@ -89,7 +89,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_unregister_notifier);
>  * Must be called on the affected CPU with interrupts disabled.  Platform is
>  * responsible for ensuring that cpu_pm_enter is not called twice on the same
>  * CPU before cpu_pm_exit is called. Notified drivers can include VFP
> - * co-processor, interrupt controller and it's PM extensions, local CPU
> + * co-processor, interrupt controller and its PM extensions, local CPU
>  * timers context save/restore which shouldn't be interrupted. Hence it
>  * must be called with interrupts disabled.
>  *
> @@ -115,13 +115,13 @@ int cpu_pm_enter(void)
>  EXPORT_SYMBOL_GPL(cpu_pm_enter);
>
>  /**
> - * cpm_pm_exit - CPU low power exit notifier
> + * cpu_pm_exit - CPU low power exit notifier
>  *
>  * Notifies listeners that a single CPU is exiting a low power state that may
>  * have caused some blocks in the same power domain as the cpu to reset.
>  *
>  * Notified drivers can include VFP co-processor, interrupt controller
> - * and it's PM extensions, local CPU timers context save/restore which
> + * and its PM extensions, local CPU timers context save/restore which
>  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
>  *
>  * Return conditions are same as __raw_notifier_call_chain.
> @@ -139,7 +139,7 @@ int cpu_pm_exit(void)
>  EXPORT_SYMBOL_GPL(cpu_pm_exit);
>
>  /**
> - * cpm_cluster_pm_enter - CPU cluster low power entry notifier
> + * cpu_cluster_pm_enter - CPU cluster low power entry notifier
>  *
>  * Notifies listeners that all cpus in a power domain are entering a low power
>  * state that may cause some blocks in the same power domain to reset.
> @@ -147,7 +147,7 @@ EXPORT_SYMBOL_GPL(cpu_pm_exit);
>  * Must be called after cpu_pm_enter has been called on all cpus in the power
>  * domain, and before cpu_pm_exit has been called on any cpu in the power
>  * domain. Notified drivers can include VFP co-processor, interrupt controller
> - * and it's PM extensions, local CPU timers context save/restore which
> + * and its PM extensions, local CPU timers context save/restore which
>  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
>  *
>  * Must be called with interrupts disabled.
> @@ -174,7 +174,7 @@ int cpu_cluster_pm_enter(void)
>  EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
>
>  /**
> - * cpm_cluster_pm_exit - CPU cluster low power exit notifier
> + * cpu_cluster_pm_exit - CPU cluster low power exit notifier
>  *
>  * Notifies listeners that all cpus in a power domain are exiting form a
>  * low power state that may have caused some blocks in the same power domain
> @@ -183,7 +183,7 @@ EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
>  * Must be called after cpu_pm_exit has been called on all cpus in the power
>  * domain, and before cpu_pm_exit has been called on any cpu in the power
>  * domain. Notified drivers can include VFP co-processor, interrupt controller
> - * and it's PM extensions, local CPU timers context save/restore which
> + * and its PM extensions, local CPU timers context save/restore which
>  * shouldn't be interrupted. Hence it must be called with interrupts disabled.
>  *
>  * Return conditions are same as __raw_notifier_call_chain.

Acked-by: Colin Cross <ccross@android.com>

Not sure whose tree this would go in through.
