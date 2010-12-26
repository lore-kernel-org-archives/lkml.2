Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab0LZWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 17:45:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60388 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab0LZWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 17:45:54 -0500
Date: Mon, 27 Dec 2010 09:45:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sh tree with the sh-current tree
Message-Id: <20101227094546.63f76577.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Dec_2010_09_45_46_+1100_WDlnhwlptebDKf=F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Dec_2010_09_45_46_+1100_WDlnhwlptebDKf=F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the sh tree got a conflict in
arch/sh/kernel/cpu/sh2a/clock-sh7201.c between commit
27f1acccd4d310e941d2e879445324595e2fe463 ("sh: Fix up SH7201 clkfwk
build") from the sh-current tree and commit
16b259203c513ed28bd31cc9a981e0d3ad517943 ("sh: migrate SH_CLK_MD to mode
pin API") from the sh tree.

The latter includes the fix from the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Dec_2010_09_45_46_+1100_WDlnhwlptebDKf=F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNF8WaAAoJEDMEi1NhKgbswoQH/R6JFLc9csScpiV9WDq1HP+B
WWVNCjGcIYgtdonm03p6E0erDTUW5aifA+2QGSPEsNV4mHgl+sa/DqHjDUigl+id
/xGQbpYiRXiZzc+g9L/mThYiOOugLf4nDXdARglZVyiDCPebUHr7/D4I0KhxBiw6
GwIeOTw9XqL63UoGM3+R03IVy8NE4OIwr36F78S0Z9PKl7CXnzbdB5VqNpxVaKMX
uf+uSmHhABINzyWpkld4NHGa6VywIaPtuszMVE4lURw5D9ZXw/FyILHAkrGovAyc
IG6+Cz4yN0fEUE8lMSqfRBNhA6kOtWhjSaQBjqw8AdRZizhcdjppD2WASMARUHY=
=PRUz
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Dec_2010_09_45_46_+1100_WDlnhwlptebDKf=F--
