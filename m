Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2JUXlI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 19:41:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42102 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2JUXlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 19:41:07 -0400
Date: Mon, 22 Oct 2012 10:40:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Zankel <chris@zankel.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the xtensa tree with Linus' tree
Message-Id: <20121022104056.d157f09f9c71052ecc1f64a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__22_Oct_2012_10_40_56_+1100_sUVnpFkgvKD_i0b/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Oct_2012_10_40_56_+1100_sUVnpFkgvKD_i0b/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

Today's linux-next merge of the xtensa tree got a conflict in
arch/xtensa/include/uapi/asm/unistd.h between commit 7216cabfff51
("xtensa: add missing system calls to the syscall table") from Linus'
tree and commit daff2ab722aa ("xtensa: add missing system calls to the
syscall table") from the xtensa tree.

These clearly were meant to be the same patch but the on in Linus' tree
has a later date, so I used it and can carry the fix as necessary (no
action is required).

Also, the top most commit in the xtensa tree has no signed-off-by line or
any real commit message.  Please fix that up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__22_Oct_2012_10_40_56_+1100_sUVnpFkgvKD_i0b/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhIgIAAoJEECxmPOUX5FEZA8P/2B2oU8PfeyZil3fExkjhR9s
ZelCbdGAsZ6v9TfGBWTbDk0zfUcriZyCrCGpAPz89ZB4KAWk3OVs6W//L6RCm5R7
DfaWJgeSlKWSVg9oYiONCPb5XojCa58Er0rkicUQZIGaWbHDvGsxiLWzuuv+WHkB
W7PXk9GqkpT8SqQnE97OaaaIzdvJKB9Vv4uJYsCoGDoPZC3e+wNzFybIXh1qe1Bb
8nIMDEPxy71jrerHlcRvd/MYKRYsZFHiiIpeOvkwVLZ/8vCyIBYh3Xt1ZFfd+7me
eMNN7CCBn9rghcIZJ/FDnpTNt8Vv2SnsX/EFruoGXpIWXKbGzkhRsNd3AQxsQ39C
7G+uK2m2YLpT/CfWB9v5AfjM0kHQC0IDJyCLWvD9LHvJJu6pfGw39dmAalsxPzGN
vRQlByWU+rCQ6Xv878GLZ2gDwREOOz3ZZ3jhhuMdrV6y0HWuR2nbKG9pDB4fzCH/
l7qAECW9b8zZI2mljmJ+nrjo2buSZ8ZVZvb1kf+XzOOngF0e4nBDdOHQStmslMr+
eKF7XhUEbErlSYIDsPF7RP505zi1eSqxTa8TELqY04M9fhZMYNLNDNmykz3z+c0V
xiswPJPe/6ZbFmzuTs0LkB202tqdRef6TlaLo75khw8JH+EEYyvCGQ7JchTK3Ly1
OgDQa0tKAlraZRBHWlxf
=VZo0
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Oct_2012_10_40_56_+1100_sUVnpFkgvKD_i0b/--
