Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab0EaUPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 16:15:23 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48014 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab0EaUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 16:15:21 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [regression] Please add bug 15788 and 15969, usb sound / radeon kms broken after snapshot cycle
Date: Mon, 31 May 2010 22:15:04 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-tp42-toi-3.1-radeon-kms-agp-suspend-04981-gb9a071a-dirty; KDE/4.4.3; i686; ; )
Cc: linux-kernel@vger.kernel.org,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1372653.zhlqzsHAFM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005312215.17793.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1372653.zhlqzsHAFM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi Rafael,

please add

Bug 15788 -  external usb sound card doesn't work after resume
https://bugzilla.kernel.org/show_bug.cgi?id=3D15788

to your regression list.

And

Bug 15969 -  radeon regression couldn't schedule IB on resume with 2.6.34-
rc7=20
https://bugzilla.kernel.org/show_bug.cgi?id=3D15969

Thanks.

I find it irritating that a stable kernel is released with regressions like=
=20
this, but that seems to be what I can get for not waiting for 2.6.34.2 or=20
higher.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1372653.zhlqzsHAFM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwEGMkACgkQmRvqrKWZhMdAgwCbBdJwVp317zPLsQJcr0+fsHzk
6+4AoIUVFZF5DOUVof0Ifj1AEp155JWn
=9kYJ
-----END PGP SIGNATURE-----

--nextPart1372653.zhlqzsHAFM--
