Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab2AZQf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:35:56 -0500
Received: from pyr75-3-78-192-68-46.fbxo.proxad.net ([78.192.68.46]:43362 "EHLO
	molly.corsac.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab2AZQfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:35:55 -0500
Message-ID: <1327595767.2062.7.camel@scapa>
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
From: Yves-Alexis Perez <corsac@debian.org>
To: balbi@ti.com
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-usb@vger.kernel.org
Date: Thu, 26 Jan 2012 17:36:07 +0100
In-Reply-To: <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
References: <1327587732.2296.25.camel@scapa>
	 <20120126161539.GA2098@kroah.com>
	 <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-2TVWU/bDsrqAfEYOgoN8"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2TVWU/bDsrqAfEYOgoN8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On jeu., 2012-01-26 at 18:31 +0200, Felipe Balbi wrote:
> > Very odd, it wouldn't seem that this patch would cause such a problem,
> > as it is "obviously" correct.
>=20
> The funny thing is that I don't think there's any x86 system out there
> with this *DRD* controller :-)=20

Out of curiosity, what is a DRD controler?

> Specially when you consider the fact that
> it's very recently that we dropped the ARCH dependency with commit
> d242c110c43b55aaf3ebb3ceac1eeab0d452a177
>=20
> > Kuninori, any thoughts about this?  Should I revert this from the
> > tree?
>=20
> I don't think so, I think this was a bad bisection.
>=20
Maybe (especially since the first bad commit is a merge commit, so I'm
not completely sure I did correctly the second bisect). But I'm puzzled
why reverting the commit on top of 3.2.1 fixes that. And now that Felipe
mentions it, USB Gadget is not even compiled, so I'm completely lost.
--=20
Yves-Alexis

--=-2TVWU/bDsrqAfEYOgoN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPIYD3AAoJEDBVD3hx7wuoTF8QAKtSkFYJ5lnqfAKRlu8pvMPw
FP605BCXc4hsElm2H7RmcUd1iPaitOcrMP0OMF4CVf1FnLqYItAUhBxXGkgJ6yrg
d90ro5fEcgOSsgYNQIXRck/wb2PwP77CvGwshL95xl3NiZgAE9GgUP1Pqmu/vNVM
mCGjQhZB8g0r/4TXjEkW5jYQ7BLHZhLi744hS+zqabLmTb0/Z2pZ7H1H9A2Fdr2X
XfhWj/CZjiretwPH48CcjUvegGUhOCLlOHM8B3Dtj1423RM34iOKJgG0pXjfvFiM
IiaO0WTaRdKZ06xsCW7Cb7IeWkmBjDuPLdxPcn1rR9bZSM6fDujdNVwEgtbmzny4
46Ae0hgavc0i64gICJZzVJ7ugsaBBsX6/S5brlrX0hR+OQp+zuTa6gdVqVG7kl5h
pfp0NQVGgFti7uITFrfhD+qbfWhvavTRJvjdg8qlRVdnZdYHn+Ut47lguQoAb9Dn
JVuqlWYSNdkJlM4/+FCLH1S5G2rJ7QZFk2PKRkqy64susKPVT20/kSUoEYxfnj3m
YB1LjcoZ54cWSEOK21ApFUFBXJT3fvH41bypS7j5v72DozFFFaqhNN3EMruWV+JS
iQQNB4OlldgjewAXZxxCmdCpS5xj9vVwGwxQ83MnoNkueXcPgZK6nTjNi7WU7kde
ZiTLVoNEJ+uAuV0yjWt+
=oD2s
-----END PGP SIGNATURE-----

--=-2TVWU/bDsrqAfEYOgoN8--
