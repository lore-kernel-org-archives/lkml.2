Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2IXBqA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 21:46:00 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:36782 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2IXBpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 21:45:47 -0400
Date: Mon, 24 Sep 2012 11:45:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the vfs tree with the  tree
Message-Id: <20120924114537.2e8ef981e32ecbcb5a17bdda@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_11_45_37_+1000_P2GjN0VMAtqAuhoi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_11_45_37_+1000_P2GjN0VMAtqAuhoi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
kernel/events/core.c between commit a6fa941d94b4 ("perf_event: Switch to
internal refcount, fix race with close()") from Linus' and the vfs trees
and commit 19ba95358327 ("switch simple cases of fget_light to fdget")
from the vfs tree.

I just used the vfs tree version and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Sep_2012_11_45_37_+1000_P2GjN0VMAtqAuhoi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQX7tBAAoJEECxmPOUX5FEHDEP/0ZTKgFD8Avk85Rwv0eoH/Pz
UTNF/fPwfAtyUAZdSmEFmS9ncqKj/8OFyScqK+zdo6sB7dVJ7A3J1CCFbNs3T6zf
yEzXVNNcTGC/wly4/p2xDTFfKmSwK4GfxzIJIuUOQQwvOnuutycq9u0kHc/0qoOe
gZsVwI6n2tmbyBamoaTsH08auWVc4GxIUbDIP0CkrlUSaYcOXbBheWHUs2ozcVyH
Deben5+/KZTrnTSal0JuvN3bRugA+BayD5xKI6OAAT6TxAteMfr9vyOM2dNJeYX5
x3+CWXv2HIZAYchT6mID30BwhCT3Y7qjJN2q0+JqhP5oZBJaP0JHxQqezlx1Ds+c
gJAXO2dPGCk/JMTzClQdGVNeEc9xyiihUG/8ZcdaHnG9DrnKrF5hgunDpbXB/gcJ
Y4pXz0w6RPdW+d+xul3DKvEDJM3QEt5WJlYY9hiljyGAq1y7pnlbDit9M7cvhwnE
EBPTxD2FhOw+W2w5FLbcblJSB0eBBcLK0Gd9mGmkDvyxOLnwWry06uC4lU28us3D
IeuP4bqDGAMinkGqRCivuVblQ5dercyrF+4Tv+qLiHECr+asP/txVPYmYN5WixWN
o5NEY0SylcJZ+ylj+J0B4s1RCvseZOKyjPU0wwGpQctaylwiuXViD8v3ptS3NeKK
f5LRlIRtkRWdHD//ldwu
=W+fT
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_11_45_37_+1000_P2GjN0VMAtqAuhoi--
