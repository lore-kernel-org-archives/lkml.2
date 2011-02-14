Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab1BNCUD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 21:20:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45662 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab1BNCTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 21:19:55 -0500
Date: Mon, 14 Feb 2011 13:19:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Sandeen <sandeen@redhat.com>
Subject: linux-next: manual merge of the ext4 tree with Linus'  tree
Message-Id: <20110214131948.85c625c0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Feb_2011_13_19_48_+1100_=kR5Xv.UPhNH4QOJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Feb_2011_13_19_48_+1100_=kR5Xv.UPhNH4QOJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next merge of the ext4 tree got a conflict in
fs/ext4/mballoc.c between commit 2892c15ddda6a76dc10b7499e56c0f3b892e5a69
("ext4: make grpinfo slab cache names static") from Linus' tree and
commit 63a1555068c51e47fcdd3c097e9891ac88e86184 ("ext4: make grpinfo slab
cache names static") from the ext4 tree.

I used the version from Linus' tree (since that one was updated).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Feb_2011_13_19_48_+1100_=kR5Xv.UPhNH4QOJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNWJFEAAoJEDMEi1NhKgbsm1MH/0f1KXFg7TFmR69gMokMRr2h
I/mCd3qmqVL+/iM/9b/kShT00j5m8Jg/r6xpEPq4O7TJBa9yRRJv8Z08DfELGUOy
UQdngXCc5PWUD37vibD0KKm+1YyVGn67/WUfTM4ZJuZv+Qh1x7O7F5ZiIZVqN7B6
LQUXlhpuXpFAzn+vf5kohxtxuYsMTg2CZEFZv4ls8ojD3RlwepVBgBS6cgSwTA9L
jU6/nJFa59pJ71Cib6EtlfroKWxQ3C8aRAR9Ls5OMPOovZ1ncj0n7prDT/AuisPs
GG1smDCJZ3HPpYINXC8zKgV1v4vxNQi0M4KNYTcMptBZYZfgWpbGHPQYKrS4Stg=
=VEJo
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Feb_2011_13_19_48_+1100_=kR5Xv.UPhNH4QOJ--
