Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab2IXJxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:53:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51326 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2IXJxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:53:07 -0400
Date: Mon, 24 Sep 2012 19:53:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the omap_dss2
 tree
Message-Id: <20120924195305.588277e94ce701abc5e5a6c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_53_05_+1000_qdcee7p872KGdeqd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_53_05_+1000_qdcee7p872KGdeqd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/video/omap/lcd_ams_delta.c between commit 9586778de558 ("OMAPFB1:
remove unnecessary includes") from the  tree and commit e27e35ec735f
("ARM: OMAP1: Move board-ams-delta.h from plat to mach") from the arm-soc
tree.

The latter removed a superset of the former (as far as include files is
concerned), so I used that and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_19_53_05_+1000_qdcee7p872KGdeqd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYC2BAAoJEECxmPOUX5FEbn0P/3r/XdhCbFTylhN8LHCTt/gn
uGHYGYT7wY5+I/O6YSm1QA0cawdXz4Q92XE3uYPithGzyCmvkwKmTj/sOrwAB/Ec
sBRFaZXjDDJi0vJw1MkodPh0DXuXvuzH6RXLkr+Y1NxdAAn8u8YdRkAwYkv2Q9dE
XqEktgAmep7ZB01qvWSnqt2pm73q1xDeHG+9Kg0Ttw6T57JHBPzkJYr1novxkX87
WT5JYQYI1Rc/DZ8pp+xcxLl+14RIQ7MsG/mTFEr3sXZVvnWAP9VSdsb42Ur8X0l0
fyMN3QG0luNq7yK733huIpBD2eX963LKRAtvhIhKP8qKFCG4loWheCpdd6JWP3kg
3c255xQZBykGdOHnlPe1USe++Zgumrfnqwf2lsT0FXDBLZ3V63UZNA6MqYLA0pi/
B7FBiQQL9DtA5GRoYMd2AEvXpCUNTNXEBxpJ+FMfJAVCzxODRN+jPPqhgli7n89n
CIb2coAP9FwUkWwfocgbBuVKN9qolgO3JpaHftsnlLFK3YWI3WEf+TZHPePnG3Wo
U8XsYySC/YC5Fpqs9Jy/sXgLIkhbfi5ceEDQ5EMKy1Ej2e1GfOzlsiL4bSXjZOYs
ZEqwkUfY0SS/iVyFDFWMsqgQkxemW9trpclncw8SRN42iq0AI2hLoK0wHf2CwNCK
3kR8DBjwbtg08hVhJVfj
=+53r
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_53_05_+1000_qdcee7p872KGdeqd--
