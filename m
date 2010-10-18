Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab0JRHE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 03:04:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39775 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab0JRHEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 03:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=J2VU7Dcq1rzYEh3jAMdo14XCthM+2oX9yP/7roJubNih/a89jvtscUesFuLaKtBeTR
         Z5nnwqD1ehqfBE/aZAKjK7TVVbjjUHnnVwuLhXuzPwM0ZztFV5wbgqEKCNsSNa/b1U/c
         VZqqgvyfU8DznOW7sP8goz0bE53fBXzwxFltM=
MIME-Version: 1.0
In-Reply-To: <20101018162744.412d8989.sfr@canb.auug.org.au>
References: <alpine.DEB.2.00.1010161656590.12912@ayla.of.borg>
	<alpine.DEB.2.00.1010161722120.30415@ayla.of.borg>
	<20101016151442.a21769f6.rdunlap@xenotime.net>
	<AANLkTinLBfAqRtd22MJtN+-LYsfvPSnRWcS97iM2PGJy@mail.gmail.com>
	<20101017201705.75e381d0.sfr@canb.auug.org.au>
	<20101018162744.412d8989.sfr@canb.auug.org.au>
Date: Mon, 18 Oct 2010 09:04:24 +0200
X-Google-Sender-Auth: R-BEFan30Pf1D5EHokrAFgUHwog
Message-ID: <AANLkTi=GdSaC9AjQjvJr_GWwGQgJYBe+jgkUYsrhqdah@mail.gmail.com>
Subject: Re: Build regressions/improvements in v2.6.36-rc8
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        michael@ellerman.id.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 07:27, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Sun, 17 Oct 2010 20:17:05 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> On Sun, 17 Oct 2010 10:02:25 +0200 Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > On Sun, Oct 17, 2010 at 00:14, Randy Dunlap <rdunlap@xenotime.net> wrote:
>> > > BTW, do you use LC_ALL=C when doing builds?  I'd like to be able to read
>> > > messages like this one:
>> > >
>> > > src/Documentation/spi/spidev_test.c:56: warning: (near initialization for â€˜trâ€™): 1 warnings in 1 logs

That should be

src/Documentation/spi/spidev_test.c:56: warning: (near initialization for ‘tr’)

Just the shiny quotes got mangled.

>> >
>> > I just grab the logs from the linux-next build service.
>>
>> I will talk to Michael about that.
>
> Turns out that we do build with LANG=C, but the Geert is grabbing the
> logs embedded within the full results web page (which converts the '
> characters to &#39).
>
> Geert, to fetch the full log as a text file, just append "log/" to the
> results page url.  For further help with what you are trying to do,
> please email Michael Ellerman (cc'd).  He can possibly add useful other
> urls or interfaces for you.

I do fetch the log/ URLs.

But it seems alpine sends out my emails as:

    Content-Type: TEXT/PLAIN; charset=ISO-8859-7

while it should be UTF-8. Strange, as I never specify that in the .pinerc...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
