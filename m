Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2GJRTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:19:13 -0400
Received: from mail.ausil.us ([74.119.218.133]:41041 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab2GJRTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:19:12 -0400
X-Greylist: delayed 1547 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2012 13:19:12 EDT
Date: Tue, 10 Jul 2012 11:52:55 -0500
From: Dennis Gilmore <dennis@ausil.us>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120710115255.3a85e0b2@adria.ausil.us>
In-Reply-To: <20120710101018.GE15120@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de>
	<20120710071023.GA10456@gmail.com>
	<20120710101018.GE15120@arm.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q6AHJKbf024953

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

El Tue, 10 Jul 2012 11:10:18 +0100
Catalin Marinas <catalin.marinas@arm.com> escribiÃ³:
> On Tue, Jul 10, 2012 at 08:10:23AM +0100, Ingo Molnar wrote:
> > * Arnd Bergmann <arnd@arndb.de> wrote:
> > > On Saturday 07 July 2012, Olof Johansson wrote:
> > > > > ARM introduced AArch64 as part of the ARMv8 architecture
> > > > 
> > > > With the risk of bikeshedding here, but I find the name
> > > > awkward. How about just naming the arch port arm64 instead?
> > > > It's considerably more descriptive in the context of the
> > > > kernel.  For reference, we didn't name ppc64, nor powerpc,
> > > > after what the IBM/power.org marketing people were currently
> > > > calling the architecture at the time either.
> > > 
> > > I agree the name sucks, [...]
> > 
> > So why not change it now, when it only bothers a few dozen 
> > people and it is only present in 36 patches? Why go full steam 
> > ahead to annoy thousands of people with it and why spread the 
> > naming madness to thousands of commits?
> 
> Changing the arch/ dir name is easy at this point. My preference is
> for consistency with the official name (that cannot be changed) and
> the gcc triplet. I also don't think it annoys thousands of people,
> most don't really care. The few reactions I've seen is pretty much
> because people were expecting arm64 and it came as something else.
> 
> But I'll make a decision on this before the next version of the
> series.
> 
> > > [...] This also includes the rpm and dpkg architecture names, 
> > > and the string returned by the uname syscall. If everything 
> > > else is aarch64, we should use that in the kernel directory 
> > > too, but if everyone calls it arm64 anyway, we should probably 
> > > use that name for as many things as possible.
> > 
> > Yeah.
> 
> What are Red Hat's plans for the AArh64 rpm architecture name?

the rpm arch will be the output of uname -m

As i've said previously I personally prefer arm64 I think it will be
better for users but they will learn if it ends up being aarch64.


if uname -m is arm64 we will have foo-1.1-1.arm64.rpm 
if uname -m ends up as aarch64 we will have foo-1.1-1.aarch64.rpm

Dennis
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk/8XewACgkQkSxm47BaWfe/xwCgqq9ctMj9VG6zruJtmLDzrRZM
Ew8AoJRACBzQCLHLkoSveQ+2XoIrw1rY
=e8W0
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
