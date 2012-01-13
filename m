Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758033Ab2AMMMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 07:12:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:63581 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2AMMMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 07:12:39 -0500
Content-Type: multipart/mixed; boundary="===============1977854356=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="95475564"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PULL REQUEST] More UBI/UBIFS changes for 3.3
Thread-Topic: [PULL REQUEST] More UBI/UBIFS changes for 3.3
Thread-Index: AQHM0eyLmjDHXfaxFESuzsVG9vPDdw==
Date: Fri, 13 Jan 2012 12:11:57 +0000
Message-ID: <1326456812.18165.0.camel@sauron.fi.intel.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.160]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1977854356==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-bKr6ZVI3l4XOSW23UXVA"

--=-bKr6ZVI3l4XOSW23UXVA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

please pull more UBI/UBIFS changes for 3.3, thanks!

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610=
:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.infradead.org/ubifs-2.6.git linux-next

Artem Bityutskiy (5):
      UBI: fix debugging messages
      UBIFS: make debugging messages light again
      UBIFS: fix debugging messages
      UBIFS: use snprintf instead of sprintf when printing keys
      UBIFS: fix key printing

Richard Weinberger (1):
      UBI: make vid_hdr non-static

 drivers/mtd/ubi/debug.h |    5 ++-
 drivers/mtd/ubi/vtbl.c  |    2 +-
 fs/ubifs/debug.c        |   90 ++++++++++++++++++++++++-------------------=
----
 fs/ubifs/debug.h        |   44 +++++++++++++----------
 fs/ubifs/journal.c      |    7 ++--
 fs/ubifs/replay.c       |    8 ++--
 fs/ubifs/tnc.c          |   55 ++++++++++++++--------------
 fs/ubifs/tnc_misc.c     |   10 +++---
 8 files changed, 115 insertions(+), 106 deletions(-)

--=20
Best Regards,
Artem Bityutskiy


--=-bKr6ZVI3l4XOSW23UXVA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPEB/sAAoJECmIfjd9wqK0tnQP/i7C/WjlU9Qxelx2C+uKdodM
vY9HASc/gOXXMxl/bSoKxTSNT2580uKGUB3G6q0UXVVVhyoRU60RhDM+AgzOUv+5
EKMeHVlLPt6ejVZNmDuWxB4msc5b4sw49ND6Ejc+6rKNDE+s7UhZK+BEG85GjAJv
jLLYvio9J9foIJ/y9dBGEz3PbyJvKSCICkv10/Cci5bcG4joT0kNnnphsh5iD0My
A+1xjrE4XgXGaGOHDP/gKgDhPgU/JHFR1cPdMCr7PM5b0Cm3/B07j2rFwOaa+9U0
NdPE5R0K1asPcqOxosxDaN3MrYFUM527TiNgxmLcW+fzlrRYjKKZ34Pu34IGfhi0
gKP334Pbnd6s606KjQIHGl8Yh4ELofEr0kuvQXmN+qyz+AMO4WrcG5mqEn2CPlrj
53xyxbfcxz094Lf5V6hpz5JWmUChYoP2wWvVrLWIHG+jtFJct/GRacHM3sTh32pc
qJA1YcREBiVkoUkFS7pPPH37VwjLpZconi6ThpT0aIysX9tkpH4F+aiC+dzWgsXQ
CMFc9vg1h48S+3HAnP9d3bH2iif8VHJe3YpqucJWfi0UkoMz6D92DUt9kpxRADR7
e7WU/OVoow8eQ6ch95QHjZ6/qpgXW+xGDmUukbhfdlHcqgaXuONpr2ePXayeAazQ
LidqYWhCnSvuASgj7HVo
=ZR0Y
-----END PGP SIGNATURE-----

--=-bKr6ZVI3l4XOSW23UXVA--
--===============1977854356==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki =

Business Identity Code: 0357606 - 4 =

Domiciled in Helsinki =


This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============1977854356==--
