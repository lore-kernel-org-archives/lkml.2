Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab0KCCFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 22:05:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58755 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0KCCFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 22:05:09 -0400
MIME-Version: 1.0
X-Originating-IP: [192.55.46.36]
In-Reply-To: <201011030532.09986.randrianasulu@gmail.com>
References: <201011030532.09986.randrianasulu@gmail.com>
Date: Wed, 3 Nov 2010 10:05:07 +0800
Message-ID: <AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>
Subject: Re: 2.6.37-rc1 build failure
From: Lin Ming <lin@ming.vg>
To: randrianasulu@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 1:32 PM,  <randrianasulu@gmail.com> wrote:
> Trying to make new kernel i run into this:
>
>  CC      arch/x86/lib/delay.o
>  AS      arch/x86/lib/getuser.o
>  AS      arch/x86/lib/putuser.o
>  CC      arch/x86/lib/usercopy_32.o
>  AR      arch/x86/lib/lib.a
>  LD      vmlinux.o
>  MODPOST vmlinux.o
> WARNING: modpost: Found 2 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>  GEN     .version
>  CHK     include/generated/compile.h
>  UPD     include/generated/compile.h
>  CC      init/version.o
>  LD      init/built-in.o
>  LD      .tmp_vmlinux1
> kernel/built-in.o: In function `free_event':
> perf_event.c:(.text+0x66eb3): undefined reference to `irq_work_sync'
> kernel/built-in.o: In function `perf_output_put_handle':
> perf_event.c:(.text+0x680e1): undefined reference to `irq_work_queue'
> kernel/built-in.o: In function `__perf_event_overflow':
> perf_event.c:(.text+0x6a75e): undefined reference to `irq_work_queue'
> make: *** [.tmp_vmlinux1] Ошибка 1
>
> kernel.org git master up to
>
> commit eb8abb927ae2fd1730e24ea94cd9527f3c086292
> Author: Theodore Ts'o <tytso@mit.edu>
> Date:   Tue Nov 2 09:34:50 2010 -0400
>
>    ext4: Remove useless spinlock in ext4_getattr()
>
>
>
> this is my .config

I build with you .config, but no error.

Maybe you can make distclean and re-build.

Lin Ming
