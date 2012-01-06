Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269Ab2AFKcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 05:32:05 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:39308 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620Ab2AFKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 05:32:00 -0500
Date: Fri, 6 Jan 2012 21:31:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Govindraj.R" <govindraj.raja@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120106213142.bef2d9b63e09eb42234e2b01@canb.auug.org.au>
In-Reply-To: <20120106084841.GJ11810@n2100.arm.linux.org.uk>
References: <20120106120317.500c45afe95ae20b4b6648a0@canb.auug.org.au>
	<20120106084841.GJ11810@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jan_2012_21_31_42_+1100_s/496P=ZLwgEgBKj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jan_2012_21_31_42_+1100_s/496P=ZLwgEgBKj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Fri, 6 Jan 2012 08:48:41 +0000 Russell King - ARM Linux <linux@arm.linux=
.org.uk> wrote:
>
> On Fri, Jan 06, 2012 at 12:03:17PM +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-omap2/pm34xx.c between commit e6ab10af962d ("ARM: OMAP:
> > convert idle handlers from pm_idle to arm_pm_idle") from the arm tree a=
nd
> > commit 2fd149645eb4 ("") from the arm-soc tree.
>=20
> Err, there's an empty description of a commit in the arm-soc tree?

Sorry about that:

ARM: OMAP2+: UART: Remove omap_uart_can_sleep and add pm_qos

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jan_2012_21_31_42_+1100_s/496P=ZLwgEgBKj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPBs2OAAoJEECxmPOUX5FE7xsP/i6eYoHRxkVdg7srlSEKLn1A
SznD9rAI+g32+6hSfDQ9YHH5Eh3aNK14ofPQ0B1D86tpPAH0GMLCi9kl/PUHt3h9
LZo1HRGfdvYSqB4vQA/xW2jHf/kzL8MQAElexaOm9HEWbDa6HItVyb2jjja29/G/
Pg92hGt7MbpN8K2pMcLmvXDTyNY9GVGInU++eFU7IEW6aEz0fOkzWuy1hSxKEWUj
zCvkNjDQQpujpva4oTuId53WIaO2pLGvzMHVW0wNW1HJWIkWVrCDxkQtTFrwH791
yuDyvXgbyxGFyb+iDW+74G3saS9koGhWCHsINd/AYqby6kRx0LcMALj+NRu2BVn0
dfLYlE1rMGbJIox8wQBohnGKgYda12uK8sOvGmuD/guaQtxAjdLTB4ePAUNMu5lJ
KRtDAvTxm5uKbBLjNprlAxY76rIGlG6qgVD1UnbyqHRn/jU7j/jdfCp/XOiHKFP5
7d6bP2F+GDL4tAfKNVN7fZOoh6DEOIUeLlqB1oKX9NpaRSRwm0o+4vwYvQb06ji9
8Kp+GOZB6K2x7ifW13Yz5uhXqAA0aPUbyHb8itlmmaC154HXHe6oPVbcSWWHTVdW
9l3zeLZ91wg6PVrr7Ir2tzvH5gkvdiN0tSwMiCDzkgewGikpVBOaKS2C2XPNZcUe
du/UwPUeS83dKgzA28iO
=/GKA
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jan_2012_21_31_42_+1100_s/496P=ZLwgEgBKj--
