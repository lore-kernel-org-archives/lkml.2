Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab0HRFkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:40:04 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45091 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab0HRFj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:39:58 -0400
Date: Wed, 18 Aug 2010 07:39:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulus@au.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: 64-bit ppc rwsem
Message-ID: <20100818053955.GA11962@merkur.ravnborg.org>
References: <20100817.191424.183031381.davem@davemloft.net> <1282106338.22370.151.camel@pasglop> <1282107803.22370.173.camel@pasglop> <20100817.222818.193699062.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817.222818.193699062.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
> index c4b5e03..fa4c3ea 100644
> --- a/arch/sparc/lib/Makefile
> +++ b/arch/sparc/lib/Makefile
> @@ -15,7 +15,7 @@ lib-$(CONFIG_SPARC32) += divdi3.o udivdi3.o
>  lib-$(CONFIG_SPARC32) += copy_user.o locks.o
>  lib-y                 += atomic_$(BITS).o
>  lib-$(CONFIG_SPARC32) += lshrdi3.o ashldi3.o
> -lib-y                 += rwsem_$(BITS).o
> +lib-$(CONFIG_SPARC32) += rwsem_$(BITS).o

You could write this explicit as:

> +lib-$(CONFIG_SPARC32) += rwsem_32.o

As rwsem_64 is gone now.

	Sam
