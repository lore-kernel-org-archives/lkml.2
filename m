Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2IYDb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:31:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51020 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab2IYDb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:31:56 -0400
Date: Tue, 25 Sep 2012 13:31:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the md tree
Message-Id: <20120925133146.36615871cf4ccbcbd422ed87@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_13_31_46_+1000_wQ/NgOEPwdznYcNW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_13_31_46_+1000_wQ/NgOEPwdznYcNW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

After merging the md tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "__tracepoint_block_unplug" [drivers/md/raid456.ko] undefined!

Presumably caused by commit 14817e9a6dab ("md/raid5: add blktrace calls").

CONFIG_MD_RAID456=3Dm

I have used the md tree from next-20120924 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_13_31_46_+1000_wQ/NgOEPwdznYcNW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYSWiAAoJEECxmPOUX5FEba0P/0t4lSgv5/tlRHO41yKIfHuj
FhlK2E05/2o0quHo/jvGC1+2gViJHQMbpkAXHXZK78epxXUD4ZGb7o+IBWcrAxFt
6VN2icaMqDvQrYQMCxYmRooM/0L6sQrvRWcdz4vVHNdRoqmou7AZvq+FBv3md2wQ
HujG3PgbQCQKc9LCNvc00FrOegQPLQwyk/TTjULQcPukhrCnvKCC8RTRRlJQEhff
26zdauGpthbBF3LeA9kaEtbOSHG1ALb41WCU1QBh8Edyd4lzvAsufzqJ3aKYpKc1
1VlatnS+LpAK6n4d2YJcso8l5FnvzEjxkmh4tOW/KDM48yYVsCcvipiSQEJo5cbz
wOgSTuYNS+K1HDqgluiDwzD8Y42fMILf9h1mdi77QiQxowQ47FfKc4Aej3s8gNx6
8yVrY0wyc7lcqAR4wr0+/b5w3ERKzHoIO9WTPXElbupm6oJQMjx8ps68hymRJTBA
P1VqvHBgf1lu7P2NK/yaMy04Nhz3Pi3blI+wxoaM84qXmGyMFB9xJS350G5i36Ml
AUFsXoqxb0GV8127ifrc6mzSVw7SVWcu+/L3dZKIk1RiKXbvGf7kBriHLOnMoQMc
xfDb4t9LeFq5Ruvz75ch6lldfOPYrLoWsNSQsQF7Fq5SxyrNWU0DY5RZvZ4WOPJm
6k2JC5JBSDA3CrpE0sA0
=mx+W
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_13_31_46_+1000_wQ/NgOEPwdznYcNW--
