Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab0GKG6J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 02:58:09 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51874 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0GKG6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 02:58:08 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tuxonice-devel@tuxonice.net, linux-kernel@vger.kernel.org
Subject: Fwd: [TuxOnIce-devel] hang on hibernation with kernel 2.6.34.1 and TuxOnIce 3.1.1.1
Date: Sun, 11 Jul 2010 08:58:03 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34.1-tp42-toi-3.1.1.1-04990-g3a7d1f4; KDE/4.4.4; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1610447.Z53E1hrCNW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007110858.03932.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1610447.Z53E1hrCNW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


Hi!

Since I initially guessed this to be more likely a vanilla kernel than a=20
TuxOnIce bug, I might just ask on kernel mailinglist, whether someone can=20
tell me on where to sort this backtrace. I do not really have an exact=20
idea what subsystem this is. Async I/O?

Ciao,
Martin

=2D---------  Weitergeleitete Nachricht  ----------

Subject: [TuxOnIce-devel] hang on hibernation with kernel 2.6.34.1 and=20
TuxOnIce 3.1.1.1
Date: Samstag 10 Juli 2010
=46rom: Martin Steigerwald <Martin@lichtvoll.de>
To: tuxonice-devel@lists.tuxonice.net


Hi Nigel, hi everyone else,

yesterday I had a hang on hibernation:

http://martin-steigerwald.de/tmp/hang-on-hibernation-2.6.31.1-
toi-3.1.1.1/backtrace.jpg

I have not the foggiest about this one.

Anyone a clue?

Does it make sense to report upstream? To me this does not look TuxOnIce=20
related, but I am not sure, maybe its something regarding TuxOnIce async=20
I/O. First I misread dpm as drm and thought of a Radeon DRM problem...

Any idea on debugging?

I am not willing to put much time into it right now, so no bisecting. This=
=20
is still a production machine. Again I will just downgrade the kernel when=
=20
it doesn't work. Its still called "stable" on kernel.org. I can try to ssh=
=20
into the machine next time, but I doubt it will work, cause it was=20
hibernating already.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

=2D------------------------------------------------------

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1610447.Z53E1hrCNW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw5a3sACgkQmRvqrKWZhMf7vACgi00KlEoJ3+gT/VlT+OlhKRKU
8uwAnRjafdbqE+jmAHtODDXiT8pIw6n0
=2asQ
-----END PGP SIGNATURE-----

--nextPart1610447.Z53E1hrCNW--
