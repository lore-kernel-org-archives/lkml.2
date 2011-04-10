Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab1DJPEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 11:04:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:55092 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1DJPEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 11:04:41 -0400
Date: Sun, 10 Apr 2011 08:04:36 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-arm-kernel@lists.infradead.org, Deepak Saxena <dsaxena@mvista.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][Trivial] ARM: Remove duplicate linux/sched.h include
 from arch/arm/plat-iop/time.c
In-Reply-To: <alpine.LNX.2.00.1103150108510.26293@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1104081917270.6392@deuxcents.site>
References: <alpine.LNX.2.00.1103150108510.26293@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Mar 2011, Jesper Juhl wrote:

> There's no need to include linux/sched.h more than once 
> in arch/arm/plat-iop/time.c
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  time.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/plat-iop/time.c b/arch/arm/plat-iop/time.c
> index 07f23bb..7cdc516 100644
> --- a/arch/arm/plat-iop/time.c
> +++ b/arch/arm/plat-iop/time.c
> @@ -17,7 +17,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/time.h>
>  #include <linux/init.h>
> -#include <linux/sched.h>
>  #include <linux/timex.h>
>  #include <linux/sched.h>
>  #include <linux/io.h>

Seems to be present in linux-next as of today still. Applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

