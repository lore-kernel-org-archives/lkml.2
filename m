Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331Ab1IJCzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 22:55:55 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:60741 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab1IJCzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 22:55:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E6A11DD.3060705@suse.cz>
References: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
	<4E67699E.80208@suse.cz>
	<CABG-yt030LAdqbRySzs8sj0Ajwst_c8RHf7yOyG9Eihh6mmf+w@mail.gmail.com>
	<4E6A11DD.3060705@suse.cz>
Date: Sat, 10 Sep 2011 08:25:52 +0530
Message-ID: <CABG-yt09BEZFhr6uCjohvCQYVJFaBe6EMUGShq9GeRJELyVJ-g@mail.gmail.com>
Subject: Re: CRC calculation in Module.symvers
From: Shakthi Kannan <shakthimaan@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

--- On Fri, Sep 9, 2011 at 6:47 PM, Michal Marek <mmarek@suse.cz> wrote:
| Copy the gcc ... | genksyms ... commandline printed by make V=1
| crypto/api.symtypes.
\--

I ran:

$  gcc -E -D__GENKSYMS__ -Wp,-MD,crypto/.api.symtypes.d  -nostdinc
-isystem /usr/lib/gcc/i686-redhat-linux/4.5.1/include
-I/tmp/linux-3.0.2/arch/x86/include -Iarch/x86/include/generated
-Iinclude  -include include/generated/autoconf.h -D__KERNEL__ -Wall
-Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
-fno-common -Werror-implicit-function-declaration -Wno-format-security
-fno-delete-null-pointer-checks -Os -m32 -msoft-float -mregparm=3
-freg-struct-return -mpreferred-stack-boundary=2 -march=i686
-mtune=generic -Wa,-mtune=generic32 -ffreestanding -fstack-protector
-DCONFIG_AS_CFI=1 -DCONFIG_AS_CFI_SIGNAL_FRAME=1
-DCONFIG_AS_CFI_SECTIONS=1 -pipe -Wno-sign-compare
-fno-asynchronous-unwind-tables -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
-Wframe-larger-than=1024 -Wno-unused-but-set-variable
-fno-omit-frame-pointer -fno-optimize-sibling-calls -g -pg
-Wdeclaration-after-statement -Wno-pointer-sign -fno-strict-overflow
-fconserve-stack -DCC_HAVE_ASM_GOTO    -D"KBUILD_STR(s)=#s"
-D"KBUILD_BASENAME=KBUILD_STR(api)"
-D"KBUILD_MODNAME=KBUILD_STR(api)" crypto/api.c |
scripts/genksyms/genksyms

and it printed the checksums.

Thanks for your help!

SK

-- 
Shakthi Kannan
http://www.shakthimaan.com
