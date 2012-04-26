Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab2DZJej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:34:39 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:35614 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755622Ab2DZJei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJSTwE7StCny1U9eSpZA+mTay+cSLRzFthu3yy2zh+W7EnLD_A@mail.gmail.com>
References: <CAJSTwE7StCny1U9eSpZA+mTay+cSLRzFthu3yy2zh+W7EnLD_A@mail.gmail.com>
From: Seblu <seblu@seblu.net>
Date: Thu, 26 Apr 2012 11:34:17 +0200
X-Google-Sender-Auth: GsaKbb3Bp3GvKTTugIWaGc0rsKg
Message-ID: <CAJSTwE7hG6m_12c8zp2EzQKGVRXesOuO5v_hP3LBfpme5ju5yQ@mail.gmail.com>
Subject: Fwd: Linux stable 3.3.3, perf tools doesn't build on x86
To: stable@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I would notify you about the new 3.3.3 stable kernel which doesn't
allow compiling perf tools:

# make
...
   CC util/sort.o
   CC util/hist.o
util/hist.c: In function '__hists__add_entry':
util/hist.c:240:27: error: invalid type argument of '->' (have 'struct
hist_entry')
util/hist.c:241:23: error: invalid type argument of '->' (have 'struct
hist_entry')
make: *** [util/hist.o] Error 1
# gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/i686-pc-linux-gnu/4.7.0/lto-wrapper
Target: i686-pc-linux-gnu
Configured with: /build/src/gcc-4.7-20120414/configure --prefix=/usr
--libdir=/usr/lib --libexecdir=/usr/lib --mandir=/usr/share/man
--infodir=/usr/share/info --with-bugurl=https://bugs.archlinux.org/
--enable-languages=c,c++,ada,fortran,go,lto,objc,obj-c++
--enable-shared --enable-threads=posix --with-system-zlib
--enable-__cxa_atexit --disable-libunwind-exceptions
--enable-clocale=gnu --disable-libstdcxx-pch --enable-libstdcxx-time
--enable-gnu-unique-object --enable-linker-build-id --with-ppl
--enable-cloog-backend=isl --enable-lto --enable-gold
--enable-ld=default --enable-plugin --with-plugin-ld=ld.gold
--with-linker-hash-style=gnu --disable-multilib --disable-libssp
--disable-build-with-cxx --disable-build-poststage1-with-cxx
--enable-checking=release
Thread model: posix
gcc version 4.7.0 20120414 (prerelease) (GCC)

Cheers,

--
Sébastien Luttringer
www.seblu.net


-- 
Sébastien Luttringer
www.seblu.net
