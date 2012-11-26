Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2KZFWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 00:22:43 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39303 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2KZFWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 00:22:42 -0500
Date: Mon, 26 Nov 2012 16:22:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: linux-next: manual merge of the omap_dss2 tree with Linus' tree
Message-Id: <20121126162233.9e7d7a036f2cc4a168cd3b6c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_16_22_33_+1100_eqs3J0fDyMoJRtLG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_16_22_33_+1100_eqs3J0fDyMoJRtLG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
drivers/video/omap2/dss/dss.c between commit f65e384bec59 ("omapdss: dss:
Fix clocks on OMAP363x") from Linus' tree and commit bd81ed081887
("OMAPDSS: DSS: use omapdss_version") from the omap_dss2 tree.

I fixed it up (using the omap_dss2 tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Nov_2012_16_22_33_+1100_eqs3J0fDyMoJRtLG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsvyZAAoJEECxmPOUX5FEuhMP/2c1gi+KEMauXXoW3wEehttF
K8ztW4qWlxneN0vOwfLt6QhWTKEZoqfRo1J33j47764x4LHHgnPuTTCLL5RFleP9
cbVRXKX1OA4Ik6zHNL1+k23lG+k8EtUYdz1jDPl+B9iudHhW+hISd3/9DjEk1lR0
XL+JIFe70EtcLlZK3Vm9hr+zZuQ03g0G28x6jNq45DHQbaX8Xn47aUXhC8vIJm2k
fte4nhkoNqDFEBmZ2E268WQT7jfrpK4TmulZxyUYKxCuSOwe5zGFnioQo2hPkXKH
fVE58bOmSZBDZqlSN1x1DRpH11RsdsvTB9+gpOYFRw9MFGwFNVqGfTGMDDICvxud
yM3LuISN0eNO7s1CK+SOOzUS/CoGtsxhRbdgk4cNiuJrJhQ/0H1fPJrmvS1qJYHz
xTpmSpk8ywicDqn53mVpcChw9RmrJocwRrRveZA3Ya6O/3oYjMjjKY242dXtZcdb
oNFmn0MtBHcZdmQ0JZerAi8mJounefeMWVviU72134TsYZMXd/Cog9RnbMBXORBy
IaeWTC1EJ6FhP5ahmD31GiigkAZH+jgJLfpAoo2iz1y42ka3YjSTfZE50I15s3w8
lS3qwQmZh+zIqrKvY+Qpl/aLYnXBulXUpbknusaEjxYpQl8YccbzZXIelU5QC6JI
RQRUGK5QiQwVVWCwqSU2
=Rwks
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_16_22_33_+1100_eqs3J0fDyMoJRtLG--
