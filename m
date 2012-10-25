Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234Ab2JYCTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 22:19:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33075 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122Ab2JYCTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 22:19:16 -0400
Date: Thu, 25 Oct 2012 13:19:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Abbott <abbotti@mev.co.uk>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20121025131907.cab4682e1792998d9cca2c19@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_13_19_07_+1100_LDcquVnCcXKhJEk2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_13_19_07_+1100_LDcquVnCcXKhJEk2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/amplc_dio200.c between commit dfb2540e91e1
("staging: comedi: amplc_dio200: fix possible NULL deref during detach")
from the staging.current tree and commit 71b3e9e8dc21 ("staging: comedi:
amplc_dio200: support memory-mapped I/O") from the staging tree.

I fixed it up (the latter is a superset of the former) and can carry the
fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_13_19_07_+1100_LDcquVnCcXKhJEk2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiKGbAAoJEECxmPOUX5FExagP/iqftt3idJgCRXDdVq4FPGyx
+Am/e7kGM6/N7Nt+CmS7OxxevsIoq2khUqRxhtEIbtRXerLxMqBalVD/DGCLgiqV
/j8wvVHOeXScwmwjIppmaiC/fcb/7ayeI7VoxvI+mxpNr6fCvhMzd2jsV1kyDION
lE7uDFby5KPJS6gcx+9O2kLU1kT3eF0udetI4ZppPDa/O/cZz2+Rw+UUzQTvSbXh
AHrwW/zhhEL8a5yxAIiy0aaKFEtBfSKQnMrHfBjZ5f7AA802/V2mLxhtvNgoxmjD
FEDPzudyhOE9OHEdxapjofo4rdO4UxnBASutemC33WdgLTddQtKyRl8yX6HCNoqu
/8iyS2KTmE599qMdOMfvhCVzufvbqk1k+yS+4dGCeB57qwkQcRBAq8r6FQTSrQa9
r7j6XZWJ0fZA2nDNONNvlPMGNrkK/JohH+qKsrVSWASgZkLFd4x8Ozn8OTVOxXZQ
7Et5T4qLnFv5WzAiPUsVjtC7BFczTq0gyUs6i+6AWBErlt1XYMgZCnosytQBfbXN
ojsFtIvgm5hwC3ypibUMVWF133rGY20VywnUssTGhQrvu0i+tZwAB5AYiScUo/sq
4NfeM7AgIRC1+NGjY5OUvlH694rB8kCly6wOmDuiLZ1r/AQDlJFDl80xs66ot1zD
TATT7BsSQJ501eUGB90S
=7WKW
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_13_19_07_+1100_LDcquVnCcXKhJEk2--
