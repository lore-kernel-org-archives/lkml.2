Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376Ab2JOEQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 00:16:05 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42038 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2JOEQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 00:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <507B63AC.3010807@xenotime.net>
References: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
	<507B63AC.3010807@xenotime.net>
Date: Mon, 15 Oct 2012 12:16:02 +0800
Message-ID: <CAGjg+kHFA=o4W9dsgts-ux768TiDp+py0K-m=-N_Lz-vManSwA@mail.gmail.com>
Subject: Re: Linux 3.7-rc1 (uml uapi errors)
From: Alex Shi <lkml.alex@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard@nod.at>, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
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
>

Bisect said the commit 244acb1ba3777c2eb4d33ddc246cab5419656442 cause
this issue.

-- 
Thanks
    Alex
