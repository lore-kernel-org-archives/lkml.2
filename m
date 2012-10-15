Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab2JONIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 09:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753120Ab2JONIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 09:08:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <507B63AC.3010807@xenotime.net>
References: <507B63AC.3010807@xenotime.net> <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: Linux 3.7-rc1 (uml uapi errors)
Date: Mon, 15 Oct 2012 14:08:33 +0100
Message-ID: <8760.1350306513@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> wrote:

> Building um (uml) for x86_64 (defconfig) has lots of errors like:
> 
> In file included from include/linux/irq.h:22:0,
>                  from include/asm-generic/hardirq.h:12,
>                  from arch/um/include/generated/asm/hardirq.h:1,
>                  from include/linux/hardirq.h:7,
>                  from include/linux/ftrace_event.h:7,
>                  from include/trace/syscall.h:6,
>                  from include/linux/syscalls.h:78,
>                  from init/noinitramfs.c:23:
> include/linux/irqnr.h:4:30: fatal error: uapi/linux/irqnr.h: No such file or directory

Apart from needing to #include asm/siginfo.h into linux/coredump.h, -rc1
builds fine for me for UM with or without O= on the make line with a SUBARCH
of i386, x86_64 or x86.

What SUBARCH did you use?  Can you give me your .config?  Can you compile with
V=1 and give me the compilation line for that file?

David
