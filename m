Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2CZUlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:41:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38390 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756479Ab2CZUlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:41:45 -0400
Date: Mon, 26 Mar 2012 22:41:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Jan Beulich <JBeulich@suse.com>
Cc: rusty@rustcorp.com.au, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] modpost: fix ALL_INIT_DATA_SECTIONS
Message-ID: <20120326204143.GB10259@sepie.suse.cz>
References: <4F588CD50200007800077112@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F588CD50200007800077112@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 09:41:25AM +0000, Jan Beulich wrote:
> This was lacking a comma between two supposed to be separate strings.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---
>  scripts/mod/modpost.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 3.3-rc6/scripts/mod/modpost.c
> +++ 3.3-rc6-modpost-all-init-data/scripts/mod/modpost.c
> @@ -849,7 +849,7 @@ static void check_section(const char *mo
>  
>  #define ALL_INIT_DATA_SECTIONS \
>  	".init.setup$", ".init.rodata$", \
> -	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$" \
> +	".devinit.rodata$", ".cpuinit.rodata$", ".meminit.rodata$", \

Applied to kbuild.git#kbuild with a Cc: stable. BTW, was it causing actual
false positives to be reported?

Thanks,
Michal
