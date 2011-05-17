Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1EQMYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:24:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42978 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713Ab1EQMYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:24:19 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Shiang Tu <shiang_tu@ralinktech.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-+K7cNoLCi2IAWvUsMdIv"
Date: Tue, 17 May 2011 13:24:12 +0100
Message-ID: <1305635052.19966.142.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: [GIT PULL linux-firmware.git] CIS source, Ralink firmware
 consolidation
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+K7cNoLCi2IAWvUsMdIv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The following changes since commit 82273130ddc0af5599b1138b07ebe6ceaabecb72=
:

  linux-firmware: bnx2: Update firmware and version (2011-05-11 00:27:11 +0=
100)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-firmware.git mast=
er

Ben Hutchings (3):
      Add source and copyright notice for CIS files from pcmcia-cs
      rt2860sta: Use latest firmware for RT3090
      rt2870sta: Use latest firmware for RT3070 and RT3071

 WHENCE                |   39 +++++++++++++++++++++++++++++++++------
 cis/src/3CCFEM556.cis |   22 ++++++++++++++++++++++
 cis/src/3CXEM556.cis  |   22 ++++++++++++++++++++++
 cis/src/COMpad2.cis   |   20 ++++++++++++++++++++
 cis/src/COMpad4.cis   |   14 ++++++++++++++
 cis/src/DP83903.cis   |   24 ++++++++++++++++++++++++
 cis/src/LA-PCM.cis    |   44 ++++++++++++++++++++++++++++++++++++++++++++
 cis/src/MT5634ZLX.cis |   18 ++++++++++++++++++
 cis/src/NE2K.cis      |   10 ++++++++++
 cis/src/PCMLM28.cis   |   37 +++++++++++++++++++++++++++++++++++++
 cis/src/PE-200.cis    |   11 +++++++++++
 cis/src/PE520.cis     |   11 +++++++++++
 cis/src/RS-COM-2P.cis |   14 ++++++++++++++
 cis/src/tamarack.cis  |   17 +++++++++++++++++
 rt3070.bin            |  Bin 4096 -> 10 bytes
 rt3071.bin            |  Bin 4096 -> 4096 bytes
 rt3090.bin            |  Bin 8192 -> 10 bytes
 17 files changed, 297 insertions(+), 6 deletions(-)
 create mode 100644 cis/src/3CCFEM556.cis
 create mode 100644 cis/src/3CXEM556.cis
 create mode 100644 cis/src/COMpad2.cis
 create mode 100644 cis/src/COMpad4.cis
 create mode 100644 cis/src/DP83903.cis
 create mode 100644 cis/src/LA-PCM.cis
 create mode 100644 cis/src/MT5634ZLX.cis
 create mode 100644 cis/src/NE2K.cis
 create mode 100644 cis/src/PCMLM28.cis
 create mode 100644 cis/src/PE-200.cis
 create mode 100644 cis/src/PE520.cis
 create mode 100644 cis/src/RS-COM-2P.cis
 create mode 100644 cis/src/tamarack.cis
 mode change 100644 =3D> 120000 rt3070.bin
 mode change 100644 =3D> 120000 rt3090.bin

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-+K7cNoLCi2IAWvUsMdIv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATdJo7Oe/yOyVhhEJAQo0bA//Y6k5fg0bVIDw3gBusdYgMCk2Unlrv20e
jRDq7SKlpVeXQ8LVGgsMogVTB/yRbUq5BAsWkWSy3KalpU9t/sVSieoTtJL9OyS5
DM9a1jDGDOIXmurA2IUQ/GAMDNdfD9esJ/tExhR9bRRMkCpVrA0H2JRQ0yq3GyF1
qoq9aCpCl30EgIMtCd1JfCxRQ85fYSqGaEhKZiNhrd37GgHBVbh65aT5lNjsKISB
pJCqzCx1zGfC8G1yuCxk+OyNo9ZspaaDKW9ZqSCxKQDHl/iiW0yiYBYg3RU+/1Xs
cQunjxbwBADI1eEBiiHnBilj5wfhnxLNS59ocSkTjCXnGMTuxG4WFlENrU8Szj58
kX/UHr+8VTvTA5e9dsXYabFokxoxNnwR02WyDY7WIRITWe023Itb9zdfeoq8cxrm
JglmaLud2VJ8hLyD/8HqhnA2E/uHnSuMzJaNjdzDIYlXhJwKOg+bli4ybLkDDFnb
QYpnpMxA/IlrMyMvmGUgz3jPErcEs3GRLmKMnqZnz5bGBZ+8JP6IA6srexuJQfcR
BkG20HcqhCYFS2ivMDO6Ps9JLW5JS/p93PWTDkJqVmkgFE1tG85uTGgsP+vBjx5z
1UBLhDV+acgjjZIQOapuNHcB4MdHNEO70pgV79fZg8nT4zuIUWCAW+WFk5wVEbiQ
r2q20TlooZg=
=YdTx
-----END PGP SIGNATURE-----

--=-+K7cNoLCi2IAWvUsMdIv--
