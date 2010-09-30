Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab0I3BXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 21:23:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47381 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab0I3BXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 21:23:11 -0400
Date: Thu, 30 Sep 2010 11:23:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the sound-asoc tree with the i.MX tree
Message-Id: <20100930112302.e554d367.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__30_Sep_2010_11_23_02_+1000_PB_a5ruTPe4/g6f5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__30_Sep_2010_11_23_02_+1000_PB_a5ruTPe4/g6f5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/mach-mx3/devices.c between commit
4697bb926f43b8012ebd111ef43834f42126a0ef ("ARM: imx: dynamically allocate
imx-ssi devices") from the i.MX tree and commit
f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC: multi-component - ASoC
Multi-Component Support") from the sound-asoc tree.

The former removed that code that the latter changed.  I just used the
former.

The latter was just changing some names, so ti may be able to be
integrated into the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__30_Sep_2010_11_23_02_+1000_PB_a5ruTPe4/g6f5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMo+Z2AAoJEDMEi1NhKgbsy84IAJxrXoSaS1cfgSObHCrvxieY
zQDNdTJHyNPel97eLAGxmYE/rpabs5KVjCE4vSd7JKg0XPPRv4/j3NP/QHTNOLvs
GuSLZOodZmK/zDT4vEMPsDdbeCK1zLqjkoLJfoWdOEIAF/ooNuTHZjpnMJ7CF6Uk
c8ZJtF52AzX0dlUoAZ8WjHWQa+/0iw4BvlojYHobkHl18pzyrfXxIfN5i+K3coFD
AX3diSQhSEvGYfqKMaOF8CZPF+IK8Zs3fkdXA9uslJK7vHrBwV1dkQUDwKsJ98Ni
Cx5OKn/3IahexuXKw11OstyLfyLxMso95ZQEfLRr7QLAmOPBBTBRU16myJZdW+8=
=ey/3
-----END PGP SIGNATURE-----

--Signature=_Thu__30_Sep_2010_11_23_02_+1000_PB_a5ruTPe4/g6f5--
