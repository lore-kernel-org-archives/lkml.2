Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936237Ab0CPF7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 01:59:05 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:57829 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935659Ab0CPF66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 01:58:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:cc:references:in-reply-to:subject:date:message-id:mime-version
         :content-type:content-transfer-encoding:x-mailer:thread-index
         :content-language:x-cr-hashedpuzzle:x-cr-puzzleid;
        b=uSFzBck0j38LVTxARpyJOWwrhXocu5aYH9Y1gX7vbWMb924IQl9LHt8QNXmtF6+7eh
         cYwsSHEAFFk6rWJGXse9lCtkzlbFByNtNxYbwUeUgSvHnw2wc3AqZRlvEBc2baO08noG
         OE9hM/5E79iw1XAXsqFPnumda2Oq1ZDJrhwek=
From: "Will L Givens" <wlgivens@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-alpha@vger.kernel.org>
References: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
In-Reply-To: <b4198de61003151609je8a94ceyf6dd39acfd1a5876@mail.gmail.com>
Subject: RE: Will's kernel compilation error
Date: Tue, 16 Mar 2010 00:50:32 -0500
Message-ID: <001e01cac4cc$98072ce0$c81586a0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcrElJbwrW9iduizQVOineCjTjJafwANxg4Q
Content-Language: en-us
x-cr-hashedpuzzle: BK8b CQdU CbjF DFvn HERP KPAz KZt5 MJ+g M4XN NWaE NwWE Pbfk Qws2 Sn5W TObv UhfC;2;bABpAG4AdQB4AC0AYQBsAHAAaABhAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{92EBFDBA-5948-4EE3-BA6D-307B59AD0007};dwBsAGcAaQB2AGUAbgBzAEAAZwBtAGEAaQBsAC4AYwBvAG0A;Tue, 16 Mar 2010 05:50:29 GMT;UgBFADoAIABXAGkAbABsACcAcwAgAGsAZQByAG4AZQBsACAAYwBvAG0AcABpAGwAYQB0AGkAbwBuACAAZQByAHIAbwByAA==
x-cr-puzzleid: {92EBFDBA-5948-4EE3-BA6D-307B59AD0007}
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> > kernel/built-in.o: In function `check_cpu_itimer':
> > (.text+0x2179c): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `free_nsproxy':
> > (.text+0x23064): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `create_new_namespaces':
> > (.text+0x230a4): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `create_new_namespaces':
> > (.text+0x23254): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `notify_die':
> > (.text+0x2413c): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `register_die_notifier':
> > (.text+0x241a4): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `unregister_die_notifier':
> > (.text+0x241bc): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `sched_clock_init':
> > (.text+0x24ba4): relocation truncated to fit: GPREL16 against `.sbss'
> > kernel/built-in.o: In function `sched_clock_cpu':
> > (.text+0x24bb4): additional relocation overflows omitted from the
> output
> > make: *** [.tmp_vmlinux1] Error 1

It seems the problem, GPREL16, is pretty wide spread. I've tried building
the drivers as modules, since that doesn't appear to be a problem *knock on
wood* but one driver after another, after another, after another generates a
new GPREL16 error! Raid0 drivers, numerous NetFilter modules, IR drivers
(guess I can't use a Hauppauge card), and various other components. I'm
going to try a few more configurations... then hit the sack. I'm pretty sure
this is going to be a long process.

