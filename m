Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab1KCAQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 20:16:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47136 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab1KCAQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 20:16:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH] CPU hotplug, PM: Remove unused symbol 'suspend_cpu_hotplug'
Date: Thu, 3 Nov 2011 01:19:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: stern@rowland.harvard.edu, akpm@linux-foundation.org, gregkh@suse.de,
        brandon@ifup.org, amwang@redhat.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, a.p.zijlstra@chello.nl, pavel@ucw.cz,
        linux-pm@lists.linux-foundation.org, mingo@elte.hu
References: <20111028134737.18461.60249.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111028134737.18461.60249.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201111030119.14542.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 28, 2011, Srivatsa S. Bhat wrote:
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Applied to linux-pm/linux-next.

Thanks,
Rafael


> ---
> 
>  include/linux/cpu.h |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index b1a635a..6cb60fd 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -196,13 +196,9 @@ static inline void cpu_hotplug_driver_unlock(void)
>  #endif		/* CONFIG_HOTPLUG_CPU */
>  
>  #ifdef CONFIG_PM_SLEEP_SMP
> -extern int suspend_cpu_hotplug;
> -
>  extern int disable_nonboot_cpus(void);
>  extern void enable_nonboot_cpus(void);
>  #else /* !CONFIG_PM_SLEEP_SMP */
> -#define suspend_cpu_hotplug	0
> -
>  static inline int disable_nonboot_cpus(void) { return 0; }
>  static inline void enable_nonboot_cpus(void) {}
>  #endif /* !CONFIG_PM_SLEEP_SMP */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

