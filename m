Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2JOJSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 05:18:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:64892 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab2JOJSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 05:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvwo3W7tA1QcParfqdUSUsJjWrim_45vBVTPWihBjKHA+w@mail.gmail.com>
References: <CA+55aFyt0KFNp5Binu-c3-XzF=MG+23EDOk1R6t4qqgW58ksAw@mail.gmail.com>
	<507B63AC.3010807@xenotime.net>
	<CAGjg+kHFA=o4W9dsgts-ux768TiDp+py0K-m=-N_Lz-vManSwA@mail.gmail.com>
	<CAFLxGvwo3W7tA1QcParfqdUSUsJjWrim_45vBVTPWihBjKHA+w@mail.gmail.com>
Date: Mon, 15 Oct 2012 17:18:05 +0800
Message-ID: <CAGjg+kGxv-Hxi2wwsBt+3cjUQjvEf4tQ7WTCTPyp+M1AxdHhsg@mail.gmail.com>
Subject: Re: Linux 3.7-rc1 (uml uapi errors)
From: Alex Shi <lkml.alex@gmail.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Richard Weinberger <richard@nod.at>, rmk+kernel@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, something in my side. the bisect result is unreliable. I will redo.

On Mon, Oct 15, 2012 at 4:30 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Mon, Oct 15, 2012 at 6:16 AM, Alex Shi <lkml.alex@gmail.com> wrote:
>>>
>>> Building um (uml) for x86_64 (defconfig) has lots of errors like:
>>>
>>> In file included from include/linux/irq.h:22:0,
>>>                  from include/asm-generic/hardirq.h:12,
>>>                  from arch/um/include/generated/asm/hardirq.h:1,
>>>                  from include/linux/hardirq.h:7,
>>>                  from include/linux/ftrace_event.h:7,
>>>                  from include/trace/syscall.h:6,
>>>                  from include/linux/syscalls.h:78,
>>>                  from init/noinitramfs.c:23:
>>> include/linux/irqnr.h:4:30: fatal error: uapi/linux/irqnr.h: No such file or directory
>>>
>>
>> Bisect said the commit 244acb1ba3777c2eb4d33ddc246cab5419656442 cause
>> this issue.
>>
>
> Alex, are you sure?
> This is a merge commit.
>
> --
> Thanks,
> //richard



-- 
Thanks
    Alex
