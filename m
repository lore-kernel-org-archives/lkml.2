Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937177Ab0COXWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:22:04 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:16007 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937130Ab0COXWA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:22:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:in-reply-to:subject:date:message-id
         :mime-version:content-type:content-transfer-encoding:x-mailer
         :thread-index:content-language;
        b=Gt9PZgwJc63JKwPuNW0N9wh5/uj/NuGHR5tF/ixuAFmvefu1Za7JmNrkZr6tzAYkb3
         cBxPohByRR9c4vL7l5Ia32E9TReuy8rVvqazgo54KUFIp5LEXIEuu0O2JvnVsbhFSAN0
         z4Iz7FYMIjDej9VCqwjIXnApJvqdqIV2eY3PI=
From: "Will L Givens" <wlgivens@gmail.com>
To: "'Matt Turner'" <mattst88@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
In-Reply-To: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
Subject: RE: Will's kernel compilation error
Date: Mon, 15 Mar 2010 18:21:41 -0500
Message-ID: <001601cac496$4651e0b0$d2f5a210$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrElJbwrW9iduizQVOineCjTjJafwAAREhQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snip

> >
> > [root@jericho linux]# gcc-3.4.3 -v
> > Reading specs from /usr/lib/gcc/alphaev5-alpha-linux/3.4.3/specs
> > Configured with: ../gcc-3.4.3/configure --prefix=/usr --
> sysconfdir=/etc
> > --mandir=/usr/share/man --infodir=/usr/share/info
> > --build=alphaev5-alpha-linux --host=alphaev5-alpha-linux
> > --target=alphaev5-alpha-linux --program-suffix=-3.4.3 --enable-
> languages=all
> >

snip

> >
> > gcc-3.4.3 -Wp,-MD,arch/alpha/lib/.__remqu.o.d  -nostdinc -isystem
> > /usr/lib/gcc/alphaev5-alpha-linux/3.4.3/include
> > -I/usr/src/linux-2.6.34-rc1/arch/alpha/include -Iinclude  -include
> > include/generated/autoconf.h -D__KERNEL__ -D__ASSEMBLY__    -Wall -
> Wundef
> > -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing -fno-common
> > -Werror-implicit-function-declaration -Wno-format-security
> > -fno-delete-null-pointer-checks -pipe -Os -pipe -mno-fp-regs -ffixed-
> 8
> > -msmall-data  -mcpu=ev67 -Wa,-mev6   -fomit-frame-pointer
> > -Wdeclaration-after-statement     -DREM  -c -o
> arch/alpha/lib/__remqu.o
> > arch/alpha/lib/ev6-divide.S
> 
> Why is your CHOST alphaev5-alpha-linux but you're compiling for EV67?


Well actually that’s the --build option that was set when building gcc
itself. I have several different gcc versions for both EV5 and EV67. I was
thinking rolling my own Fedora releases, one for myself and possibly
something more general (EV5) for Oliver.

> 
> >  AS      arch/alpha/lib/callback_srm.o
> >  CC      arch/alpha/lib/checksum.o
> >  CC      arch/alpha/lib/csum_partial_copy.o
> >  AS      arch/alpha/lib/ev6-clear_page.o
> >  AS      arch/alpha/lib/ev6-clear_user.o
> >  AS      arch/alpha/lib/ev6-copy_page.o
> >  AS      arch/alpha/lib/ev6-copy_user.o
> >  AS      arch/alpha/lib/ev6-csum_ipv6_magic.o
> >  AS      arch/alpha/lib/ev6-memchr.o
> >  AS      arch/alpha/lib/ev6-memcpy.o
> >  AS      arch/alpha/lib/ev6-memset.o
> >  AS      arch/alpha/lib/ev6-strncpy_from_user.o
> >  AS      arch/alpha/lib/ev6-stxcpy.o
> >  AS      arch/alpha/lib/ev6-stxncpy.o
> >  AS      arch/alpha/lib/ev67-strcat.o
> >  AS      arch/alpha/lib/ev67-strchr.o
> >  AS      arch/alpha/lib/ev67-strlen.o
> >  AS      arch/alpha/lib/ev67-strlen_user.o
> >  AS      arch/alpha/lib/ev67-strncat.o
> >  AS      arch/alpha/lib/ev67-strrchr.o
> >  CC      arch/alpha/lib/fls.o
> >  CC      arch/alpha/lib/fpreg.o
> >  AS      arch/alpha/lib/memmove.o
> >  CC      arch/alpha/lib/srm_printk.o
> >  CC      arch/alpha/lib/srm_puts.o
> >  AS      arch/alpha/lib/strcpy.o
> >  AS      arch/alpha/lib/strncpy.o
> >  CC      arch/alpha/lib/udelay.o
> >  AR      arch/alpha/lib/lib.a
> >  LD      vmlinux.o
> >  MODPOST vmlinux.o
> > WARNING: modpost: Found 1 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >  GEN     .version
> >  CHK     include/generated/compile.h
> >  UPD     include/generated/compile.h
> >  CC      init/version.o
> >  LD      init/built-in.o
> >  LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `kthread_create':
> > (.text+0x1ece4): relocation truncated to fit: GPREL16 against symbol
> > `kthreadd_task' defined in .sbss section in kernel/built-in.o
> > kernel/built-in.o: In function `check_cpu_itimer':
> > (.text+0x21784): relocation truncated to fit: GPREL16 against `.sbss'

snip

