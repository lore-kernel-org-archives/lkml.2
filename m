Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1LYQZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:25:33 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38198 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LYQZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:25:30 -0500
MIME-Version: 1.0
In-Reply-To: <CAFLxGvx7p=meL5fujby_sc+CM3UUe7jbgSzSKpqLaWwXJopo+A@mail.gmail.com>
References: <1324824127-10540-1-git-send-email-geert@linux-m68k.org>
	<CAFLxGvx7p=meL5fujby_sc+CM3UUe7jbgSzSKpqLaWwXJopo+A@mail.gmail.com>
Date: Sun, 25 Dec 2011 17:25:28 +0100
X-Google-Sender-Auth: hIkKkyshZb3Js2ZwSTFtFwNX7Qk
Message-ID: <CAMuHMdUTZPwKte_Z11utSrgVo9-+0Lav1DLHFqSXr+sizN0O3A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.2-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 25, 2011 at 16:55, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Sun, Dec 25, 2011 at 3:42 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>>  + src/arch/um/os-Linux/skas/process.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 321, 552
>>  + src/arch/um/os-Linux/skas/process.c: error: (Each undeclared identifier is reported only once:  => 321
>>  + src/arch/um/os-Linux/skas/process.c: error: for each function it appears in.):  => 321
>>  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_O_TRACESYSGOOD' undeclared (first use in this function):  => 302, 244
>>  + src/arch/um/os-Linux/start_up.c: error: 'PTRACE_SETOPTIONS' undeclared (first use in this function):  => 243, 301
>>  + src/arch/um/os-Linux/start_up.c: error: (Each undeclared identifier is reported only once:  => 243
>>  + src/arch/um/os-Linux/start_up.c: error: for each function it appears in.):  => 243
>
> *confused*
>
> UML 3.2-rc7 builds fine here.
> Both i386 and x86_64.

Same here (well, x86_64).

I guess it's a userspace issue, as for my builds, it picks up the definition of
PTRACE_O_TRACESYSGOOD from /usr/include/sys/ptrace.h
(not from include/linux/ptrace.h).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
