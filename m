Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab0IWEU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 00:20:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48829 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0IWEU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 00:20:26 -0400
Date: Thu, 23 Sep 2010 14:20:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20100923142018.55019d59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_14_20_18_+1000_INaZb0wLuhTd547T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_14_20_18_+1000_INaZb0wLuhTd547T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/char/ip2/ip2main.c:459: error: 'ip2_get_icount' undeclared here (no=
t in a function)

Caused by commit 157be28e51ed476aa357c8718aaef4832f4da66b ("tty: icount
changeover for other main devices").

Please build test (especially the trivial "cut and paste" changes) ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_14_20_18_+1000_INaZb0wLuhTd547T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmtWDAAoJEDMEi1NhKgbsH4EH/joJiEPIrC3VpBWysZBVaOCi
6HM+8U4825tXIOx6jIs8x319H4ZNTwRhuo/FHxvSiiI3FdL6kmr99rIo+5Aae3+Q
hNlhSvsG7+2HwS73ipyQLUCZEeFREzEVbvNSth2DvVqcAy2vrKoHJWJLuzPU18ge
yznGtXxglOxBbMFoHP4dStz5tlubiVl7dfL0U8be/8YJ4b8QFDP0owEkNZ+DyiTk
MTNACp2fxQB9EqGgIyb0uASpLyEt5bLEsz8YBx0/E6LYu8Hs0NLoZOnSumU3GD5q
k7JOP209eY1BXe7+7jNSRjXblo8R4SgnKTsBYANh0ftDbjd4iZio6kcaYACqqjY=
=Zu4q
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_14_20_18_+1000_INaZb0wLuhTd547T--
