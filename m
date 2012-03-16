Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422941Ab2CPO7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:59:39 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:41968 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032604Ab2CPO7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:59:35 -0400
Date: Fri, 16 Mar 2012 18:01:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Subject: Re: [PATCH RESEND 1/3] Drivers: hv: Support the newly introduced KVP
 messages in the driver
Message-ID: <20120316150145.GK3163@mwanda>
References: <1331910089-5207-1-git-send-email-kys@microsoft.com>
 <1331910147-5259-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3W6riq+uV6J42Ub"
Content-Disposition: inline
In-Reply-To: <1331910147-5259-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F63554E.0041,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3W6riq+uV6J42Ub
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 16, 2012 at 08:02:25AM -0700, K. Y. Srinivasan wrote:
> Support the newly defined KVP message types. It turns out that the host
> pushes a set of standard key value pairs as soon as the guest opens the K=
VP channel.
> Since we cannot handle these tuples until the user level daemon loads up,=
 defer
> reading the KVP channel until the user level daemon is launched.
>=20
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

Great.  Thanks for doing this.

regards,
dan carpenter


--u3W6riq+uV6J42Ub
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPY1XYAAoJEOnZkXI/YHqR9DYP/2d+ZuJEuNxXeFBqHZIruKNp
Q+RjGbXWqwifTbdoDd/0N2vp3xSAJj9+citaZK59ubeKllvaEvnaGts2nHkqnm8L
QW1bT7Cs93wCVNJLYHT9khYNjiTlPSyzg0RmtC1+h3veqHPxNuOCgXVCMfYt50d6
N9rI2LHi4ri4AgEsk/b586pJhHgkxy58XiSrkkmIz7UDkDQvTU6QfrreR6fSC1FG
Cmb+yfcurC1QDDoJp1nG9wyQafrSet7rGIABfHxayVgMJCv3xSGOImrUcz4YMqCA
9kDLSNVJP8K+8zlBBPd2I1S2JwbMfQ4enVi/QUXeiRuyInfzO39DHKu+wZkoNAG3
GE4Jczzx5ju3bFcmYrc76UMz/DPlh3DjheNi/gKSVFBnH24fqVz8hOIMyoyu6On6
u3FhKJu+IDDh6KMHS6Aj96PQtwKLtcVXHaTqYHD/a04Xf4+Cgi41ROPXbPubuhQE
j5eAq212W1uB5Qp+CiSjnBoY4Q1UE8YMQDgqs99xI2AIY6A/oZ4Ftbiv+ely2DFi
bAfFypZx383nGmQUmLPs2v1f2EVEFzEoF5N8UfWsd0ztexhYyHdtRluKtMoHDgQu
2p2VNCcb/z5xEnJYyI0RZ4pfZyymlC6HtbPN1LfdKbt/FINdyS9XceX3/InSuHe3
QLMSXoCiGtUDvTtlkfWr
=NVdi
-----END PGP SIGNATURE-----

--u3W6riq+uV6J42Ub--
