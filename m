Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab2IPTbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 15:31:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61437 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2IPTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 15:31:07 -0400
MIME-Version: 1.0
In-Reply-To: <201208031311.33228.arnd@arndb.de>
References: <1343310254-7493-1-git-send-email-will.deacon@arm.com>
	<20120803125144.GD26925@mudshark.cambridge.arm.com>
	<20120803130230.GA9812@merkur.ravnborg.org>
	<201208031311.33228.arnd@arndb.de>
Date: Sun, 16 Sep 2012 21:31:07 +0200
X-Google-Sender-Auth: _YayyU388Sy20m3TxIbqq2lmnes
Message-ID: <CAMuHMdUBxwqBJ-XTvupfoz6Srcj9gYjfok3mykD76jgyQ5ySCw@mail.gmail.com>
Subject: Re: [PATCH] kbuild: kvm: make export of linux/kvm_para.h unconditional
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Will Deacon <will.deacon@arm.com>,
        Avi Kivity <avi@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 3, 2012 at 3:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 03 August 2012, Sam Ravnborg wrote:
>> > > I know we here hit a bad thing with the generic-y support,
>> > > where we miss a good way to add a file to a lot of archs
>> > > without editing a lot of files.
>> >
>> > If there isn't a generic version of the header, then yes, I guess you have
>> > to modify the architectures that want to export it.
>> >
>> > I'm happy to post an extra patch sorting out kvm.h and a.out.h if that's
>> > what's required to get headers building again.
>>
>> IMO this is required to sort this out for good.
>> I will be happy to review your patches.
>
> I also owe Mark Brown a solution for the asm/clkdev.h redirect,
> as by http://lkml.indiana.edu/hypermail/linux/kernel/1207.0/01141.html
>
> I would very much like to avoid adding another wildcard logic for
> generic-y, but I could not figure out how to do that better.

Any progress on this one?
It's a regression in 3.5 for sh, and 3.6-rc for m68k.

Thx!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
