Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284Ab2JZOVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:21:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:37686 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933043Ab2JZOVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:21:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,654,1344236400"; 
   d="asc'?scan'208";a="209695273"
Message-ID: <1351261326.1823.24.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: use the NAND_STATUS_FAIL to replace the hardcode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 26 Oct 2012 17:22:06 +0300
In-Reply-To: <1350272844-21866-1-git-send-email-shijie8@gmail.com>
References: <1350272844-21866-1-git-send-email-shijie8@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-sjwSloIewUGlOOkaYi6V"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sjwSloIewUGlOOkaYi6V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-10-14 at 23:47 -0400, Huang Shijie wrote:
> Use the NAND_STATUS_FAIL to replace the hardcode "0x01",
> which make the code more readable.
>=20
> Signed-off-by: Huang Shijie <shijie8@gmail.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-sjwSloIewUGlOOkaYi6V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQipyOAAoJECmIfjd9wqK0Q5sP/jKrGUHgtQeURDmkaYm+wOUF
OH/+TcqsoLojSXPdVydXbsw5XIGH0xKFMNarcmSZBGkM0DzAjWGXjdGj77I7V4PN
yQSpUJHNE8abrZhrrjVPyfjxko4JltkKzIVphmx9tmklry6pH+XwovqX4xeZ8/8/
HWEHfumbBE6hJGEkjsMKVaB8eKvjtwv8OCoqns99sXNU1c1foI0qZMns8QFBgRo2
gJZ7jZ22yhpncXfFEE9FsPtcOsq5vhxqJMPnzrIla/UrQBS0mqe8EfRJbyvAS5sg
JkBB8OA/7dkvDwEzS7ljD4lXzZyyT7X0hJ0yXSiDJ0vU5wQ7Ax6Raug+J0+RJYpU
PS3Aer//9HxnbpRiUs6Sht2lhCG6+No9UQJmigdabK2YsrK2SzBNCJt2ob0BQN+O
6UBw3U3P64NwgG7zWDk31DoVpSBUT848XCXTe2qy2QxDsG9N9LevnjpXZT/5GqKl
KNZdKVyu09isml65UWOIJ5XdmYiifPLzqf+Q7PLJG7Tkz/eWduixcOO4sq5F/rwm
79o6b4y7YSqvoairA2Fx+vVTASF4OekLDXcnWX21OZ8b9f7uKlSPuEiig2gASjdY
Y5AJx9RqosX8KBlLsgK/f0aueDxuYSA/229k8ZMqvekL6Lga9652/0HhEWG+Bikj
FeIQ57SEx1z1AMJbV7jV
=8sLp
-----END PGP SIGNATURE-----

--=-sjwSloIewUGlOOkaYi6V--

