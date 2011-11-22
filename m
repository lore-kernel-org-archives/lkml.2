Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab1KVV5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:57:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab1KVV5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:57:51 -0500
Date: Tue, 22 Nov 2011 22:57:49 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] x86: Kconfig: drop unknown symbol
 'APM_MODULE'
In-Reply-To: <1321526491.20271.275.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1111222257320.28728@pobox.suse.cz>
References: <1321526491.20271.275.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Paul Bolle wrote:

> There's no Kconfig symbol APM_MODULE, so the check for it will always
> fail. There's no need to append _MODULE to tristate symbols anyhow,
> because the config tools will do the right thing automagically.

I will be taking this through apm.git instead of trivial.git.

Thanks.

> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Added in commit a6b68076fd ("x86: compile apm and voyager module only
> when selected in Kconfig"). The reason for appending _MODULE can be
> found at https://lkml.org/lkml/2008/1/3/422 .
> 
>  arch/x86/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cb9a104..e4d218e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1726,7 +1726,7 @@ source "drivers/sfi/Kconfig"
>  
>  config X86_APM_BOOT
>  	def_bool y
> -	depends on APM || APM_MODULE
> +	depends on APM
>  
>  menuconfig APM
>  	tristate "APM (Advanced Power Management) BIOS support"
> -- 
> 1.7.4.4
> 

-- 
Jiri Kosina
SUSE Labs
