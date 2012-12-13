Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2LML2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 06:28:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:50039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2LML2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 06:28:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="asc'?scan'208";a="233387522"
Message-ID: <1355398120.3400.46.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 07/10] mtd: nand/gpio: use io{read,write}*_rep
 accessors
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        benh@kernel.crashing.org, arnd@arndb.de, james.hogan@imgtec.com,
        Matthew Leach <matthew@mattleach.net>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
Date: Thu, 13 Dec 2012 13:28:40 +0200
In-Reply-To: <1355166762-15133-8-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
	 <1355166762-15133-8-git-send-email-will.deacon@arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-LSJehB3qcSwBLeZbc8kf"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LSJehB3qcSwBLeZbc8kf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-12-10 at 19:12 +0000, Will Deacon wrote:
> From: Matthew Leach <matthew@mattleach.net>
>=20
> The {read,write}s{b,w,l} operations are not defined by all
> architectures and are being removed from the asm-generic/io.h
> interface.
>=20
> This patch replaces the usage of these string functions in the mtd
> gpio accessors with io{read,write}{8,16,32}_rep calls instead.

Pushed this one to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-LSJehB3qcSwBLeZbc8kf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQybvpAAoJECmIfjd9wqK0vtcQAKliGYZyOYPGvbM1we/D6O44
hq2RBr01Aa7/3R/NmqSxkMmWEeET0zP88/FMIKVS/dEx1xF2ZYMSJPuMhMjchWzV
xkChUg1nbkr5Nh5WTCSjVwk4LYcichcqifsgTsDsLGPuNqJqTmiZtUCnPoAMfn6Z
AT2gzcJUMWglkB1YbaznEShBlsq575GBKKEfjp/jqwyO3uneOdVtuOu+L5wtL8Of
XCXsaYdE0f0+hQft3m5fbTv9MRtRONKHKCmVR8Cai1FZ53j0fRQZi0Z2K31Gdrko
/jaJKiVcEpiBS8WCzkDbhcsbeSIDaS7t7FeGCdKfwp5X21aGS09c74tURrz1wbyG
bzEu2HEpP9sMxS2gMeKwpSDjdBnlLQOjw++1a7KtiGGDkhA+GdpD8bOG9/x0ynm9
HsutjqmkW+JapFVqlueHqEVNyRuen2ig34MFNIVjaKnMnDY1bk9pI/9VgqWRQ4N1
zZDAMUvPH+JyJz7JDdMW8mmYnoJkKCPh2DZE1VxHzU7BLdmJZOG164vvhpGLnVee
KRBpX2d5M1vLAWQ1IjfqU74c5BJCJ0b/Xj7Rhl89jBkPdjYhEYzM2MHZsPmSm6ai
D9gcm5CmBve6cf/0/iKff44089r1EtPJycc27sLY/iu43+IwMqtmMG7txV7b5Fs0
EGyxq227AKhkU02Iiaj6
=SDm3
-----END PGP SIGNATURE-----

--=-LSJehB3qcSwBLeZbc8kf--

