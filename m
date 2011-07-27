Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1G0R3Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 13:29:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59175 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab1G0R3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 13:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <87k4b3iw91.wl%ysato@users.sourceforge.jp>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
	<CACqU3MX1ovaEO-n0TLXdfuCYkSO0+DedkBKuycmrc-t1FLa91w@mail.gmail.com>
	<87r55fdrs0.wl%ysato@users.sourceforge.jp>
	<CACqU3MWuZUG3XDxTRgBztyJa5rj-GQDcCDrLX1M-AThxtxfXRA@mail.gmail.com>
	<87k4b3iw91.wl%ysato@users.sourceforge.jp>
Date: Wed, 27 Jul 2011 13:29:13 -0400
Message-ID: <CACqU3MXj8-fD+RE6g_s8fHX0g_xMQRH40itHFCvFswvNLBqNaA@mail.gmail.com>
Subject: Re: Linux 3.0 release
From: Arnaud Lacombe <lacombar@gmail.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 27, 2011 at 11:22 AM, Yoshinori Sato
<ysato@users.sourceforge.jp> wrote:
> At Mon, 25 Jul 2011 11:50:43 -0400,
>> [...]
>> With this patch, it configures, at least, but build fails with:
>>
>> In file included from /src/linux/linux/include/linux/mempolicy.h:70:0,
>>                  from /src/linux/linux/init/main.c:49:
>> /src/linux/linux/include/linux/pagemap.h: In function 'fault_in_pages_readable':
>> /src/linux/linux/include/linux/pagemap.h:444:2: error: assignment of
>> read-only variable '__gu_val'
>> /src/linux/linux/include/linux/pagemap.h:450:5: error: assignment of
>> read-only variable '__gu_val'
>> make[2]: *** [init/main.o] Error 1
>> make[1]: *** [init] Error 2
>> make: *** [sub-make] Error 2
>
> OK.
> I pushing latest code in here.
> git.kernel.org/pub/scm/linux/kernel/git/ysato/h8300.git
> Please try it.
> I using gcc is v4.5.3
>
hum, official gcc seem to have plenty of instability with h8300. gcc
4.5.4 (20110726) goes further in the build, but triggers an ICE while
building `fs/read_write.c'.

Reported to upstream as http://gcc.gnu.org/bugzilla/show_bug.cgi?id=49874.

 - Arnaud

>> Cross-toolchain is baremetal binutils and gcc for their respective trunk:
>>
>> $ /src/h8300/obj/destdir/bin/h8300-elf-gcc -v
>> Using built-in specs.
>> COLLECT_GCC=/src/h8300/obj/destdir/bin/h8300-elf-gcc
>> COLLECT_LTO_WRAPPER=/src/h8300/obj/destdir/libexec/gcc/h8300-elf/4.7.0/lto-wrapper
>> Target: h8300-elf
>> Configured with: ../gcc/configure --prefix=/src/h8300/obj/destdir
>> --target=h8300-elf --enable-languages=c
>> Thread model: single
>> gcc version 4.7.0 20110609 (experimental) (GCC)
>>
>>  - Arnaud
>>
>> > --
>> > Yoshinori Sato
>> > <ysato@users.sourceforge.jp>
>> >
>
> --
> Yoshinori Sato
> <ysato@users.sourceforge.jp>
>
