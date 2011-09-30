Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1I3BFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:05:20 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:48692 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626Ab1I3BFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:05:18 -0400
Date: Fri, 30 Sep 2011 11:05:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20110930110514.eadb199f27c5418b28cab6c9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__30_Sep_2011_11_05_14_+1000_szYBZ+j/7zT57AN."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Sep_2011_11_05_14_+1000_szYBZ+j/7zT57AN.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, the next-20110929 build (s390x allmodconfig)
failed like this:

drivers/s390/char/zcore.c:393: error: 'THIS_MODULE' undeclared here (not in=
 a function)
drivers/s390/char/zcore.c:741: error: expected declaration specifiers or '.=
..' before string constant
drivers/s390/char/zcore.c:741: warning: data definition has no type or stor=
age class
drivers/s390/char/zcore.c:741: warning: type defaults to 'int' in declarati=
on of 'MODULE_AUTHOR'
drivers/s390/char/zcore.c:741: warning: function declaration isn't a protot=
ype
drivers/s390/char/zcore.c:742: error: expected declaration specifiers or '.=
..' before string constant
drivers/s390/char/zcore.c:742: warning: data definition has no type or stor=
age class
drivers/s390/char/zcore.c:742: warning: type defaults to 'int' in declarati=
on of 'MODULE_DESCRIPTION'
drivers/s390/char/zcore.c:742: warning: function declaration isn't a protot=
ype
drivers/s390/char/zcore.c:743: error: expected declaration specifiers or '.=
..' before string constant
drivers/s390/char/zcore.c:743: warning: data definition has no type or stor=
age class
drivers/s390/char/zcore.c:743: warning: type defaults to 'int' in declarati=
on of 'MODULE_LICENSE'
drivers/s390/char/zcore.c:743: warning: function declaration isn't a protot=
ype

Probably revealed by the module.h split up.

This file needs to include module.h
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__30_Sep_2011_11_05_14_+1000_szYBZ+j/7zT57AN.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOhRXKAAoJEDMEi1NhKgbswXMH/jWyTmhYoaSwBlY4X9LXw/ME
8IPfkmjHlKSLEqHRQjiZ8zWBE1sKFwxmdueqlUOi7UrjJd8fitRBQ5VrvpgPZYRn
HdWHk5JckO0Fwqdr1vRZ0Dp4uZcxV2Nvlgw40BZx54DCfcH42JDf2QDM7532O1dJ
zlFlHDOxpCK0rd0HSim9AMZR2m/0tUatTOrxDmbAnnqrcYOWOgp+HxDzRWicCHNz
Cct4ESIkXrJgz7Bn3gTak5723iZ5Ah7Dim6EeUk7oI5xfawqLYgaKDWeMevPMWMj
seQUMAC8dd3AWl4ftGb/ixPbGFRZtWSeXK82yIFtA4Nt5a04f1MS1WXMgrIka2w=
=kPgi
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Sep_2011_11_05_14_+1000_szYBZ+j/7zT57AN.--
