Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab0KCXej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:34:39 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44020 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab0KCXeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=MApxLvX847yCZJP6/bGUEW4RS4mnuQjQMTl1mmhmZTFwV00gK8wku/EwGJeqNQsZgW
         lqg4F14ugiA5DIDU2/KE4QK0mGV4LIp/rk8ruKspZmfTe5sLBJ3GXv1yqvfEkygldLJa
         NJN/kRTFtHwL857WLJ8VFQhPygr9ivgr3iUvI=
From: randrianasulu@gmail.com
To: Lin Ming <lin@ming.vg>
Subject: Re: 2.6.37-rc1 build failure
Date: Thu, 4 Nov 2010 03:34:16 +0000
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201011030532.09986.randrianasulu@gmail.com> <AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>
In-Reply-To: <AANLkTi=NYWGQB_O78dn=opzPYFngeBnJ2qrF7k5Le_ma@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201011040334.16833.randrianasulu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от Wednesday 03 November 2010 02:05:07 Lin Ming написал(а):
> On Wed, Nov 3, 2010 at 1:32 PM,  <randrianasulu@gmail.com> wrote:
> > Trying to make new kernel i run into this:
> >
> >  CC      arch/x86/lib/delay.o
> >  AS      arch/x86/lib/getuser.o
> >  AS      arch/x86/lib/putuser.o
> >  CC      arch/x86/lib/usercopy_32.o
> >  AR      arch/x86/lib/lib.a
> >  LD      vmlinux.o
> >  MODPOST vmlinux.o
> > WARNING: modpost: Found 2 section mismatch(es).
> > To see full details build your kernel with:
> > 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >  GEN     .version
> >  CHK     include/generated/compile.h
> >  UPD     include/generated/compile.h
> >  CC      init/version.o
> >  LD      init/built-in.o
> >  LD      .tmp_vmlinux1
> > kernel/built-in.o: In function `free_event':
> > perf_event.c:(.text+0x66eb3): undefined reference to `irq_work_sync'
> > kernel/built-in.o: In function `perf_output_put_handle':
> > perf_event.c:(.text+0x680e1): undefined reference to `irq_work_queue'
> > kernel/built-in.o: In function `__perf_event_overflow':
> > perf_event.c:(.text+0x6a75e): undefined reference to `irq_work_queue'
> > make: *** [.tmp_vmlinux1] Ошибка 1
> >
> > kernel.org git master up to
> >
> > commit eb8abb927ae2fd1730e24ea94cd9527f3c086292
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Tue Nov 2 09:34:50 2010 -0400
> >
> >    ext4: Remove useless spinlock in ext4_getattr()
> >
> >
> >
> > this is my .config
>
> I build with you .config, but no error.
>
> Maybe you can make distclean and re-build.
>
> Lin Ming

No, same error.

I'm using (Linux/GNU Binutils) 2.20.51.0.8.20100412 , gcc (GCC) 4.4.4 on 
Slackware -current box (glibc-2.12.1-i486-2). Not sure what else i can do for 
debugging this.
