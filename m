Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab1HZRyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 13:54:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:51696 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1HZRyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 13:54:21 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110826104031.4c5861e5.rdunlap@xenotime.net>
References: <20110826150000.302334d0b86c17cd9b89b590@canb.auug.org.au>
	<205ae102ed038641e32cf38c48334f9e.squirrel@xenotime.net>
	<CA+icZUX1zaw7xxka8yP4B0tFt7XgXe=8faw8vBnNWm+6teJVaA@mail.gmail.com>
	<20110826104031.4c5861e5.rdunlap@xenotime.net>
Date: Fri, 26 Aug 2011 19:54:18 +0200
Message-ID: <CA+icZUVC_Sfbc=kqzq-PpDnwLJkSRc1+rraWiopz9nnaxutF1Q@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 26 (i7core_edac)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-edac@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 7:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Fri, 26 Aug 2011 16:16:11 +0200 Sedat Dilek wrote:
>
>> On Fri, Aug 26, 2011 at 10:07 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> >
>> > On Thu, August 25, 2011 10:00 pm, Stephen Rothwell wrote:
>> >> Hi all,
>> >>
>> >> The powerpc allyesconfig build still fails today.
>> >>
>> >> Changes since 20110825:
>> >
>> >
>> > on i386:
>> >
>> > ERROR: "__udivdi3" [drivers/edac/i7core_edac.ko] undefined!
>> >
>> > in both get_sdram_scrub_rate()
>> > and set_sdram_scrub_rate()
>> >
>> > --
>>
>> Hi Randy,
>>
>> can you test with the patch attached, please?
>>
>> ( UNTESTED, just followed patches like "[PATCH] p54: Use do_div for
>> 64-bit division to fix 32-bit kernels" or "[PATCH v1] carl9170: Use
>> do_div for 64-bit division to fix 32-bit kernels" )
>
> Yes, this works after I removed the extra right parens in both cases.

The closing brackets were a test for you (indeed they are wrong).

> (did you test it?)
>

No, even not compile-tested, still struggling with todays linux-next.
Seems I am not alone [1].

- Sedat -

[1] http://lkml.org/lkml/2011/8/26/300

> thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
