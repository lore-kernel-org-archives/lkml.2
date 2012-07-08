Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab2GHWuB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:50:01 -0400
Received: from mail.ausil.us ([74.119.218.133]:50989 "EHLO mail.ausil.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab2GHWt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:49:59 -0400
X-Greylist: delayed 1510 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jul 2012 18:49:59 EDT
Date: Sun, 8 Jul 2012 17:24:19 -0500
From: Dennis Gilmore <dgilmore@fedoraproject.org>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
Message-ID: <20120708172419.2b2f2713@pegasus.ausil.us>
In-Reply-To: <4FF9D1E9.4050504@jonmasters.org>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
	<CAOesGMiCexiqA3L5GdNgyHhSD-5Bpqbb02YJrZPr8yMYa0afjA@mail.gmail.com>
	<201207071927.13135.arnd@arndb.de>
	<4FF93C99.80203@redhat.com>
	<4FF9D1E9.4050504@jonmasters.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q68MoDwN012581

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Sun, 08 Jul 2012 14:31:05 -0400
Jon Masters <jonathan@jonmasters.org> wrote:

> On 07/08/2012 03:54 AM, Jon Masters wrote:
> 
> > In our bikeshedding conversations pondering future Fedora support,
> > we've pretty much settled on the aarch64 name now, and the hope is
> > that we can also avoid providing 32-bit compatibility (multi-arch)
> > by relying on virtualized guests for any 32-bit story. If that
> > holds, we have some flexibility to e.g. go for 64K page size, etc.
> > if we want.
> 
> Let me rephrase that to avoid missunderstanding. I am the strongest
> advocate of the "aarch64" name on our end. Others disagreed with that,
> but when the tooling, kernel, and other stuff settled on the same
> uniform name, it was my understanding that this was de facto settled.
> However, it would be wrong to say there are not dissenting viewpoints.
> 
> My biggest fear here, however, is that we end up bikeshedding this to
> death, and we then have some use of one name, some of "arm64", and
> distros failing to agree on things like the correct triplet to use for
> the new architecture (we had some issues with this before). So, if
> we're going to argue over the name and make changes, let's do it now.
> There seems to be no value in the toolchain using one name, which is
> already upstream, and the kernel using another name.
> 
> Jon.

I agree that we should be consistent between the tools and kernel.
triplets will always be different between distros.  I think that is a
given.  I personally don't like the name AArch64 I think that the Arch
is redundant and that the A is way to vague. is it Alpha? ARM? AMD?
armada-xp? Athlon? <insert other architecture related computing name
starting with A>? Yum today supports arm64 i do think that the distro
users at first will expect arm64 and go looking for the bits under
patches with arm64 in them. with education they will learn and it will
become second nature but that will take time. 

I know that the architecture really is new but thats not really clear
by adding AArch32 into the mix to represent 32 bit arm as ARM has done
or by calling it armv8. There is enough way to confuse them already why
confuse things more by adding yet another variable that is AArch64.
- From my and most of the other Fedora developers that i've discussed it
with its more like reluctant acceptance of AArch64 than thinking is a
good idea. 

Dennis
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk/6CJkACgkQkSxm47BaWfdT2QCdFf7lgiy2EoLhxIsPJ3L6N8UI
ILsAn2V+M2xX0vHhsAiL7hu5UL1vHn2Y
=OEuo
-----END PGP SIGNATURE-----
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
