Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2EBHi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 03:38:56 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52222 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab2EBHiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 03:38:55 -0400
Message-ID: <4FA0E485.80902@googlemail.com>
Date: Wed, 02 May 2012 09:38:45 +0200
From: Tobias Powalowski <tobias.powalowski@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120426 Thunderbird/12.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Possible 32bit i686 kernel hard crash bug 3.3.4?
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A21E92AA1FAF12A0BF26716"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A21E92AA1FAF12A0BF26716
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
since we bumped to 3.3.4 some users reported hard crashes:
https://bugs.archlinux.org/task/29694
I cannot exactly say what it triggers it happens for me randomly.
This kernel version is not usable for my server anymore.
Hope you can help us. x86_64 seems not to be affected.

greetings
tpowa

--=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org



--------------enig8A21E92AA1FAF12A0BF26716
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJPoOSKAAoJEHcd9mJ+32gf1TUH/R0GZUeRY1U3ZMPNSuiA4gLJ
6V3uDkx7SZOSB6KfHbBz1IK7wfspB8NMbL+dhQgzXO92V/KTrb4vQHzRoFec/XwD
8IGfFB34drrf/mMKhbMVIwxaw/YybUjbB+fyCyHbkHyrhjy5okfPr3NhujpaKlM7
D35IR8LcrUlm9H9lI/QeMu9QozpqvkWILCkS5iguOMuXcSJMG1K2+y4RTU6GzeUm
S+NuRwqLnlxbFGlMb4Bm681zwiZtEkIpOTeVOxBB3s3VZkRV+EEzF9aJEjhDFh46
t40mSvSHVZPzvYWci1BcPMX5vGu5/uegEHPoZnhEwstgVa+N1gl8OsVFDWIV8sg=
=ocs0
-----END PGP SIGNATURE-----

--------------enig8A21E92AA1FAF12A0BF26716--
