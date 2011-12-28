Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1L1JC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:02:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45367 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1L1JC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:02:26 -0500
Message-ID: <1325063055.1165.103.camel@sauron.fi.intel.com>
Subject: Re: linux-next: manual merge of the staging tree with the l2-mtd
 tree
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Dec 2011 11:04:15 +0200
In-Reply-To: <1325062442.1165.95.camel@sauron.fi.intel.com>
References: <20111228175440.fa8c027e41dbeaccddb0e6ea@canb.auug.org.au>
	 <1325062442.1165.95.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-eKfsrffDQRrlDsbqBAKj"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eKfsrffDQRrlDsbqBAKj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-12-28 at 10:54 +0200, Artem Bityutskiy wrote:
> On Wed, 2011-12-28 at 17:54 +1100, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/spectra/lld_mtd.c between a series of commits from the
> > l2-mtd tree and commit be7f39c5ecf5 ("Staging: delete spectra driver")
> > from the staging tree.
> >=20
> > I just removed the file.
>=20
> Oh, it is in staging, I somehow missed that and pushed a small clean-up
> to the MTD tree (because the driver is an MTD driver). I'll kill that
> commit now.
>=20
> Apologies for the hassle.

Actually, I was thinking about a different commit. Anyway, thanks for
fixing this up - removing the file is fine.

--=20
Best Regards,
Artem Bityutskiy

--=-eKfsrffDQRrlDsbqBAKj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO+tuPAAoJECmIfjd9wqK0tiYP/3Kn1CcBLSIdRXNGt+b2e1wU
CyRkb8x1C2/JVg2Eb5Yvl99JH2Kzf0OxakSR8RCe3DBoxTdX/TFW2xTNorpWNtIq
nFHrXSSyQE0zSR7lFN3bByYn8Kcym6S9t/ExRG5c2ZRiPrgFK0dMcS7QDLArwgi4
YPLLlovx4ZDXS6Z5rPw8YN6qmbkqKUzHxbH5puud7oB2b2lupftUDX6BXT++D/nq
lrPLMFmvPY335ETJb4PM91pSKFsnNeWPtoYf8QN4wELJ7mRNyMhQqXTiDVCMQ6MV
Ak8YDVaNgT56cj58LgneK9im+QC8k0wd3VJf9PEP1eYvAJsJnZfLS/zNYZAajDBu
fDIwEfWX8Fjxm1Tu7O4ZJrEwxqDPJTRWWCbvs770qjASw1OmK9aUkZMkyJtDDuiI
5XTop0CJAkDP6L4H7C/wbo0ic+bj3nHA/CQBeTjmqKzTq0kAd+HGcsxVdJqAI4lc
8Ih3ar3YkGacW848lx4Ss3UumRIvNgwqSVnCH1L6nrYP66TBsj5M3f89d1yk7Act
qGo0St+rHIy/tN5DFaYauiZN1xm7qDKyHC8RabBzCZq6N1xmwj45pPQ+WMoK0ReI
WLDa0V2jnB+yQsyY0tTk0X68ijY8YQ+o61v34DhcrW4lv4uT/Th1hyoEQi9SHdve
1HlUw2UThtukGbolC51Z
=vyk7
-----END PGP SIGNATURE-----

--=-eKfsrffDQRrlDsbqBAKj--

