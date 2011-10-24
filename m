Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1JXTKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:10:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:55601 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1JXTKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:10:24 -0400
Date: Tue, 25 Oct 2011 06:10:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: failed to import the device-mapper quilt series
Message-Id: <20111025061010.26d2b727559242a5d188918e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_06_10_10_+1100_UGKbK=hPfifq/SgP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_06_10_10_+1100_UGKbK=hPfifq/SgP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

Importing the device-mapper tree today gave this error:

$ git am ../quilt/device-mapper/dm-add-persistent-data-library.patch
Applying: The persistent-data library offers a re-usable framework for the =
storage
error: drivers/md/persistent-data/dm-space-map-common.c: does not exist in =
index
Patch failed at 0001 The persistent-data library offers a re-usable framewo=
rk for the storage

And indeed, this file does not exist even though this patch is trying to
patch it (not create it).

I will use the device-mapper tree from next-20111014 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_06_10_10_+1100_UGKbK=hPfifq/SgP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpbgSAAoJEECxmPOUX5FEVxoP/RStmsXzyJ8dc5S4KiaWjvJP
0HDuRWFV6e03dHSf9XnYG+GKqGXDdsvZwE/cxwG5YGRTcoXHQS9y8BPzdM19sJwQ
LF2+7VRA15tFIS0+RMzFr88CbHDDLbDWrDygnkKT6Orgi0Gd43MJp+ptFY73po0S
gBbR/ItlD2zlrPvlKXmtuCgXD+0yuimOpbypgEAXebxsd0W7aSNcPy6XvWs+z1yr
3Iq+B03wSMOnbWYNiikKs4BlCkCIOtSsdP+wKw24dN6kTksfUQNh0zIgdklYbtzE
gJ3t6j57acjK4R/J5bJxSI1Gw6JkXdSmwbNPvk+mPx0e4SPgO+SEyYdDV/Z19HjZ
cnFqSDpbFuoFyStqfhGLzZ13z+UK2ORK8n+fk5nGTyPIxrr87Vh48E+ZbkKT88zA
G0so/A8XLM0cr1/q8RSIcqQwNwTqm1gnB3kwDPE9CgwM72DX6rU5mJLz7YUECd+h
zppUmmQbUHH7/nvh1wFSYfJr5fGzdzHzoQ8NAciadHKV4Go58EE3kh+axhCekL26
4c/H8iilyfJ/0I0s0qqoOWPgCOGCek3FVXATksLZ8OsjpcaxoXIV2WIvlFWzzoh2
OMxstUNIlCbw2pTLC+5r3hIjsBipRSsm9iEtaxvYKTTb7vS3gpBfEzlwm8B6xZff
Tp7VcCm0mwuA+GFbU5+x
=qfOy
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_06_10_10_+1100_UGKbK=hPfifq/SgP--
