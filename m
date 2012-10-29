Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2J2HmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:42:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:41669 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab2J2Hl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:41:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,669,1344236400"; 
   d="scan'208";a="161789233"
Date: Mon, 29 Oct 2012 09:41:42 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix comment for set_real_mode_permissions
Message-ID: <20121029074142.GD2454@jsakkine-mobl1.tm.intel.com>
References: <1351377255-21092-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351377255-21092-1-git-send-email-cesarb@cesarb.net>
Organization: Intel Finland Oy - BIC 0357606-4 - PL 281, 00181 Helsinki
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 08:34:14PM -0200, Cesar Eduardo Barros wrote:
> The function which gets called very early is setup_real_mode(). The
> set_real_mode_permissions() function is the arch_initcall.
> 
> Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>

Acked-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>

> ---
>  arch/x86/realmode/init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
> index cbca565..b4c92c5 100644
> --- a/arch/x86/realmode/init.c
> +++ b/arch/x86/realmode/init.c
> @@ -84,7 +84,7 @@ void __init setup_real_mode(void)
>  }
>  
>  /*
> - * set_real_mode_permissions() gets called very early, to guarantee the
> + * setup_real_mode() gets called very early, to guarantee the
>   * availability of low memory.  This is before the proper kernel page
>   * tables are set up, so we cannot set page permissions in that
>   * function.  Thus, we use an arch_initcall instead.
> -- 
> 1.7.11.7
> 

/Jarkko
