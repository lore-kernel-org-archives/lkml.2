Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab2IGE3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 00:29:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51513 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2IGE3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 00:29:50 -0400
Date: Fri, 7 Sep 2012 14:29:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: boot problems due to the slab tree
Message-Id: <20120907142940.5783c61bffcfd2344b5ade6d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Sep_2012_14_29_40_+1000_G7m4eSS9lfnjLudh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Sep_2012_14_29_40_+1000_G7m4eSS9lfnjLudh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Due to the reported boot problems in next-20120906, I have used the slab
tree from next-20120905 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Sep_2012_14_29_40_+1000_G7m4eSS9lfnjLudh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQSXg0AAoJEECxmPOUX5FEyzYQAJKstDDMRtfgD3QAHK5e5LxC
U/x2G8UM6efoinDQBqL5wmO53BtzliNdHwaHaEB9zCvbaSL+C3pyIPs6wDdP/Nts
G0bRGmdwl9mIgUHJ94Q79jJnu2ykfbLmEPFiCmWeJlUUWvvZvKZCSP7ceeHBL57m
ZQzwsQlnviMMeN0Q/6MZSyvSaCM+tp//T8W2iKWy6q53Wmufo/KhbXX3Qx2yeNn5
Sm5VEaeYlf7jm7wHBvHHlFpz8TpuZY+9LjHjWTGgmVyDQkDWkesTNN1tiTgp4W0d
AltTqjEepZKYfGKcK6dxLxcOY2LZoLN7KbDf3f8S0duzyuOeo6X4th51k1egfW+l
IwFMDW2l9BMia9xBthMuhI9qNJGa09mFgnBIerNbSNNdO1fa01ExL5wTkuEFvjeU
cl/2bUQanSufu09QqPMpGw5/jV9M+d6im1YjBDCEHCOMzUrMxt/cgMFDZiw1K2Hb
Gc4s+Ry9f2THTojglVK60nYcamvHygwzUOSinkLEgG6tXbt1Ej+QSjrGrH9+GFcm
QkBFo2CgkhLFsP2aAUNuXCiHU1ddZE8PiV3n0BvevPWtEYBdGGujIgBLYahOsVMH
AdFTD4MWYycPbtyxL1ARyutaG3MirZHZGb4cDEcIT/wZyU7Y/jGKJkWrO/R+p9am
FzQUhkESylcDy8egRgeS
=HMDJ
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Sep_2012_14_29_40_+1000_G7m4eSS9lfnjLudh--
