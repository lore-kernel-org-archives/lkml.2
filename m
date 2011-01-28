Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab1A1U3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:29:18 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:34029 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287Ab1A1U3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:29:16 -0500
Date: Fri, 28 Jan 2011 21:29:05 +0100
From: Nico Schottelius <nico-kernel-20110117@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: New display errors in 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110128202905.GB3395@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DBIVS5p969aUjpLe"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DBIVS5p969aUjpLe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey hackers!

With 2.6.38-rc2-00175-g6fb1b30 I get a new version of broken
display I've never seen before: The display looks like a misconfigured
tv after 2-3 suspends. Switching to a different tty was possible (though
still same broken display, but allowed a reboot) one time, the other time=
=20
the system completly froze.

2.6.37, 2.6.37-05761-gf878133 and 2.6.37-07956-g8c34482 do not have this bu=
g.

Cheers,

Nico

--=20
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0

--DBIVS5p969aUjpLe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk1DJxEACgkQ19zI5DGHffAzJgCfZobtxCP514UjxNpU82VGJ0de
RpkAn18EXhDVIvVFEo2pub/i7wtqy2/P
=u4EU
-----END PGP SIGNATURE-----

--DBIVS5p969aUjpLe--
