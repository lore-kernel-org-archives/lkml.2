Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2IMXHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 19:07:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49718 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2IMXHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 19:07:33 -0400
Date: Fri, 14 Sep 2012 09:07:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120914090723.6e0528a45a69233f5ea4fcf8@canb.auug.org.au>
In-Reply-To: <20120913183106.a154a63a75cef8efa03317ad@canb.auug.org.au>
References: <20120913174441.f5fbf5cc38713425331f4d86@canb.auug.org.au>
	<20120913005657.1ae79a95.akpm@linux-foundation.org>
	<20120913183106.a154a63a75cef8efa03317ad@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_09_07_23_+1000_sD/Uq=6uPNmTeFFk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_09_07_23_+1000_sD/Uq=6uPNmTeFFk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 13 Sep 2012 18:31:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Here is the chunk of the series file I have:
>=20
> idr-rename-max_level-to-max_idr_level.patch
> idr-rename-max_level-to-max_idr_level-fix.patch
> idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
> #NEXT_PATCHES_END
> #
> linux-next.patch
> i-need-old-gcc.patch
> idr-rename-max_level-to-max_idr_level-fix-3.patch
> arch-alpha-kernel-systblss-remove-debug-check.patch
> #
> #NEXT_PATCHES_START linux-next-urgent
>=20
> So idr-rename-max_level-to-max_idr_level-fix-3.patch is excluded form
> linux-next :-( I guess I need to just move that further down in the
> series file?  Though when you send the preceding three patches to Linus,
> that fix-3 patch will be needed when I merge the thermal tree.

I put idr-rename-max_level-to-max_idr_level-fix-3.patch into the akpm
tree in linux-next (just after the -fix-2 patch).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Sep_2012_09_07_23_+1000_sD/Uq=6uPNmTeFFk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUmcrAAoJEECxmPOUX5FE6fkP+QG6gejBHcfmiafsvO4Yn3L/
21n0I5Q5bsXLTABkZOWi+72Y5PFjerb6vKQEC3vpR0naQacSKkCo6MWrzNPJFLu0
xA4RjkoYvJWdxGv6ipS0kg6ulhuwh+bt98S/ker4J2+0v6PJdWYBe7Pmkgi3AJNx
wLZVEYbeAUkept52GtmBG+sXyWS7cdVk/lfExCcqi0M1PSB04IF93/U+Dsa+F36U
Nc/yR6aEV84jZDiZtrFgAUMOmt86l7cIx3v8lH9HFVk/m7+Z3H6Mbo0b0DxYuL4r
f7okPvyug1VLkn8sknMOifjk7C5mxlCkZFpSexTy/r/kVFKRPJJxnek+QAQWtu4R
mJ+Z1dK1r4RKv5JgPRB1WQhR31ctIefbMDHvLBv8odTF18wK9wiw6DSYepAi7qvG
usyyryyAhnCCOVgN+8V56WcyErDVZA7OSOnFbRyNbY7+AWx2P86Yfs+jxoXn0EI8
LSHTl5HA7FtryE9YW7tg4jO1QOx5EEaxOmzt3hM2Rr0b8PDS/JKN1otcHg72EVs2
qfR930gT1pAW5CQDaIz5njYMvYLU8hwrePKmQEfWpqXFfqUstHzmOHugaHT0L73+
Ci/0IkwqMXTt77gqFdqWHhDo6tVvAgb4IBTwCU9LBvE7p9nWLCjlshY/2UiFU0dC
cCkf2r1CsrZEwhw/taH5
=8Zkf
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_09_07_23_+1000_sD/Uq=6uPNmTeFFk--
