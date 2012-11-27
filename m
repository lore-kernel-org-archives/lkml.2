Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab2K0Cdj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:33:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755961Ab2K0Cdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:33:37 -0500
Message-ID: <1353983604.4266.44.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 041/270] pnfsblock: fix partial page buffer wirte
From: Ben Hutchings <ben@decadent.org.uk>
To: Peng Tao <tao.peng@emc.com>, Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 27 Nov 2012 02:33:24 +0000
In-Reply-To: <1353949160-26803-42-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-42-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-SBJZwEfJiLHRPunr31uk"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SBJZwEfJiLHRPunr31uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-11-26 at 14:55 -0200, Herton Ronaldo Krzesinski wrote:
> 3.5.7u1 -stable review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>=20
> From: Peng Tao <bergwolf@gmail.com>
>=20
> commit fe6e1e8d9fad86873eb74a26e80a8f91f9e870b5 upstream.
>=20
> If applications use flock to protect its write range, generic NFS
> will not do read-modify-write cycle at page cache level. Therefore
> LD should know how to handle non-sector aligned writes. Otherwise
> there will be data corruption.
>=20
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

I notice that this fix is missing from 3.4, and will need backporting.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-SBJZwEfJiLHRPunr31uk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULQmdOe/yOyVhhEJAQrf3w/+I0chqXoO2/Xo3mZtZkxceQjlUs1oh8ZH
f3Xvn5WWlIzNfMo6xwAJ+2ZLteaUC2QmZXxhejlcn1aCFF6AU13zOW1gQ0F+wf4d
i7Tb6arKVRszN4zFp6VvyhKIL94V2LhIuZLgCFR+M0TVp9llHYawI4pNuuFquKoN
2mkv2a/c9zkMcke0DWQh5tvOEXR1kZX6EYhnuJBAurDmjPyEf/9THDenS3D2qpKy
nv6ziGIejXBoAmoqvbJJtGafZbf4xs4az1Ufa98+ZUc5EhkndYlaeBfVSJyoCPZ4
9x8UP5OhTSkknYR326ZQx44WPTNZCXhpY7+tD/NNEU9xAe2RjoA/vxY+06hrr/1G
lEq2goC7+886e05LP97cjhk9jfgeIzmr4iGqbX3FDzpJvzt+/eTLXFMwSf0Z2P5T
llI8pr9Z7Hdm5fA7ZgKAOTv9IGxsqqV3focOxDXaK6LEXgEYnWjnJsSHeuPmdfgJ
6ciGnd5Nm9ltY35HwtHsZFOfLYr+NxuNT7BLCmfixTT8yhtRVHRQdMAo1JM9l110
H56eL+f/QVTtJn00vVCDy/U7mLQkhCrgxsu2aCbkChccFAIs6lwy6KHqGmEfS5Jh
BSCA6Oq99yAXD4wDmpfu1PHS+viWjqoyvkfmfV4LnJFdoJ3kFIZlHIjFFMs0ovhK
pqHyZ4j0saA=
=eCiL
-----END PGP SIGNATURE-----

--=-SBJZwEfJiLHRPunr31uk--
