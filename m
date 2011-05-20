Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1ETW7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:59:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:44038 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab1ETW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:59:46 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20110520132328.GA5785@riccoc20.at.omicron.at>
References: <1305777978.7481.37.camel@pasglop>
	 <20110520132328.GA5785@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 May 2011 08:21:21 +1000
Message-ID: <1305930081.7481.190.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 15:23 +0200, Richard Cochran wrote:
> On Thu, May 19, 2011 at 02:06:18PM +1000, Benjamin Herrenschmidt wrote:
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge
> 
> When I try to build 'next' (now at 208b3a4c), it does not compile due
> to a change from the following commit.
> 
> > Benjamin Herrenschmidt (1):
> >       powerpc/smp: Make start_secondary_resume available to all CPU variants
> 
> I would appreciate your help in getting this fixed...

It's me being a moron. I'll send a fix to Linus.

Cheers,
Ben.

> Thanks,
> Richard
> 
> PS the error looks like this:
> 
>   AS      arch/powerpc/kernel/misc_32.o
> arch/powerpc/kernel/misc_32.S: Assembler messages:
> arch/powerpc/kernel/misc_32.S:703: Error: Unrecognized opcode: `std'
> make[2]: *** [arch/powerpc/kernel/misc_32.o] Error 1
> make[1]: *** [arch/powerpc/kernel] Error 2
> 
> > ${CROSS_COMPILE}gcc -v
> Using built-in specs.
> Target: powerpc-none-linux-gnuspe
> Configured with: ../gcc-4.3.2/configure --target=powerpc-none-linux-gnuspe --host=i686-pc-linux-gnu --prefix=/opt/freescale/usr/local/gcc-4.3.74-eglibc-2.8.74-dp-2/powerpc-none-linux-gnuspe --with-sysroot=/opt/freescale/usr/local/gcc-4.3.74-eglibc-2.8.74-dp-2/powerpc-none-linux-gnuspe/powerpc-none-linux-gnuspe/libc --disable-libssp --disable-libmudflap --disable-libstdcxx-pch --enable-libgomp --enable-shared --enable-threads --enable-languages=c,c++ --with-gmp=/usr/src/redhat/BUILD/csl-tc-4.3.74/host-libs/usr --with-mpfr=/usr/src/redhat/BUILD/csl-tc-4.3.74/host-libs/usr --with-cpu=8548 --with-gnu-as --with-gnu-ld --enable-symvers=gnu --enable-__cxa_atexit --enable-cxx-flags=-mcpu=8548 --disable-multilib --with-long-double-128 --disable-nls --enable-e500_double
> Thread model: posix
> gcc version 4.3.2 (GCC) 


