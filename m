Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566Ab1ETNXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:23:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33389 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1ETNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Twtso/ZaP7N0edFtUWE3G04vJOiP4xFShBzAUYreTWuWyuU0p3rjFUx/IbdeLumiER
         aRsLt+Bb6g5mLd6YOucEkIvYlJ2VSA7oncd8doijS9SVB8s2UZ3YHhJkyYNhKZ4S1d9n
         2szZcVatCNj63D/Zdzs99CDQge4hKOnD+EDC4=
Date: Fri, 20 May 2011 15:23:29 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
Message-ID: <20110520132328.GA5785@riccoc20.at.omicron.at>
References: <1305777978.7481.37.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305777978.7481.37.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 02:06:18PM +1000, Benjamin Herrenschmidt wrote:
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

When I try to build 'next' (now at 208b3a4c), it does not compile due
to a change from the following commit.

> Benjamin Herrenschmidt (1):
>       powerpc/smp: Make start_secondary_resume available to all CPU variants

I would appreciate your help in getting this fixed...

Thanks,
Richard

PS the error looks like this:

  AS      arch/powerpc/kernel/misc_32.o
arch/powerpc/kernel/misc_32.S: Assembler messages:
arch/powerpc/kernel/misc_32.S:703: Error: Unrecognized opcode: `std'
make[2]: *** [arch/powerpc/kernel/misc_32.o] Error 1
make[1]: *** [arch/powerpc/kernel] Error 2

> ${CROSS_COMPILE}gcc -v
Using built-in specs.
Target: powerpc-none-linux-gnuspe
Configured with: ../gcc-4.3.2/configure --target=powerpc-none-linux-gnuspe --host=i686-pc-linux-gnu --prefix=/opt/freescale/usr/local/gcc-4.3.74-eglibc-2.8.74-dp-2/powerpc-none-linux-gnuspe --with-sysroot=/opt/freescale/usr/local/gcc-4.3.74-eglibc-2.8.74-dp-2/powerpc-none-linux-gnuspe/powerpc-none-linux-gnuspe/libc --disable-libssp --disable-libmudflap --disable-libstdcxx-pch --enable-libgomp --enable-shared --enable-threads --enable-languages=c,c++ --with-gmp=/usr/src/redhat/BUILD/csl-tc-4.3.74/host-libs/usr --with-mpfr=/usr/src/redhat/BUILD/csl-tc-4.3.74/host-libs/usr --with-cpu=8548 --with-gnu-as --with-gnu-ld --enable-symvers=gnu --enable-__cxa_atexit --enable-cxx-flags=-mcpu=8548 --disable-multilib --with-long-double-128 --disable-nls --enable-e500_double
Thread model: posix
gcc version 4.3.2 (GCC) 
