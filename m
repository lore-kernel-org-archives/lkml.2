Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2LDOQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:16:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:5961 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab2LDOQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:16:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,215,1355126400"; 
   d="asc'?scan'208";a="251734252"
Message-ID: <1354630632.11583.69.camel@sauron.fi.intel.com>
Subject: [GIT PULL] UBI changes for 3.7-rc9
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 04 Dec 2012 16:17:12 +0200
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AeJv+JTfkZFt4aCDizHl"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AeJv+JTfkZFt4aCDizHl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

it is nice that you decided to postpone 3.8, because we found a couple
of bad bugs in UBI. Please, pull the fixes.

The following changes since commit 9489e9dcae718d5fde988e4a684a0f55b5f94d17=
:

  Linux 3.7-rc7 (2012-11-25 17:59:19 -0800)

are available in the git repository at:

  git://git.infradead.org/linux-ubi.git tags/upstream-3.7-rc9

for you to fetch changes up to 894aef215775b56b725e9dde856b7a8b091ddfcc:

  UBI: dont call ubi_self_check_all_ff() in __wl_get_peb() (2012-12-04 16:0=
4:31 +0200)

----------------------------------------------------------------
Fixes for 2 brown-paperbag bugs introduced this merge window by the fastmap
code:

1. The UBI background thread got stuck when a bit-flip happened because fre=
e
   LEBs was not removed from the "free" tree when we started using it.
2. I/O debugging checks did not work because we called a sleeping function =
in
   atomic context.

----------------------------------------------------------------
Richard Weinberger (2):
      UBI: remove PEB from free tree in get_peb_for_wl()
      UBI: dont call ubi_self_check_all_ff() in __wl_get_peb()

 drivers/mtd/ubi/wl.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--=20
Best Regards,
Artem Bityutskiy

--=-AeJv+JTfkZFt4aCDizHl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQvgXoAAoJECmIfjd9wqK0F98QAI1m4cDDVTk80frIGvFmln86
O1pTQIRSx5QbWG7+A8/GSUOM4sS3478mTr5OTXg3DgOW2+bHuBngpEpdkqlgBHvY
E5v1Nve/M2H5Td/2r9EhakJlfK5xFzNNsc/blKC7UlMyk/L0b3vDXvRop5ytfTws
l5wTR6njYLOJ6Aj6oIwFCpvbJANN7ZtdHJCH6wqp1ret905U1ha4ku5FZLzcYVdU
4Sba8xtMhLD3UMXWLitpqin6cBq8FgcJmHUwaLFjr9riQTLpUjcIWdltpO6/tAKS
chgCznsC5XTDH6NzJG6OoERIaopRFeB5Q6ZKg+TvL/qiXducq7SX/3as05b4VJ8J
5NwxRWXbn+oQilTUGFNJcpNN5csJQqeG6p15ianM1/m9qw3ho1NGZQth2iHiaCs+
zHgfzb/dGVzKK/hUVzCOxUduKjqZA5stHL8fuPFNF5gQkZU5hEsoffTcvVbhMK3H
3d77BjT80Y1P09qR7SudOK823O59p+I1/sSqGrQt/Wem/IhaN4NbbAUF62QBrQdw
taUwgWjsVAhwbEpyGaUigMrwRLTQmM4yGmvUe8ZLY3juH+mBtYg03pU97pkwrs/d
v0PCga7utzyf5HjFnjTHUY4CEfnNqx+hx3VW0P9LY43OMdiW7F+u/fz9vlndYJAF
Fv3cpr/gcQCHkYZW9R4m
=Y6Ci
-----END PGP SIGNATURE-----

--=-AeJv+JTfkZFt4aCDizHl--

