Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab1EGEzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 00:55:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38697 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1EGEza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 00:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Xj2Aun48XxCK/L80bVbUoNBmOm2mDomY7m2Er+5WZoKBA3nFpXFzApyYI6hhLhewoy
         YfAs/Lj/n8s5b1GpGmMGBnbq1fHWGWDX6Q5FMj7NH/sTk2GGa5jww+fWipZyyVpLxBnl
         9yfARH/NhKxnRoAci7XzLHsWLN8mryCec77pI=
MIME-Version: 1.0
In-Reply-To: <4DC427D4.7030903@gmail.com>
References: <4DC427D4.7030903@gmail.com>
Date: Sat, 7 May 2011 12:55:29 +0800
Message-ID: <BANLkTikvtJex=fGYw0f6v8pMKhkWmaM2sA@mail.gmail.com>
Subject: Re: compiling of tools/perf fail on x86 64bit kernel and 32bit userspace
From: Lin Ming <minggr@gmail.com>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 12:54 AM, Riccardo Magliocchetti
<riccardo.magliocchetti@gmail.com> wrote:
> Hi,
>
> with latest git, i cannot compile perf on 32 bit userspace with a 64 bit
> kernel.
>
> ~/src/linux-2.6/tools/perf$ make
> PERF_VERSION = 2.6.39.rc6.224.g06d006f
>    GEN common-cmds.h
>    * new build flags or prefix
>    CC perf.o
>    CC builtin-annotate.o
>    CC builtin-bench.o
>    CC bench/sched-messaging.o
>    CC bench/sched-pipe.o
>    CC bench/mem-memcpy-x86-64-asm.o
> bench/../../../arch/x86/lib/memcpy_64.S: Assembler messages:
> bench/../../../arch/x86/lib/memcpy_64.S:28: Error: bad register name `%rdi'
> bench/../../../arch/x86/lib/memcpy_64.S:33: Error: invalid instruction
> suffix for `movs'

Hi,

I just send out a patch to fix this.
https://lkml.org/lkml/2011/5/7/4

Could you have a try it?

Thanks,
Lin Ming
