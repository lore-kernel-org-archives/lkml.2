Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2BTQIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 11:08:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:59756 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab2BTQID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 11:08:03 -0500
Date: Mon, 20 Feb 2012 17:08:04 +0100
From: Borislav Petkov <bp@alien8.de>
To: hpa@zytor.com, mingo@elte.hu
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
Subject: Re: [PATCH] x86: remove some noise from boot log when starting cpus
Message-ID: <20120220160804.GC26703@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
	mingo@elte.hu, "Luck, Tony" <tony.luck@intel.com>,
	linux-kernel@vger.kernel.org, castet.matthieu@free.fr,
	tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com,
	rjw@sisk.pl
References: <4E53FBBB.7030008@zytor.com>
 <4e540cf271396b4c4@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e540cf271396b4c4@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 01:26:26PM -0700, Luck, Tony wrote:
> Printing the "start_ip" for every secondary cpu is very noisy on a large
> system - and doesn't add any value. Drop this message.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

This one is still out-of-tree, can we pick it up pls?

Thanks.

> 
> ---
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 9f548cb..fe5fb7a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -734,8 +734,6 @@ do_rest:
>  	 * the targeted processor.
>  	 */
>  
> -	printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
> -
>  	atomic_set(&init_deasserted, 0);
>  
>  	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
Boris.
