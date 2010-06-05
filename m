Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab0FEOK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 10:10:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51067 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933319Ab0FEOK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 10:10:27 -0400
Date: Sun, 6 Jun 2010 00:10:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/8] revised patch for arch/tile/ support
Message-Id: <20100606001017.eec90e38.sfr@canb.auug.org.au>
In-Reply-To: <4C0A5180.9010702@tilera.com>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com>
	<201005290333.o4T3Xjse029917@farm-0002.internal.tilera.com>
	<201005291329.10941.arnd@arndb.de>
	<201006032240.31963.arnd@arndb.de>
	<4C097104.3080406@tilera.com>
	<20100605225605.4e44d4e4.sfr@canb.auug.org.au>
	<4C0A5180.9010702@tilera.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__6_Jun_2010_00_10_17_+1000_QUIoclj_vyxIPtge"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__6_Jun_2010_00_10_17_+1000_QUIoclj_vyxIPtge
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

On Sat, 05 Jun 2010 09:30:40 -0400 Chris Metcalf <cmetcalf@tilera.com> wrot=
e:
>
> Thanks, Stephen.  One question: has linux-next reached the point where
> Linus pulls from it automatically during each merge window, or should I
> still ask Linus explicitly to pull for the 2.6.36 merge window?

You need to ask Linus to pull your tree when you are ready.

P.S. I noticed that you just added a commit with no Signed-off-by ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__6_Jun_2010_00_10_17_+1000_QUIoclj_vyxIPtge
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwKWskACgkQjjKRsyhoI8zQHACcDAJTgFUQZO6T3Pn66wZ88P34
a8oAn0Klv9UtalNkXG/3pyabFh0ibTM0
=jj7D
-----END PGP SIGNATURE-----

--Signature=_Sun__6_Jun_2010_00_10_17_+1000_QUIoclj_vyxIPtge--
