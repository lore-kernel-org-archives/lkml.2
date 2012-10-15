Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2JOBPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 21:15:33 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:41279 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752660Ab2JOBPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 21:15:32 -0400
Message-ID: <507B63AC.3010807@xenotime.net>
Date: Sun, 14 Oct 2012 18:15:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: Linux 3.7-rc1 (uml uapi errors)
References: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
In-Reply-To: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 03:27 PM, Linus Torvalds wrote:

> The two weeks are up, and I was merging during my trip, so no reason
> for merge window extensions.
> 
> The 3.7-rc1 kernel is out there. There's a few big things worth noting here:
> 
>  - the "uapi" include file cleanups. The idea is that the stuff
> exported to user space should now be found under include/uapi and
> arch/$(ARCH)/include/uapi.
> 
>    Let's hope it actually works. Because otherwise this was just a
> totally pointless pain in the *ss. And regardless, I'm definitely done
> with these kinds of "let's do massive cleanup of the include files"
> forever.



Building um (uml) for x86_64 (defconfig) has lots of errors like:

In file included from include/linux/irq.h:22:0,
                 from include/asm-generic/hardirq.h:12,
                 from arch/um/include/generated/asm/hardirq.h:1,
                 from include/linux/hardirq.h:7,
                 from include/linux/ftrace_event.h:7,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:78,
                 from init/noinitramfs.c:23:
include/linux/irqnr.h:4:30: fatal error: uapi/linux/irqnr.h: No such file or directory

make[2]: *** [init/main.o] Error 1
make[2]: *** [init/noinitramfs.o] Error 1
make[2]: *** [init/do_mounts.o] Error 1
make[2]: *** [arch/um/kernel/irq.o] Error 1






-- 
~Randy
