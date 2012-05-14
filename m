Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab2ENCnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 22:43:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2ENCnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 22:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAG9bXvkn6bm1xXpBxqvOxxzSrPPRdvP7RzKrfhSVJebN54psHQ@mail.gmail.com>
References: <CAG9bXvkn6bm1xXpBxqvOxxzSrPPRdvP7RzKrfhSVJebN54psHQ@mail.gmail.com>
Date: Mon, 14 May 2012 10:43:31 +0800
Message-ID: <CAG9bXvkm6KVRpca9-YBq9oRiUyFLeaD+gwysCjpMO4Xo69XBXQ@mail.gmail.com>
Subject: Re: [PATCH] cpu_pm: fix some typos in comments
From: Raul Xiong <raulxiong@gmail.com>
To: linux-arm-kernel@lists.infradead.org, ccross@android.com, khilman@ti.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        santosh.shilimkar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/5/11 Raul Xiong <raulxiong@gmail.com>:
> Fix some comment typos in function names
>
> Signed-off-by: Raul Xiong <raulxiong@gmail.com>
> ---
>  kernel/cpu_pm.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/cpu_pm.c b/kernel/cpu_pm.c
> index 249152e..957b151 100644
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
> @@ -115,7 +115,7 @@ int cpu_pm_enter(void)
>  EXPORT_SYMBOL_GPL(cpu_pm_enter);
>
>  /**
> - * cpm_pm_exit - CPU low power exit notifier
> + * cpu_pm_exit - CPU low power exit notifier
>  *
>  * Notifies listeners that a single CPU is exiting a low power state that may
>  * have caused some blocks in the same power domain as the cpu to reset.
> @@ -139,7 +139,7 @@ int cpu_pm_exit(void)
>  EXPORT_SYMBOL_GPL(cpu_pm_exit);
>
>  /**
> - * cpm_cluster_pm_enter - CPU cluster low power entry notifier
> + * cpu_cluster_pm_enter - CPU cluster low power entry notifier
>  *
>  * Notifies listeners that all cpus in a power domain are entering a low power
>  * state that may cause some blocks in the same power domain to reset.
> @@ -174,7 +174,7 @@ int cpu_cluster_pm_enter(void)
>  EXPORT_SYMBOL_GPL(cpu_cluster_pm_enter);
>
>  /**
> - * cpm_cluster_pm_exit - CPU cluster low power exit notifier
> + * cpu_cluster_pm_exit - CPU cluster low power exit notifier
>  *
>  * Notifies listeners that all cpus in a power domain are exiting form a
>  * low power state that may have caused some blocks in the same power domain


Hi Colin, all,

Is there any problem to accept this patch?


Raul
Best Regards
