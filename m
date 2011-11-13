Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1KMNxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:53:00 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56109 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab1KMNw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:52:59 -0500
Date: Mon, 14 Nov 2011 00:52:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: cleanup time
Message-Id: <20111114005252.ed41504cabda72e4e8b60eac@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_00_52_52_+1100_DS5RKWS5Pql/dZod"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_00_52_52_+1100_DS5RKWS5Pql/dZod
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Since we are out of the merge window, could people with trees in
linux-next please take th opportunity to clean them up.   Hopefully,
Linus took all the contents of your trees, in which case git
trees/branches should be reset to be a (subset of) Linus' tree (this will
be a noop for those for whom Linus pulled that actual branch that is in
linux-next).  For quilt series, you should remove any patches that Linus
has merged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Nov_2011_00_52_52_+1100_DS5RKWS5Pql/dZod
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOv8u0AAoJEECxmPOUX5FECl4P/099imsKlEMcMGeyZX4iqHDT
7v9F9DYTpUscBY7J8ofsQfc8S9LG0LzJhFvjjDRri3rdXLd7fYuvIDJ/fCp/6eW9
rfLQP/OI3LZO7OpfmqoQzdpwl9VXI1Phi84IQ4d6wt+oUpG1ZPt8qII9Nb99fdXH
hZHM3k816lHc25W7CHVFLHB1NnnUbECsFgcgkJXFUt5puIf1dqyYR/uRqVAoXidr
vgo+FwKRZHWNdKm+NKhOwHxR7EZ/qHVA/g7bi8Kv0J1Y7XDlnPbc27itv2BjlXq1
A/Q8Cp0xq1xjKJwlply2KQVujJ+oI98eGETjD74OZFAFNFayy3pSl1MkFPI2hG8w
aBvumWDsLyRqCD3MVlRhElLtqAijlHaeRYKB73QuCXy6FaJXRxfoL/x35R9PY3rj
DMEhN6mGOBir7CVDhudSdnKJ1dVzf9FIbVqtWybuOZg3soX/8rC5L303qeDR+Skm
lgxK6PI9Z0CqbbHL31yV79VD4lrWbREwBYw2W8kBc9sEt5Nu8NiS5i//fdFKhwbR
W2p5RDbplfC7P9xUKrIr1GcyPrUv5H/r60Y1lg8ActWOvE+SrlEMb/9JiT/fYI3U
7EEUI61U4OjRh1pbWjKBbpZydICnrNVVf/GqRlhfVbgiNjdDOYF672ogKKy4s7IF
E5NcouijdQeRx4o26W7s
=vCJR
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_00_52_52_+1100_DS5RKWS5Pql/dZod--
