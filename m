Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab1ERLTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 07:19:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1ERLTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 07:19:11 -0400
Date: Wed, 18 May 2011 13:19:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Sarah Nadi <snadi@uwaterloo.ca>
Cc: starvik@axis.com, linux-kernel@vger.kernel.org,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: Re: [Patch 1/1]: cris: typo in mach-fs Makefile
In-Reply-To: <4DD28873.8050706@uwaterloo.ca>
Message-ID: <alpine.LNX.2.00.1105181318470.28291@pobox.suse.cz>
References: <4DD28873.8050706@uwaterloo.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 May 2011, Sarah Nadi wrote:

> From: Sarah Nadi<snadi@uwaterloo.ca>
> 
> There is a possible typo in arch/cris/arch-v32/mach-fs/Makefile. Check diff
> below
> 
> Signed-off-by: Sarah Nadi <snadi@uwaterloo.ca>

Funny that noone noticed since 2007 when this has been introduced. Makes 
one wonder how much is this code really used.

Adding Jesper to CC so that he is aware of this.

I will be applying it to my tree, thanks.

> 
> --- linux-2.6.38/arch/cris/arch-v32/mach-fs/Makefile.orig    2011-03-14
> 21:20:32.000000000 -0400
> +++ linux-2.6.38/arch/cris/arch-v32/mach-fs/Makefile    2011-05-16
> 11:24:21.627239213 -0400
> @@ -4,7 +4,7 @@
>  #
> 
>  obj-y   := dma.o pinmux.o io.o arbiter.o
> -bj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
> +obj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
>  obj-$(CONFIG_CPU_FREQ)   += cpufreq.o
> 
>  clean:
> 
> 
> 
> 

-- 
Jiri Kosina
SUSE Labs
