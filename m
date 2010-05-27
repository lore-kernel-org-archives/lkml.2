Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0E0QTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:19:38 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58609 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0E0QTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:19:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qPSC/5xfxks9knFldQVAqDKOxleM6dkcBVywIc9a4CauwgH+To4AreQB64RCCxxiuQ
         8mC/iErcC/Wfl2ODiuyd/HpYRl44D8UNiGEfh1AQXLJF2ZD4qhrAazgRyWwdMxT6M+Jn
         IS9XuHxK0UamgZRKkdZUcN4fOB7uRvJ5Kxnxw=
MIME-Version: 1.0
In-Reply-To: <20100526223101.3f2dd7dd.rdunlap@xenotime.net>
References: <AANLkTik0PUKP3QLPRbb3nlh034_inmaeVbXy3q5_LQz-@mail.gmail.com>
	<201005270213.42913.rjw@sisk.pl>
	<AANLkTil180tPW4KoOaUBgXIm1Lf6O45_GKKlLx3CDcVh@mail.gmail.com>
	<20100527043123.GA5349@cr0.nay.redhat.com>
	<20100526223101.3f2dd7dd.rdunlap@xenotime.net>
Date: Thu, 27 May 2010 18:19:35 +0200
X-Google-Sender-Auth: 7Ay8hgQc0nlpTsKc-FRpd9cGDIA
Message-ID: <AANLkTik2ggnZYixbVPVDgQjUIsJVW-UQyItmR-soghc0@mail.gmail.com>
Subject: Re: config automatically switches from 32-bit to 64-bit for x86
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:31, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Thu, 27 May 2010 12:31:23 +0800 Américo Wang wrote:
>> On Thu, May 27, 2010 at 09:39:51AM +0530, Jaswinder Singh Rajput wrote:
>> >On Thu, May 27, 2010 at 5:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> >> On Thursday 27 May 2010, Jaswinder Singh Rajput wrote:
>> >>> Hello,
>> >>>
>> >>> I am trying to build 32 bit kernel image on 64-bit machine but after
>> >>> 'make menuconfig' it automatically switches 32-bit to 64-bit.
>> >>
>> >> Try 'linux32 make menuconfig' and 'linux32 make'.
>> >>
>> >
>> >Yes, this works :-)
>>
>>
>> I think 'make ARCH=i386 menuconfig' also works.
>
> Yes, that's what I use.  I wasn't familiar with the "linux32 make ..." usage.

Doesn't the linux32 trick run the (possibly slower due to x86 register pressure)
32-bit compiler instead of running the 64-bit compiler in -m32 mode?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
