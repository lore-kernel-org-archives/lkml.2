Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab2CaUBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 16:01:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52186 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2CaUBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 16:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <31523.1333222099@redhat.com>
References: <1333086729-14263-1-git-send-email-gerg@uclinux.org>
	<31523.1333222099@redhat.com>
Date: Sat, 31 Mar 2012 22:01:48 +0200
X-Google-Sender-Auth: 7AMM6scpP_CDRASBZmENpOKYdjc
Message-ID: <CAMuHMdWmq9LagZ4FydtUesq8088aWpQ29s54+4srEW5_jJy8vQ@mail.gmail.com>
Subject: Re: [PATCH] m68k: include asm/cmpxchg.h in our m68k atomic.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: gerg@uclinux.org, linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 21:28, David Howells <dhowells@redhat.com> wrote:
> <gerg@uclinux.org> wrote:
>
>> From: Greg Ungerer <gerg@uclinux.org>
>>
>> After commit 9ffc93f203c18a70623f21950f1dd473c9ec48cd ("Remove all
>>
>>   CC      init/main.o
>> In file included from include/linux/mm.h:15:0,
>>                  from include/linux/ring_buffer.h:5,
>>                  from include/linux/ftrace_event.h:4,
>>                  from include/trace/syscall.h:6,
>>                  from include/linux/syscalls.h:78,
>>                  from init/main.c:16:
>> include/linux/debug_locks.h: In function ‘__debug_locks_off’:
>> include/linux/debug_locks.h:16:2: error: implicit declaration of function ‘xchg’
>>
>> There is no indirect inclusions of the new asm/cmpxchg.h for m68k here.
>> Looking at most other architectures they include asm/cmpxchg.h in their
>> asm/atomic.h. M68k currently does not do this. Including this in atomic.h
>> fixes all m68k build problems.
>>
>> Signed-off-by: Greg Ungerer <gerg@uclinux.org>
>
> Acked-by: David Howells <dhowells@redhat.com>

Thanks! I hope to create for-3.4 and for-3.5 branches tomorrow.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
