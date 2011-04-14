Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1DNDua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 23:50:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58706 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab1DNDu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 23:50:29 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Dan Rosenberg <drosenberg@vsecurity.com>, Alex Elder <aelder@sgi.com>,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20110413161044.363600104@clark.kroah.org>
References: <20110413161044.363600104@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-iCS9hWKb7Hn4ZCkJu9nH"
Date: Thu, 14 Apr 2011 04:50:22 +0100
Message-ID: <1302753022.5282.678.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [18/71] xfs: prevent leaking uninitialized
 stack memory in FSGEOMETRY_V1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iCS9hWKb7Hn4ZCkJu9nH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-04-13 at 09:09 -0700, Greg KH wrote:
> 2.6.33-longterm review patch.  If anyone has any objections, please let u=
s know.
>=20
> ------------------
>=20
> From: Dan Rosenberg <drosenberg@vsecurity.com>
>=20
> commit c4d0c3b097f7584772316ee4d64a09fe0e4ddfca upstream.
>=20
> The FSGEOMETRY_V1 ioctl (and its compat equivalent) calls out to
> xfs_fs_geometry() with a version number of 3.  This code path does not
> fill in the logsunit member of the passed xfs_fsop_geom_t, leading to
> the leaking of four bytes of uninitialized stack data to potentially
> unprivileged callers.
[...]

Needs a subsequent fix, like the corresponding bug fix in 2.6.32.37-rc1.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-iCS9hWKb7Hn4ZCkJu9nH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaZu+ee/yOyVhhEJAQqbiBAAmFntZnM7fEQrZkehEc+eRW1FWPYkqEEG
qxudw1PkTcsVwhc8Y4+ryMZYGwF7Mp6B03iVd3eBU/tCTt0M6DDStcT8NQNgzALE
RHHlMlojvWd5LD0TD+Lh1Hw7tUI7CAad1zjzyFsO6B1Ji/pLa5NenAtijVVlzuSO
BTFjzUAxEhs5JKQRoN2hDwTjJGY9CVoIYmsxle3PQlUXjbaLSFXa0nt9b4Sj35M5
2Jlcsa2FCxwWtsiDBN69+5xL8utDR7gJQLWGCj0KDlOQlHQZUT+7FQSw4htAhjtR
ZVe9m5d4pVUcUC0z7SVwmbMQARC/qypQ7cmejSH/u6VfewAwoh5H9sbOsQ3Nj/cs
Li/vEVnxvg+J/nZuJpGtwHq92jN6iSLzhuSOx3hW6k8kak40JapxTfhGtwvwSwJ1
d2LCrT4bVvTCwUqXnq87nrBWvleVa4Qbmgw+ApchAbp5OWB3yIT460wvGLv/iASS
8hAsdJxFVtvSzFJ2e8XFvgvU9XidckvsERMoFIPvNX8DABaHHBGv/Ps81+BMZJP3
iJ0WGLrVKrRhvXVhfFIS9wpGdBSHpCeVqrSJdF5d+4OJD4M4Hxkpv+UDhlcu34GA
KSA4GqLiiEeKQ2MAnA9tiFd6wlngs8Z0pMsIYnfm9nB9bF8ASwjoX0VVL0aYS1ZX
TEOQjjrqL1U=
=V/Sb
-----END PGP SIGNATURE-----

--=-iCS9hWKb7Hn4ZCkJu9nH--
