Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab2IQJ3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 05:29:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53803 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab2IQJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 05:29:09 -0400
Date: Mon, 17 Sep 2012 19:29:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: linux-next: manual merge of the arm-soc tree with the char-misc
 tree
Message-Id: <20120917192906.48f46e8743de9924f26c782f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Sep_2012_19_29_06_+1000_0VR02xv/ZmO7Mknq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Sep_2012_19_29_06_+1000_0VR02xv/ZmO7Mknq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/w1/masters/omap_hdq.c between commit 19afea50f12b ("w1: omap-hdq:
convert to devm_* functions") from the char-misc tree and commits
aefaf7be498b ("W1: OMAP HDQ1W: Remove dependencies to mach/hardware.h")
and 73f2989d37a3 ("w1: omap-hdq: drop ARCH dependency") from the arm-soc
tree.

The former patches removed some of the code fixed up by the latter and
the same include line, so I did that and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__17_Sep_2012_19_29_06_+1000_0VR02xv/ZmO7Mknq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQVu1iAAoJEECxmPOUX5FEMJsP/i5hLiEIfMkHoqMNqXqltloz
7bT7BmwbLP7l/1zJ7hZ7hoETqdU/Xsnq2TYhdmRg+ZsMF1Y9/KWw7h4gtkEMFDlY
2Sbb9NUjozpOkUqFT0Nh7TpibrFAmxVBVctwqgxcnzft99iNhw2FmoVWfRo2kqEy
jcAv3DJRYQUYBoejPOk2QqwpNvS7/9sqE5urpVxSPEUifbMIISRBbsjmrBmalEhp
MqXUBJdlfYIGXr9PNiq6VMOQ85s51YShB9T2Hx9CKCYoqMNQbXCUUZY669cETwL2
ohBiSYAeYABteWRd18yLyIzp4EaIrkl020IVjjKsKy7RmNirUXC99ldBGNTOeKZA
Xi/43Z6fmdsPaY5LjAbtLTTQx/B7yAM7896gU8RQf4XOlRN4lHeFSeGFjPXj4CuJ
cc6jdyLc91ztuSJJ1v7Az3qRrhmNipmHgqY2iudUF89AnHlVJWGXOu75fOSlEvjo
X54y9DnGdlPehglRY+Kzvhg5f3/X3r7WoxSFtzEcor2enaape5y9OIf+bhpJ5gp2
pLhZncGIxyVXLLeq8dD2iV7WubjvoxwgDPnpYAxTon27mnzK48lhmW2S7m6CCZKo
/Lnveqw1X7Q42eHQ6bea2SaFllg80t7fxf5oDwDDB+9mjkdIPYVWoLV7ymC1XxBX
MFPvyX4m3tpOlIC+pvxU
=ZMi6
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Sep_2012_19_29_06_+1000_0VR02xv/ZmO7Mknq--
