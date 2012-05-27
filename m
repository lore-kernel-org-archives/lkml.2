Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab2E0Ne7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 09:34:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46366 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab2E0Nez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 09:34:55 -0400
Message-ID: <1338125678.20487.69.camel@deadeye>
Subject: Re: [ 05/91] iwlwifi: use 6000G2B for 6030 device series
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 27 May 2012 14:34:38 +0100
In-Reply-To: <20120527002508.028566430@linuxfoundation.org>
References: <20120527002508.028566430@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ubWElQ5xwXyiZPmTLERF"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ubWElQ5xwXyiZPmTLERF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-27 at 09:25 +0900, Greg KH wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5 upstream.
>=20
> "iwlwifi: use correct released ucode version" change
> the ucode api ok from 6000G2 to 6000G2B, but it shall belong
> to 6030 device series, not the 6005 device series. Fix it

The relevant changes are:

(a)
commit e377a4fc768d7d477e58888bdbddd0103d6238bf
Author: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Date:   Sun Apr 22 07:55:27 2012 -0700

    iwlwifi: use correct released ucode version

- changed IWL_DEVICE_6005 to use IWL6000G2B_UCODE_API_OK
- upstream in this merge window; not cc'd to stable; redundant with next ch=
ange

(b)
commit 78cbcf2b9dbe0565820dc7721316f9c401000a68
Author: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Date:   Sun Apr 22 07:55:27 2012 -0700

    iwlwifi: use correct released ucode version

- changed IWL_DEVICE_6005 to use IWL6000G2B_UCODE_API_OK (among many other =
changes)
- upstream in 3.4; cc'd to stable; applied in 3.2.17 and 3.3.5

(c)
commit 35e7adaaf6932c5ffb22c6ec521734434c65adc5
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Wed Apr 25 08:10:08 2012 -0700

    iwlwifi: use 6000G2B for 6030 device series

- changed IWL_DEVICE_6005 back to IWL6000G2_UCODE_API_OK
- upstream in this merge window; cc'd to stable; redundant with next change

(d)
commit 1ed2ec37b44e86eaa8e0a03b908a39c80f65ee45
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Wed Apr 25 08:10:08 2012 -0700

    iwlwifi: use 6000G2B for 6030 device series

- changed IWL_DEVICE_6005 back to IWL6000G2_UCODE_API_OK and IWL_DEVICE_603=
0 to IWL6000G2B_UCODE_API_OK
- upstream in 3.4; cc'd to stable; applied in 3.2.17 and 3.3.5

We have applied (b) and (d); (a) and (c) are thus redundant.

This is (a) but applied in the wrong place; the next patch (06/91) is
(c) but applied in the wrong place; together they are reverting the
effect of (d)).

Ben.

--=20
Ben Hutchings
The obvious mathematical breakthrough [to break modern encryption] would be
development of an easy way to factor large prime numbers. - Bill Gates

--=-ubWElQ5xwXyiZPmTLERF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT8Itbue/yOyVhhEJAQq8Ow/8DaibYKzF5onOVX5zW8zeP4YpaTNiofZO
2ydy8/0SMptCKvPAW34Db5/3MOMmGSQ3rRma3D46VtcK9mKJQm662kDb2odAsc7m
BA4GBOp6NKetSJYrZhnZ0Na10ihbirMGUOPEun7qyh+cx0f1fXcP3GGMt8K+vLgw
RuurVyriS7ntYrwz+GUsyDaQNxVtpxwq6U+ulHw6siF4/ZnIDZQ80XXCh8mSiSL2
PBEQaG5/1rUmqe8V+40e6cdt7Qqe/vAbLg9+VnUNc23xXmsYaYtilASGylOGCR5K
7LlhOl6xi41I+mRkAT5LntUytKgfSdvRDwd0LfQoMSQfzKCit0ln32fVk3k7tkWd
l2+oje8onp3ZWHWixuHYk8Z0B3h220y0kaGgdDDWOYjp3WS/v13OemPQVtwajZ3G
kv9JILMZ+hLIZbikU2GI52QAZHjLL7Ps+2i8zGLG0t5AJwWpu57ky+JuWlEhTjy3
yPzmHV3eQd2bytCG8zgOLuxPwdQsop+3iC/amjsso2tK11+/5r/xQVzuvDlTRAQo
uNlvbcBadHzY/eNyRFu/r/7+3D7BJeYzICpCnz4AkY1m43NOFejxDL1fj5i0svdf
EtTp8HBkhfzMSgEcS+Q49LCTZjb+fnP9NRDDmAJfbUfXP1dCExA3bMWpUYJk5IyQ
mEySgIBZvBU=
=C8gY
-----END PGP SIGNATURE-----

--=-ubWElQ5xwXyiZPmTLERF--
