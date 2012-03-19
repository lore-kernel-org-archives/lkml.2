Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031424Ab2CSOva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:51:30 -0400
Received: from mail1.windriver.com ([147.11.146.13]:57147 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab2CSOv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:51:28 -0400
Date: Mon, 19 Mar 2012 10:51:25 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: linux-next: triage for March 18, 2012
Message-ID: <20120319145125.GA12142@windriver.com>
References: <20120318184105.GC2095@windriver.com>
 <20120318235114.GA30497@thor.bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120318235114.GA30497@thor.bakeyournoodle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: linux-next: triage for March 18, 2012] On 19/03/2012 (Mon 10:51) Tony Breeds wrote:

> On Sun, Mar 18, 2012 at 02:41:05PM -0400, Paul Gortmaker wrote:

[...]

> > 
> > AM33:asb2303_defconfig,asb2364_defconfig
> > 	when:	Mar 15, 18:04
> > 	why:	cc1: error: unrecognized command line option '-mmem-funcs'
> > 	status:	incompatible toolchain?
> > 	fix:
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5878400/
> > ----------------
> 
> I submitted a patch for this it hasn't been taken up yet.
> 	http://marc.info/?l=linux-kernel&m=133185020313818&w=2
> <SNIP>
> 
> > frv:defconfig
> > 	when:	Mar 15
> > 	why:	arch/frv/kernel/head.S operand out of range
> > 	status:
> > 	fix:
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884666/
> > ----------------
> 
> Quite willing to accept that I have built this compiler wrong.
> 
> ~$ /opt/cross/gcc-4.6.3-nolibc/frv-linux/bin/frv-linux-gcc -v
> Using built-in specs.
> COLLECT_GCC=/opt/cross/gcc-4.6.3-nolibc/frv-linux/bin/frv-linux-gcc
> COLLECT_LTO_WRAPPER=/opt/crosstool/gcc-4.6.3-nolibc/frv-linux/bin/../libexec/gcc/frv-linux/4.6.3/lto-wrapper
> Target: frv-linux
> Configured with: /home/tony/buildall/src/gcc/configure --target=frv-linux --host=ppc64-linux-gnu --build=ppc64-linux-gnu --enable-targets=all --prefix=/home/tony/buildall/cross.ppc64/gcc-4.6.3-nolibc/frv-linux/ --enable-languages=c --with-newlib --without-headers --enable-sjlj-exceptions --with-system-libunwind --disable-nls --disable-threads --disable-shared --disable-libmudflap --disable-libssp --disable-libgomp --disable-decimal-float --enable-checking=release --with-mpfr=/home/tony/buildall/src/sys-ppc64 --with-gmp=/home/tony/buildall/src/sys-ppc64 --disable-bootstrap --disable-libquadmath
> Thread model: single
> gcc version 4.6.3 (GCC) 
> 
> If there is somethign I need to chenge when building gcc let me know.
> 
> > h8300:defconfig
> > 	when:	Mar 15
> > 	why:	time.c: implicit declaration of function 'get_irq_regs'
> > 	status:	
> > 	fix:
> > 	ref:	http://kisskb.ellerman.id.au/kisskb/buildresult/5884668/
> > ----------------
> 
> Later there is also an internal compiler error reported at: 
> 	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=52598

Thanks for the updates.  I've added the am33 and h8300 info.  I don't
know what to advise wrt. the frv platform...  there doesn't even appear
to be an x86_64 cross that I can steal to try and reproduce it with.
( http://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.0/ )

Paul.

> 
> Yours Tony


