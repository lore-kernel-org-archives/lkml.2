Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab1ENCvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 22:51:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359Ab1ENCvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 22:51:23 -0400
Date: Sat, 14 May 2011 04:51:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, ak@linux.intel.com
Subject: Re: [PATCH 5/5] Hook up sysconf syscall for all architectures
Message-ID: <20110514025120.GS6008@one.firstfloor.org>
References: <1305329059-2017-1-git-send-email-andi@firstfloor.org> <1305329059-2017-6-git-send-email-andi@firstfloor.org> <20110513.212124.1730222866632905908.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513.212124.1730222866632905908.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 09:21:24PM -0400, David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Fri, 13 May 2011 16:24:19 -0700
> 
> > diff --git a/arch/sparc/include/asm/unistd.h b/arch/sparc/include/asm/unistd.h
> > index 9d897b6..0b0b362 100644
> > --- a/arch/sparc/include/asm/unistd.h
> > +++ b/arch/sparc/include/asm/unistd.h
> > @@ -404,8 +404,9 @@
> >  #define __NR_open_by_handle_at	333
> >  #define __NR_clock_adjtime	334
> >  #define __NR_syncfs		335
> > +#define __NR_sysconf		336
> >  
> > -#define NR_syscalls		336
> > +#define NR_syscalls		337
> >  
> 
> x86, powerpc, and sparc entries will conflict with already assigned
> slots for sys_sendmmsg() in networking tree.

Thanks. I'll fix it up on the next try, hopefully those
changes are in mainline then.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
