Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab2LIQhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:37:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44391 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110Ab2LIQhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:37:23 -0500
Message-ID: <50C4BE41.5030508@suse.cz>
Date: Sun, 09 Dec 2012 17:37:21 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: pefoley2@verizon.net, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 4/5] silence 'arch/x86/realmode/rm/realmode.bin' is up
 to date message
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net> <1353269117-39917-4-git-send-email-pefoley2@verizon.net>
In-Reply-To: <1353269117-39917-4-git-send-email-pefoley2@verizon.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86@kernel.org added.

On 18.11.2012 21:05, pefoley2@verizon.net wrote:
> From: Peter Foley <pefoley2@verizon.net>
> 
> Since realmode.bin is in $(always) the recursive make from the realmode
> directory does not need to specify a specific target.

... and the rm/ subdirectory is unconditionally visited by the Makefile
already.

> Remove the realmode.bin target to eliminate the 'up to date'
> message.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>

Acked-by: Michal Marek <mmarek@suse.cz>

Michal

> ---
>  arch/x86/realmode/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/realmode/Makefile b/arch/x86/realmode/Makefile
> index 94f7fbe..08fe883 100644
> --- a/arch/x86/realmode/Makefile
> +++ b/arch/x86/realmode/Makefile
> @@ -15,4 +15,4 @@ obj-y += rmpiggy.o
>  $(obj)/rmpiggy.o: $(obj)/rm/realmode.bin
>  
>  $(obj)/rm/realmode.bin: FORCE
> -	$(Q)$(MAKE) $(build)=$(obj)/rm $@
> +	$(Q)$(MAKE) $(build)=$(obj)/rm
> 

