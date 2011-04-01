Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1DATRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 15:17:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43358 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab1DATRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 15:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AyH7ZhzML7ZNgmjQ8dIPXqQUNSr7Ra+6WqEfQQeNKKl4rR3kbdRvHmKSTT8J/j1il1
         QuWeBQ7kijNcTtDzyOlBToH0WqOwINn1pvW+Df4kj3h52IxDuVrHpM2kaLTbO1PjM+cP
         RCRdlJpJ1MLGfHCMW73+mgtcHSX9PduG5mMSs=
Subject: Re: [PATCH v2] x86: page: get_order() optimization
From: Maksym Planeta <mcsim.planeta@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
        kernel-janitors@vger.kernel.org, namhyung@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <4D90E539.7060908@zytor.com>
References: <1301215556-8898-1-git-send-email-mcsim.planeta@gmail.com>
	 <20110327113323.GA27825@elte.hu> <1301246136.2291.49.camel@debian>
	 <20110328050844.GC26322@elte.hu> <1301340822.6302.90.camel@debian>
	 <4D90E539.7060908@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 17:08:44 +0300
Message-ID: <1301666924.734.6.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28/03/2011 at 12:44 -0700, H. Peter Anvin wrote:
> With what options?
> 
> 	-hpa

$ gcc -v
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.5.2/lto-wrapper
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian 4.5.2-4'
--with-bugurl=file:///usr/share/doc/gcc-4.5/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--program-suffix=-4.5 --enable-shared --enable-multiarch
--enable-linker-build-id --with-system-zlib --libexecdir=/usr/lib
--without-included-gettext --enable-threads=posix
--with-gxx-include-dir=/usr/include/c++/4.5 --libdir=/usr/lib
--enable-nls --enable-clocale=gnu --enable-libstdcxx-debug
--enable-libstdcxx-time=yes --enable-plugin --enable-gold
--enable-ld=default --with-plugin-ld=ld.gold --enable-objc-gc
--with-arch-32=i586 --with-tune=generic --enable-checking=release
--build=x86_64-linux-gnu --host=x86_64-linux-gnu
--target=x86_64-linux-gnu
Thread model: posix
gcc version 4.5.2 (Debian 4.5.2-4) 

for compiling kernel I've used: make defconfig && make -j3
-- 
Thanks,

Maksym Planeta

