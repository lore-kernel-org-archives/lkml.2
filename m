Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab1IIBoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:44:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:45535 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1IIBop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:44:45 -0400
Date: Fri, 9 Sep 2011 11:44:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        "Arnaud Patard (Rtp)" <arnaud.patard@rtp-net.org>
Subject: linux-next: manual merge of the i.MX tree with the arm-soc tree
Message-Id: <20110909114436.5afc4ef772143d90ce75c7c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Sep_2011_11_44_36_+1000_DhYed6U+aX4oH3N="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Sep_2011_11_44_36_+1000_DhYed6U+aX4oH3N=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sascha,

Today's linux-next merge of the i.MX tree got a conflict in
arch/arm/plat-mxc/devices/platform-pata_imx.c between commit 236c4e8be436
("ARM: imx: Add PATA resources for other i.MX processors") from the
arm-soc tree and commit 8354b5d2a1c5 ("ARM: imx: Add PATA resources for
other i.MX processors") from the i.MX tree.

The latter appears to be a corrected version of the former (despite
having the same Author date ...) so I used that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Sep_2011_11_44_36_+1000_DhYed6U+aX4oH3N=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOaW+EAAoJEDMEi1NhKgbsFTMH/RLwbLdB1ywDtiLY+eSZplur
s89JDoiTEGAdwWsmSAcb+TqcU05vaUCmmDwENf72G6S7KoeG8g7Eb1x/sUmeLtKE
X2yzEIade6m5KCpibUnaU3gUxtVbIcX5CgxxKoTvqa2O3YGYTghzB76yuz1pcrXa
2GGhFJjzEavP3LnkNgG3YnIE+uYjS7Al+FGdH699K5obJhmLr41CiadNHLo6TEmb
VpWyrStM6ZGxdOA6zsx8VKL/YbyCVh0NpIQNXzeI7ArMv8KRtA+9OVG0B1jzk0ep
Tud/G+8zcg7kkZSyP0VRVt/HiBYqxuvB3H1bvNVmy2TPV/QWV1Y03xzp3BEq3qA=
=cKDF
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Sep_2011_11_44_36_+1000_DhYed6U+aX4oH3N=--
