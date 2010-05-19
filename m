Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab0ESVeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 17:34:15 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46533 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab0ESVeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 17:34:13 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 17:34:12 EDT
Date: Wed, 19 May 2010 23:34:08 +0200
From: Pierre Ossman <pierre@ossman.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100519233408.7436bd9b@mjolnir.ossman.eu>
In-Reply-To: <20100519232906.3be82279@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-29913-1274304849-0001-2"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-29913-1274304849-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 19 May 2010 23:29:06 +0200
Pierre Ossman <pierre@ossman.eu> wrote:

>=20
> Noteworthy is also that the last three nibbles of the corruption are
> always the same (xxxxx380 =3D> xxxxxf80).
>=20

I'm mostly talking to myself at this point, but one thing that occurs
to me here is 4096 sectors line up decently with the numbers above.
0x380 is just at the end of a 512 byte sector, and 0xf80 is just at the
end of a 4096 byte one. Not sure it's relevant, but then again I've
stayed blissfully unaware of how this sector size transformation is
going to happen. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-29913-1274304849-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv0WVIACgkQ7b8eESbyJLgZUgCgsY7YrpyX6TqrtnNtMW0K0He5
OmIAoOM5P5j62u2uvrlDoOqA9msdA8Ly
=40IC
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-29913-1274304849-0001-2--
