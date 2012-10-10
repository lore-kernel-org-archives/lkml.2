Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab2JJQId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:08:33 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59486 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab2JJQI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:08:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s0TL+d6dOdScmoBR=hE8Jf_KZ_A+KHOJfHQD=p+0k+ZbQ@mail.gmail.com>
References: <506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	<87zk42tab4.fsf@xmission.com>
	<20121004174254.GA14301@kroah.com>
	<20121004201704.36d35755@pyramind.ukuu.org.uk>
	<CAMP44s0TL+d6dOdScmoBR=hE8Jf_KZ_A+KHOJfHQD=p+0k+ZbQ@mail.gmail.com>
Date: Wed, 10 Oct 2012 18:08:28 +0200
X-Google-Sender-Auth: aSdDFfrkrpLOmV7-t5dLiSFoYUE
Message-ID: <CAMuHMdUgppkHiNmNcDCaxOAL6+PmJCA_tbQkPG3gOZRs=jUt5Q@mail.gmail.com>
Subject: Re: udev breakages -
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kay Sievers <kay@vrfy.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 5:19 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Thu, Oct 4, 2012 at 9:17 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> I don't know how to handle the /dev/ptmx issue properly from within
>>> devtmpfs, does anyone?  Proposals are always welcome, the last time this
>>> came up a week or so ago, I don't recall seeing any proposals, just a
>>> general complaint.
>>
>> Is it really a problem - devtmpfs is optional. It's a problem for the
>> userspace folks to handle and if they made it mandatory in their code
>> diddums, someone better go fork working versions.
>
> If only there was a viable alternative to udev.
>
> Distributions are being pushed around by the udev+systemd project
> precisely because of this reason; udev maintainers have said that udev
> on non-systemd systems is a dead end, so everyone that uses udev
> (everyone) is being forced to switch to systemd if they want to
> receive proper support, and at some point there might not be even a
> choice.
>
> I for one would like an alternative to both systemd and udev on my
> Linux systems, and as of yet, I don't know of one.

A few years ago, the OpenWRT people pointed me to hotplug2 when I mentioned
udev made my poor m68k box with 12 MiB of RAM immediately go OOM.
Don't know if it's suitable for "bigger" machines, though.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
