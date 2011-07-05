Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab1GENwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 09:52:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51006 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab1GENwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 09:52:02 -0400
Date: Tue, 5 Jul 2011 15:51:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockup detector: CONFIG_DETECT_SOFTLOCKUP no longer
 exists
Message-ID: <20110705135153.GG5551@somewhere>
References: <20110705133240.25e81a7a@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705133240.25e81a7a@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 01:32:40PM +1000, Anton Blanchard wrote:
> 
> Replace CONFIG_DETECT_SOFTLOCKUP with CONFIG_LOCKUP_DETECTOR.
>  
> Signed-off-by: Anton Blanchard <anton@samba.org>

Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

> ---
> 
> Index: linux-2.6-work/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6-work.orig/lib/Kconfig.debug	2011-07-05 12:47:23.728166985 +1000
> +++ linux-2.6-work/lib/Kconfig.debug	2011-07-05 12:47:40.478462898 +1000
> @@ -227,7 +227,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
>  config DETECT_HUNG_TASK
>  	bool "Detect Hung Tasks"
>  	depends on DEBUG_KERNEL
> -	default DETECT_SOFTLOCKUP
> +	default LOCKUP_DETECTOR
>  	help
>  	  Say Y here to enable the kernel to detect "hung tasks",
>  	  which are bugs that cause the task to be stuck in
> @@ -866,7 +866,7 @@ config BOOT_PRINTK_DELAY
>  	  system, and then set "lpj=M" before setting "boot_delay=N".
>  	  NOTE:  Using this option may adversely affect SMP systems.
>  	  I.e., processors other than the first one may not boot up.
> -	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
> +	  BOOT_PRINTK_DELAY also may cause LOCKUP_DETECTOR to detect
>  	  what it believes to be lockup conditions.
>  
>  config RCU_TORTURE_TEST
