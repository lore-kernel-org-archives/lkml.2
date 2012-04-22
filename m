Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab2DVOTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 10:19:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:41532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2DVOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 10:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="132585075"
Message-ID: <1335104359.7078.0.camel@golum>
Subject: Re: [PATCH 1/1] Remove UBIFS_FS_XATTR config option.
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Subodh Nijsure <subodh.nijsure@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>
Date: Sun, 22 Apr 2012 17:19:19 +0300
In-Reply-To: <1334419797-28995-1-git-send-email-snijsure@grid-net.com>
References: <1334419797-28995-1-git-send-email-snijsure@grid-net.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zIAwDYVTXJHeKVHgvwid"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zIAwDYVTXJHeKVHgvwid
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-14 at 09:09 -0700, Subodh Nijsure wrote:
> Remove CONFIG_UBIFS_FS_XATTR configuration option and associated
> UBIFS_FS_XATTR ifdefs.
>=20
> Testing:
>        Tested using integck while using nandsim on x86 & MX28 based=20
>        platform with Micron MT29F2G08ABAEAH4 nand.
>=20
> Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>

Ok, while babies are sleeping I had time to handle my inbox. Pushed to
linux-ubifs.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-zIAwDYVTXJHeKVHgvwid
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPlBNnAAoJECmIfjd9wqK0HMoQALvIYv08xI/FkXPUYYLmCfZD
ocSbo0f5JBDeMkDOqc3WCxK7mISC/f0fNFHZHBGFMjEy4lZmVKnokr97CQtYYqqg
84+be4v0JfLLJcTrAWne5eyUGqs7mWbV6A4cu1u/2MH31+Nkc9+QeCU8AVxqcpzk
nhh3GbazsPavKWLyJNbU1fGjkk4YMkLemuD+D/O97MTVLQPofsZ9oovyUWPuBjXE
gXVV4MFAROr68woaAuAnm1ixBiPQXccZb6Zc44BLwU8Fz44tggdfMUO+GCND93Ts
wzOwWDjOxinr2nnPW/EGxdbQRd6wShaF0ugCbC+TAkBLrZWv6Ki3JQCSc+hCTDEq
Yb7qxSA2TzrLdfas/iDwdueogwVN0CToYvMpQyEqPyFWa/yrNduPb4w5xE/X4IVA
rvePzwHkgAMuypb4awUlfNWX4mZSPAt8Vk9SkN993oTAGxYaiviXobdHO8NWcbFQ
Jvsq07VtByWOSc5M6uNr/HQkDIDVW4dPfrYPsJukFgyaiL5ELNX7jL6r8NyAWZWg
dtLxjYrdxY1GCZWXyLcbi7xiGBBOqpZAaRzmBcX9TbpXiYBxCGZ8WM9Oo7nF2wJu
6PCteVcwz+97fMnaNYsc8qNOdrNjsYGtxyMz+bDukPrx9VrleLQGSVl8TTpmdw38
D+gm/sDHRqOxzAv52OUz
=oED8
-----END PGP SIGNATURE-----

--=-zIAwDYVTXJHeKVHgvwid--

