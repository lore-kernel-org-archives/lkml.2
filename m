Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2JGXuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:50:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43682 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab2JGXt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:49:58 -0400
Date: Mon, 8 Oct 2012 10:49:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the acpi tree with Linus' tree
Message-Id: <20121008104948.6c0951fca954b44732f70bae@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__8_Oct_2012_10_49_48_+1100_c6PvP.0zt_d6tVPT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Oct_2012_10_49_48_+1100_c6PvP.0zt_d6tVPT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next merge of the acpi tree got a conflict in
include/acpi/acpixf.h between commit d8dc91b753b8 ("Merge branch
'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux")
from Linus' tree and commit 558dc6f9ee2a ("Merge branch 'upstream' into
next") from the acpi tree (which, as I pointed out, fixed the merge
conflict incorrectly).

I just used the version from Linus' tree.  Len, please fix up your "next"
branch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__8_Oct_2012_10_49_48_+1100_c6PvP.0zt_d6tVPT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQchUcAAoJEECxmPOUX5FEnrIQAJV7OjR+G/fVxFRFPH83Lyf/
2sJz5WatP1cS6YSlvxO0fERNKEvm0USE/gtqfsnPHFQVwdIAmqnOC2xDvP6h5QRq
tVGMmeLI2SOE2wytqbXvjeBKPyMrtjcq8WnHXgQP/R6feXVjKHJ5nL0UdhJ1HGrD
Ss0yVFaH2Q6qTl3uyiLPC8Svqu6uPvWhSdUhMpE+UKO30dDxhBc2K6mWe2fn8IMt
QppLaIWs8cZG+cMx7MN/F0h+0GrUqMGy8Ip/Sl/CqUCTjzOh/uuyxM/Oj+OudalV
FTCbfqOdTNqlpagt3bCJqSFzOZCMr4ESE+e/nJgwtHhtVKvlJovtwG6D59LYtZ1f
x5SyzN7dcJKB6RK00RRPSDSkcTNKFYkSZYFGQyBkdoQFLoMuqUwRGPGDRSopnvgs
G6RWoPF1Oa7+NrS/AreakeuXR0gxBGXzAS5Fh9GMAs/sCFvVHySo3bppoTJHZokx
PeMXFP662iq3U+UJ2waTtQ+xqaiV2qycJRMWur3ED49jz9a/Nw9/7CuAFX6erkzy
zo5z+GUsAFF5Aav7D0aPigFBLUNGaUjENuMPdGK99HEvmyODS25EPPC7EIrsYnGT
UjUogrZOhBi8Err4ces8Hu6qfXzBvNAblcQISXxTczMiGbbuzY6xTGBfODMSEmXd
WOPgFu/1h7WYOAvQq+Vt
=SHjq
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Oct_2012_10_49_48_+1100_c6PvP.0zt_d6tVPT--
