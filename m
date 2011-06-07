Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1FGK1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 06:27:46 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45498 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750880Ab1FGK1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 06:27:45 -0400
Date: Tue, 7 Jun 2011 13:27:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] musb_host: compare status for negative error values
Message-ID: <20110607102739.GS12242@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4DE3E5D6.207@freemail.hu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0blaZc+aUkVqY8MO"
Content-Disposition: inline
In-Reply-To: <4DE3E5D6.207@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0blaZc+aUkVqY8MO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2011 at 08:45:42PM +0200, N=E9meth M=E1rton wrote:
> From: M=E1rton N=E9meth <nm127@freemail.hu>
>=20
> Variable d is a struct usb_iso_packet_descriptor. The status filed is usu=
ally
> negative when an error happens.
>=20
> Signed-off-by: M=E1rton N=E9meth <nm127@freemail.hu>

applied to fixes branch. Thanks

--=20
balbi

--0blaZc+aUkVqY8MO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7f0bAAoJEAv8Txj19kN1bacH/1/9e6DJhM92gQX8z52p6vWI
7hSjxET0YuSHRwwF3nTdEmXq9xnJrDxwESaRm0cm1NizOZperGYgripdePIbexg9
5RH2kRwx8tCDUpoBPy0smthUvscfesGjFk/2E6maDnbmdw/evdy3cuJ9Apf+G43f
xBoPW1n2nwLAS4eQj1IiklZtpJhh3TWVKrHw2PqkWsHzJkneKqZOmcLE0YbWWeZo
oyi0i2MHLfLHrMaeHqebXXUz+4g/2HPEQ4r5zyi+DJ45SENDjfCdtdbcxcbZMIA/
b3c+kcfh7sjr8CIBfJxxK9riYznWs7Va60uqHrl0XHDf1clAYXbCzeLqurMevtI=
=cblj
-----END PGP SIGNATURE-----

--0blaZc+aUkVqY8MO--
