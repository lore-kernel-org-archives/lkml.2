Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab2ACHnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 02:43:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34449 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2ACHnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 02:43:47 -0500
Message-ID: <1325576745.8917.15.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the l2-mtd tree with the logfs tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Prasad Joshi <prasadjoshi.linux@gmail.com>,
        =?ISO-8859-1?Q?=22J=F6rn?= "Engel\"" <joern@logfs.org>
Date: Tue, 03 Jan 2012 09:45:45 +0200
In-Reply-To: <20120103140029.2f996dab9bdfd3ec5c876045@canb.auug.org.au>
References: <20120103140029.2f996dab9bdfd3ec5c876045@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-O9957zKcilNnUcqWwfDP"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O9957zKcilNnUcqWwfDP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-03 at 14:00 +1100, Stephen Rothwell wrote:
> Hi Artem,
>=20
> Today's linux-next merge of the l2-mtd tree got a conflict in
> fs/logfs/dev_mtd.c between commit d1cc3ad397f2 ("Logfs: Allow NULL
> block_isbad() methods") from the logfs tree and commit 957afd905eda
> ("logfs: do not use 'mtd->block_isbad' directly") from the l2-mtd tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen, this fix up is good.

--=20
Best Regards,
Artem Bityutskiy

--=-O9957zKcilNnUcqWwfDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPArIpAAoJECmIfjd9wqK0v7kP/0Zg2hXUJBuBBOS+/DjeZAkw
3GttCgCHXr83uj7M/so2oDWMncjKAHV0jR+b4QKFKMONY4hF/tOO+aoZXOkfoG6K
BtPAjKVVUzGp2O+BN9yJuVwMp+Wi8BJHeW+yQ01XyuT8E0/k5vzSTGyhPZCeLjl5
K184NmKIBPVAEbx4ZF6Kbl1DGHY6e5hiCPhTyladeh9QNq7c6y0PxSBKg2qWROmb
ZitttgRQVcZhn0lspjaifk4fnVB1/U9CJbf3P620TzAQB+rcxkUXVoubbYjtNyrz
BHwcES07eri7LELxYdiuy5zVPlnl/bwwmZ4br92D3gJ74cPCh17UkBKCtq4N15nO
VAbJi0lWwUOl6Crl+AIGd1ch0/u6d1Zwc7ESvzCvP2CppzbqAy3FtUIhXmzoq4DH
PmphrYpwiOzUbmHxMTzg2HYFSypcDVaxSTzQxBXboFUpITUkKm2f/cYRTZdyR5LJ
degQZumtOgWRN3UcXF78wErxOhcw1fR8qg9rG1rn2AWG+j26sqG/RKlyIDFmhJle
NozCQEjcBL5M5KD/Cjc3WErNCDWxmOo14MLvbDksKeF8c92a4laydXLZtYDt6uwA
RSZGBo+2JaLZ6JbY+k+dO5+C7loHfdc2zBzD1aveOcG36sjphjbR+NS7G8YGq0V3
24lS6pdhqMIesHowD2qZ
=SCiH
-----END PGP SIGNATURE-----

--=-O9957zKcilNnUcqWwfDP--

