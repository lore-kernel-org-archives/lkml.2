Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab1BXFky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:40:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53267 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab1BXFkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:40:53 -0500
Date: Thu, 24 Feb 2011 16:40:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20110224164048.4d884c1d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Feb_2011_16_40_48_+1100_yh5ZHsP6zc9nLgg."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Feb_2011_16_40_48_+1100_yh5ZHsP6zc9nLgg.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

scripts/Makefile.modbuiltin:25: drivers/char/pcmcia/ipwireless/Makefile: No=
 such file or directory
make[5]: *** No rule to make target `drivers/char/pcmcia/ipwireless/Makefil=
e'.  Stop.

Caused by commit 282361a046edd9d58a134f358a3f65a7cb8655d9 ("tty: move
ipwireless driver from drivers/char/pcmcia/ to drivers/tty/") which
neglected to remove mention of ipwireless from
drivers/char/pcmcia/Makefile.

I have used the tty tree from next-20110223 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Feb_2011_16_40_48_+1100_yh5ZHsP6zc9nLgg.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNZe9gAAoJEDMEi1NhKgbsJ4sH/079+UczzZ6qM+LNA1HuQMxi
JXWVhMb4l7ABYZXpKM+PgcBDKiCJXz/ZVpV9hZtZm7llhnjbQEknyZnv12HAne5n
iBrBEWGMtlASoMfeqyITbw5/YsxHwgnesuWQGaqNNbaiWJryl4Be2kKwhionkKxZ
eNrhsZkS3p1Pp65zxEVyWuCwbRztBTI4LMPdyyDGNi/MP+GOii9TTYFiCooS4ovx
/JQQdCuCF5TMM/qVeZNdAC08zAX6gbGQyifTqwUG86LG1qvFTUgkt1eRdP4Gjuhj
7NLy28YizimlOCPkhZXPtu1wAOBzBirUgDKcfc2VauniKIG8tebHNdWrnQ1XFwE=
=SHXT
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Feb_2011_16_40_48_+1100_yh5ZHsP6zc9nLgg.--
