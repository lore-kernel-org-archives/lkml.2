Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750822Ab0IXEJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:09:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52261 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734Ab0IXEJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:09:05 -0400
Date: Fri, 24 Sep 2010 14:08:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: build warning from Linus' tree
Message-Id: <20100924140859.038ccf89.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_14_08_59_+1000_bwTfImwWnPG=IMnk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_14_08_59_+1000_bwTfImwWnPG=IMnk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's (and lots before) linux-next build (i386 defconfig) produced this
warning:

fs/autofs4/root.c:31: warning: 'autofs4_root_compat_ioctl' declared 'static=
' but never defined

Introduced by commit c9243f5bdd6637b2bb7dc254b54d9edf957ef17e
("autofs/autofs4: Move compat_ioctl handling into fs").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_14_08_59_+1000_bwTfImwWnPG=IMnk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnCRbAAoJEDMEi1NhKgbssd4H/3PcOClw/XQvuRc51q6wo46P
wJ+wMmubmJo8wkWcnXGajI/5JEFEewQoTOyTD2ITzlSCBriHCf6Mo8Sn4j9F68Wp
cnAmRx91qTuYQDmKUz8WyRmXSjOYwJ4SIfQHeLuZpCTxQlQFTOpELetpXo7zpg+w
HOKuu5qqMVC6eNuz3PfBSBXlGUeYyBRvNiIwvyLgg7+EovSR5/+0hcey/80hfjcv
ja0fxmDnvDQsv+Ryl/+CJIrO+GoHsXqBZDAORBEeJBRkSvbhYzAywYlvECyL4Sdf
I6QnrIfRl3CK0OO0aklnErOiiPkjP5FyMhZFUZE1+WRlb4X3+bt5jPqn8TUI4S4=
=tSA+
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_14_08_59_+1000_bwTfImwWnPG=IMnk--
