Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2K0Cez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 21:34:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38528 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757873Ab2K0Cey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 21:34:54 -0500
Message-ID: <1353983688.4266.45.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 042/270] pnfsblock: fix non-aligned DIO read
From: Ben Hutchings <ben@decadent.org.uk>
To: Peng Tao <tao.peng@emc.com>, Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Tue, 27 Nov 2012 02:34:48 +0000
In-Reply-To: <1353949160-26803-43-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
	 <1353949160-26803-43-git-send-email-herton.krzesinski@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-6Q2U/iA8EoUDgC34g+Rl"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6Q2U/iA8EoUDgC34g+Rl
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
> commit f742dc4a32587bff50b13dde9d8894b96851951a upstream.
>=20
> For DIO read, if it is not sector aligned, we should reject it
> and resend via MDS. Otherwise there might be data corruption.
> Also teach bl_read_pagelist to handle partial page reads for DIO.
>=20
> Signed-off-by: Peng Tao <tao.peng@emc.com>
> Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com=
>
[...]

This also hasn't been applied to 3.4, and presumably needs backporting.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-6Q2U/iA8EoUDgC34g+Rl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAULQmyOe/yOyVhhEJAQoq3Q/+OPm94tK1gOHVoCFCR382eAwiwfAb0IgL
gaVJtuRbRKq65ZCpzueF8vSbZlZ7e8yD5ESF0EP37KTOZbfgGsJqRgw/h3Lk8NZv
X7KurnAo1NpnBxCScp9Nl5+VXfSIRJuQehtq7ZFJwV0O+BuCn6/vLumXLiVO3JXG
gQuwpUS6dbtR+rD3AHP9rpEx7Ml9Q97zbbA0LNvmP+moihB9r7IrwfShIcYeAvPW
78ANN9vZNZp5az7PX+q6IdnidbpewgQT7BM2IA7ZS3SRfrmrynmyyXKJ9uiK3IDC
mnSOXvwJzF8mP5oB6UKRTQfs25yX/8z2UmmDmDKMHA3KMJE239jNi4bTO75Heurl
3jk2tWnOo8+rVB+AuhBPFzMz4uhun9xPuuBP9T5sCUB6TRnbC+L6lbtXT+lRF/XE
46/0sVi+PFZLlxzlW/xuBV0rlO+Vn5v1LghB7B9tCCY6iktLramuS/YPGF41WUA+
k2j0ERmSfwRetmuLzUc8P4rfPITmdTTcEoiXsbkhoOL58hUgzX5kcsV2xexFBpSZ
Wjq4bTe1eGQbHHxCdcMHkzL5BMuxAq4+eksKl5fhOdLTtt5oHcTp7BH3hmdvKbqI
jXhFrYVW5mbGPU9gtW58cbLphWjqblKKWssF93od3scMnFY5JJpOkaeNSx1GFYZw
VJil6W2Te/4=
=C01D
-----END PGP SIGNATURE-----

--=-6Q2U/iA8EoUDgC34g+Rl--
