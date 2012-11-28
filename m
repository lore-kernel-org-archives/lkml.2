Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712Ab2K1WEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:04:38 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60141 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab2K1WEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:04:23 -0500
Date: Thu, 29 Nov 2012 09:04:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: HOTPLUG replated patches
Message-Id: <20121129090412.4fc1a6e5a41f9bc24b827c7c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_09_04_12_+1100_ZtYQIWhQalne9RtJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_09_04_12_+1100_ZtYQIWhQalne9RtJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I haven't been closely following things, but is there any reason that a
large number of these CONFIG_HOTPLUG and __dev* patches are being merged
via the driver-core tree rather than through the relevant maintainers
trees? They aren't particularly urgent as far as I can see.  And they
already have, and probably will, cause unnecessary conflicts between
trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_09_04_12_+1100_ZtYQIWhQalne9RtJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtopcAAoJEECxmPOUX5FEaIgP/AoDyFf00JXt8rAPButquh9s
TJv8ZWDBakGmTcycwTCLbsNO/8l3c1IBQ4bvkr4JkBkWqcZPq+hTuugRnLqNTn4w
sdot4fS6SJ9BK320VM5USDwC7GL8dChoNDsPtMnepvT651LxFjvbL8KnEv84MiIx
FfIuzLsbMZnbAARELIMcla/VEeB5UIjbjXmzKas2dUI7rGARRP6sTsNz7ol1NHoX
extRgshBDbM39WcSnOOUd9gRwv3kYMa3Li9NlqTnRbKrs63g/W2QRJyUpNtVxeiX
ePq1hVExpVuQgWiWoc47ikrXiDBWYqAnSRTzZQRprmJTKEAShcaMxokij4JwNSCc
dXBUE9Yd608VYVUWrorcMWRWyIRIv9eclSY3xtQlQYSFSYuOubFKhSVLnQYS3OPl
ITCyPNJJuMIvZh2MrLrd4Tb738xmH+QSfxM/0wS2C1ky5xPat1wMJyXDtsWBE6rj
qYPsRq4VXUwN7ZAS0RXU1inQ4LmvmS/u3JJWR8hnkUF6nI+9kQ49BjvNMzG+WVa1
+oiGIxnyMRbXXWabNTB/5WqWKN4txgrvS+nrkOaQeFvKLbAFBq9lrG7RQBUYY4go
MoLLE/intc7EL5QZ55xvqV8fU4Fb4Z3h3kdmwD56jp3brgfqp5xjuuHi/nGoSmw3
zubmSnNfbpxKdoQKBIO+
=UyiP
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_09_04_12_+1100_ZtYQIWhQalne9RtJ--
