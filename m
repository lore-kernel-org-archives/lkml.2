Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1C1Moy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:44:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919Ab1C1Mow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:44:52 -0400
Date: Mon, 28 Mar 2011 14:44:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH] apm: orphan the driver
In-Reply-To: <20110326172204.05e52c10.sfr@canb.auug.org.au>
Message-ID: <alpine.LRH.2.00.1103281443240.8162@twin.jikos.cz>
References: <20110326172204.05e52c10.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Stephen Rothwell wrote:

> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  MAINTAINERS |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> I no longer have access to any hardware that uses APM and have not
> provided real maintenance for several years.  Hopefully someone with the
> hardware or energy will step forward if the driver is to be kept.
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 749f9cd..61f9948 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -548,10 +548,8 @@ S:	Maintained
>  F:	sound/aoa/
>  
>  APM DRIVER
> -M:	Stephen Rothwell <sfr@canb.auug.org.au>
>  L:	linux-laptop@vger.kernel.org
> -W:	http://www.canb.auug.org.au/~sfr/
> -S:	Supported
> +S:	Orphan
>  F:	arch/x86/kernel/apm_32.c
>  F:	include/linux/apm_bios.h

I still have some hardware that uses APM and put a new 2.6 on it time to 
time, so I can take this driver over if you want to. According to git log 
it's really low effort anyway :)

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

