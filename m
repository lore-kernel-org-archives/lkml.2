Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab1EQJTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:19:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:56980 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab1EQJTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:19:42 -0400
Date: Tue, 17 May 2011 11:19:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Sarah Nadi <snadi@uwaterloo.ca>
Cc: starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [Patch 1/1]: cris: typo in mach-fs Makefile
In-Reply-To: <4DD145B7.6070903@uwaterloo.ca>
Message-ID: <alpine.LNX.2.00.1105171118350.28291@pobox.suse.cz>
References: <4DD145B7.6070903@uwaterloo.ca>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Sarah Nadi wrote:

> 
> From: Sarah Nadi <snadi@uwaterloo.ca>
> 
> There is a possible typo in arch/cris/arch-v32/mach-fs/Makefile. Check diff below

There are several issues with this patch.

> 
> --- Makefile	2011-05-16 11:24:21.627239213 -0400
> +++ Makefile-orig	2011-03-14 21:20:32.000000000 -0400

It can't be applied using '-p1' from a top-level kernel tree directory.

> @@ -4,7 +4,7 @@
>  #
>  
>  obj-y   := dma.o pinmux.o io.o arbiter.o
> -obj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o
> +bj-$(CONFIG_ETRAX_VCS_SIM) += vcs_hook.o

It's reversed.

Could you please fix that and resend?

Thanks,

-- 
Jiri Kosina
SUSE Labs
