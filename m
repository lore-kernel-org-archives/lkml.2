Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2FKH25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 03:28:57 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:42196 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752582Ab2FKH24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 03:28:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcKACmd1U9bdWOb/2dsb2JhbABFhVemUyKIDYEHghgBAQUjVhALGCoCAlcGiCKlOZF+iyeEV4ESA55BhliCYg
X-IronPort-AV: E=Sophos;i="4.77,387,1336341600"; 
   d="asc'?scan'208";a="925166984"
Message-ID: <1339399757.3963.3.camel@fourier.local.igalia.com>
Subject: Re: [PATCH] Staging: ipack: remove pr_fmt definition.
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Jun 2012 09:29:17 +0200
In-Reply-To: <20120611072500.GT4400@mwanda>
References: <1339397797-17399-1-git-send-email-siglesias@igalia.com>
	 <20120611072500.GT4400@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-c9MSkHQ1AeIW8CYJdUtW"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c9MSkHQ1AeIW8CYJdUtW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-11 at 10:25 +0300, Dan Carpenter wrote:
> On Mon, Jun 11, 2012 at 08:56:36AM +0200, Samuel Iglesias Gonsalvez wrote=
:
> > As there is no pr_* function used here, pr_fmt is not needed.
> >=20
>=20
> Nah.  What about if we decide to add some?  Also there are actually
> a couple pr_err() calls in there already.

Oops, you are right! Forget this patch!

Thanks,

Sam


--=-c9MSkHQ1AeIW8CYJdUtW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAk/Vnk0ACgkQWrfbyfmd9eLWBACgicGmxvm33UuPy7/OfquyzX19
HhMAnjaEq0BLNgVrZY+62laziPGg+VHO
=6HC+
-----END PGP SIGNATURE-----

--=-c9MSkHQ1AeIW8CYJdUtW--

