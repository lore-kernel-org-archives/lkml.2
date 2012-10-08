Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2JHBQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 21:16:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39620 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab2JHBQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 21:16:12 -0400
Message-ID: <1349658957.16173.160.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 174/262] x86, avx: dont use avx instructions with "noxsave"
 boot param
From: Ben Hutchings <ben@decadent.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 08 Oct 2012 02:15:57 +0100
In-Reply-To: <c43c49d3-cf80-49c4-b41e-12db7ce90c24@email.android.com>
References: <20120928182957.993484211@linuxfoundation.org>
	 <20120928183018.599659336@linuxfoundation.org>
	 <1349645172.16173.152.camel@deadeye.wl.decadent.org.uk>
	 <c43c49d3-cf80-49c4-b41e-12db7ce90c24@email.android.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jhFgmOPNwv/4jafDDVY2"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jhFgmOPNwv/4jafDDVY2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-08 at 07:55 +0800, H. Peter Anvin wrote:
> Userland should use a different query mechanism.  On the other hand,
> it will not hurt either.  On pre-xsave kernels AVX is a non-option.
[...]

OK, having looked at what the SDM says I agree that there shouldn't be a
problem for userland.

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-jhFgmOPNwv/4jafDDVY2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHIpTue/yOyVhhEJAQqCLg/+NkP/+SdfIFntbR13d/5ibzEQSq6O7F5A
kFrQ6Kqczk75R5IdFuS9pVNbNkMEtKm3gJvlrBWrYDs3Wab8AX4ZG0jDkp4HvXBz
w/p7c9UYLITmwdVSV42B61N52ZQvwiTNmduxTgWsRTQRySdXI/PiyKq70/aBw0h5
oBJUkirYoQwXnOvdy3X6/mYq+pXU2+2ov79/6XGmdLDEa+vI4NxlJ8/Na5tlUpIJ
uQlazBTDEoCtGjNuun8VZGIiozCCelkIqF9DKwiwV2UzMStQ/zeMFEtmrgvzG2Wz
Xx16Sxh+rpgS+v2EstxqguehU7iHsHlpJKL0XGcW4Zg4KgN4NxFHp/Bzt9XXKeJ5
LzqubE4+NiABADdy2up82cTcp4i5hpiYS7wYLv+6iaW9/HtllJUtptZ5a6Cz5bgU
oDAEfck7RxFjwTXFFsqrj+/Fziwx1PzLXZzmlUIIdFFEfEnvswZWrXzM4//RXOKo
I02xTkGQ3/x3MN8PWo+fFSA4IrfiUkSmLwNPwI2mnSxeGky20wXqWdVXldkdPpMB
7OoBWoNIlOpbJK63XwA2iuyz/TeZq9HLy5qoRCMUjr5Ej184v1O3/91htRC+NtOa
J47+bdy1x6td0pC1hy8pW5BYfwkMAbSZmcNQpVweiEkTp9kec9hgxC2Hd0kTTpLx
CecE0biyZo0=
=4zjD
-----END PGP SIGNATURE-----

--=-jhFgmOPNwv/4jafDDVY2--
