Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab2LIFYy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 00:24:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42434 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2LIFYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 00:24:53 -0500
Date: Sun, 9 Dec 2012 16:24:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Linn <John.Linn@xilinx.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: fetch failure the xilinx tree
Message-Id: <20121209162442.15fbb8509569c193bfd88986@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__9_Dec_2012_16_24_42_+1100_ZCd0D/lMBNQusfxl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__9_Dec_2012_16_24_42_+1100_ZCd0D/lMBNQusfxl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Attempting to fetch the xilinx tree produces this error (and has for some
days, now):

fatal: The remote end hung up unexpectedly

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__9_Dec_2012_16_24_42_+1100_ZCd0D/lMBNQusfxl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxCCaAAoJEECxmPOUX5FEeAcP/3MNhMIalGNseq8MOEjRYh4D
0w5RTo/EBShUYzDYoxY7K0bniYU6nJRnSuW+PRVKEv03RK5e9YMfHS2+prZxq9FW
foL3RKPLUoUG10MKBnXjzvZ8nwHd+lE5i5Ui+QbskOsKi4z4y7pzBSuKSpRRgU4l
TRikU4c1s+OLv8MogO4YTw+lYzp/h208BdltDT5zLMSxTzc5UCAyz2IwVof9RzTz
6pr1FaO8Jcq1QWm3gLWZwT+w2YzkdLn6q5PKWgcCVqP+hj3jQ19gboEVZBuZLVBh
BSWOgR8k2EdKsW3U3uFd3dFXt7xpknJ6UYnb66b8hM8AXBqUIgeSSAh6Agt7L7Db
xkUIaFLX/LtD5tfsXvOM5Yb1Y7kAQcWjLpyXwSf5Mjha0CHlcrYlAp9Hyv6etawN
T9w4u32BuQqdh4oUn5l566sMXNilJfKwQq2qnXmfq/KKmIzm32JXuMb3uURI6OFG
pcDxF6/KDkmMG2B07g4iwrX78QV5HUBexeQXz3fc980Z8+AdA07RCiAYZhdCAh5U
Eid4MPr/wRxYmUb1YSDRRUI7bZugN1iJjiDG2CtYV5+fsJCnAje6r38oSMwkkf5R
lCATe0r0oIW7LGyzdtXRyakQAW3RTmLSUOtiEirM9YoRqh9M8oP2symJtBDN6I4w
9Jo2ABPxo86hZyPShjED
=dru2
-----END PGP SIGNATURE-----

--Signature=_Sun__9_Dec_2012_16_24_42_+1100_ZCd0D/lMBNQusfxl--
