Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2EEWBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 18:01:05 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:36943 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab2EEWBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 18:01:03 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix compile failure on PA-RISC
Date: Sun, 06 May 2012 00:00:43 +0200
Message-ID: <4696140.nzSZDxnI1S@donald.sf-tec.de>
User-Agent: KMail/4.8.3 (Linux/3.2.9-13-desktop; KDE/4.8.3; i686; ; )
In-Reply-To: <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
References: <Pine.LNX.4.64.1205042250130.18896@file.rdu.redhat.com> <Pine.LNX.4.64.1205051448400.2623@file.rdu.redhat.com> <CA+55aFy2O8KcLC-yGCG2ZRpCpAdZ_T7z-sSme4fMrXG=YNAAhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart8628527.YMkJWkif5a"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart8628527.YMkJWkif5a
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

Linus Torvalds wrote:
> On Sat, May 5, 2012 at 11:53 AM, Mikulas Patocka <mpatocka@redhat.com> 
wrote:
> > What NO_IRQ problem do you mean? There is
> > #define NO_IRQ          (-1)
> > in arch/parisc/include/asm/irq.h.
> 
> That's the one he means.
> 
> Switching it to zero and testing that things still work would be
> appreciated.
> 
> Much code already knows that NO_IRQ is supposed to be zero, and
> there's tons of drivers that just do the (correct!) "if (!dev->irq)"
> kind of thing.
> 
> Any architecture that has a non-zero NO_IRQ is basically broken.
> Always has been.

The stuff in drivers/parisc/gsc.c doesn't look as if it would survive that 
change.

Eike
--nextPart8628527.YMkJWkif5a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEABECAAYFAk+loxkACgkQXKSJPmm5/E6KQQCeIUj/xTTc2TaeoMjlB9IRCEXF
JPsAn0UvZ8cpqwOwRgVbJh+PWpzwwMWB
=pn4l
-----END PGP SIGNATURE-----

--nextPart8628527.YMkJWkif5a--

