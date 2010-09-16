Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab0IPFBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 01:01:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55441 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0IPFBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 01:01:07 -0400
Date: Thu, 16 Sep 2010 15:01:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: linux-next: build warning after merge of the final tree (block tree
 related)
Message-Id: <20100916150101.3ced35b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Sep_2010_15_01_01_+1000_kBBxxzXA5TDwxZOO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Sep_2010_15_01_01_+1000_kBBxxzXA5TDwxZOO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the final tree, today's linux-next build (powerpc
allnoconfig with CONFIG_DEBUG_SECTION_MISMATCH=3Dy) produced this warning:

WARNING: init/mounts.o(.text+0x21a): Section mismatch in reference from the=
 function name_to_dev_t() to the function .init.text:match_dev_by_uuid()
The function name_to_dev_t() references
the function __init match_dev_by_uuid().
This is often because name_to_dev_t lacks a __init=20
annotation or the annotation of match_dev_by_uuid is wrong.

Introduced by commit b5af921ec02333e943efb59aca4f56b78fc0e100 ("init: add
support for root devices specified by partition UUID").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Sep_2010_15_01_01_+1000_kBBxxzXA5TDwxZOO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMkaSNAAoJEDMEi1NhKgbsGBQIAJDf+ERJ9oAioJy+cYIiHPyy
4jpKJk8dhCtWIicOGuj2tDOUm1/MMJQtKcJtYOG0fR31fnGXBDTPJiQgt9o3DM7q
i1n5RBJ48ENDCRmsQKyR//To9BEfxrCewIyiD2MXlLTQFKshxex1AzZF+S10KTc4
hUuglFgbKR6L3g16rXK6nYBFIGicxFlL5eP+thrgJPwGOkXw9D7iW0NsBGlZYkfe
aRAglB7gt2pPoLjafEN513JUPOXNjiPbF5KmHqBRypgPihhwSFeDRrsu4x36bZwi
eTCmb5QIaJMOVCSIEg6d15nNikcORvKb4fPycA49ZPRhJ65Q75SXkXaKuMjm0Qo=
=woiW
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Sep_2010_15_01_01_+1000_kBBxxzXA5TDwxZOO--
