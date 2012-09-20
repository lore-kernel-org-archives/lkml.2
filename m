Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab2ITGGl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:06:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53263 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2ITGGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:06:40 -0400
Date: Thu, 20 Sep 2012 16:06:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20120920160637.7f9065225982468c25fa1952@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Sep_2012_16_06_37_+1000_He47OKBIxQ2LnUqG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Sep_2012_16_06_37_+1000_He47OKBIxQ2LnUqG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
sound/soc/omap/igep0020.c, sound/soc/omap/omap3beagle.c,
sound/soc/omap/omap3evm.c and sound/soc/omap/overo.c between commit
152c6e56f6a8 ("ASoC: Remove obsolete OMAP3 machine drivers") from the
sound-asoc tree and commit 2203747c9771 ("ARM: omap: move platform_data
definitions") from the arm-soc tree.

The former removed the files, so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Sep_2012_16_06_37_+1000_He47OKBIxQ2LnUqG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWrJtAAoJEECxmPOUX5FEYXQP/Ah872dKM23CMBJQrAwjFQoY
eA7nPisC5XbbogWd1ZrZT6FicirYCilM5lrb5wEb3X6zGTsH6owUYT6X+XrAkYi+
K9A+hN6uuiB8bpaK9cSu5Ic6z7HTi6PQvCIkNDZmsOx2Y3L5KdfK695sz4Ul+PHb
LzUb/Jsj9kmRBZJzfJoZnCN2yjnvSha+4FuutjewDLlcsBGV/9wPnMoPPg1L95MP
JhXSikeFfYMRHK+vtupkZgezqSlp4d1U1hu0nawF0clBGes85BVW6Glxj9Sl/dG7
tVVNZUsWRwOHMWj8YDeUwvr5pGjSCdg4KhwhqNLS7tdkin/jJrDTBz1uF/LMT0/i
kDFb4V2Qut1XinlV2Bl63EL6HFcTkMsCdULuDSNH8Te8Gb/J/EHJwj+OxIQU5Mt/
B1NOA86FACFkEmGaSXFzxQc0tHiIPqCIq3m+YblHMGU4jEyZKe/ewcBMBYlyaoYJ
tbjt+mYteCcUM8FbuoDr8wanSMk3Z3Ixpf/e70mmMbrSxNQ07YAEFnyNysJykMws
JnRZeHcXhq+nrJhfLidzoYQP3UOPsRPrD4CSoiaIr2YYwcnHKA+tMIs3d8ccCMjj
s8OUbUBJVN5SnZJ9zalK7dhRtslCZ/UStdlbuhW6KsZ5Wx9w76GtxAHjfxbL9WM4
DuDZo0n0ugoLjSB+BIk9
=ZZu2
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Sep_2012_16_06_37_+1000_He47OKBIxQ2LnUqG--
