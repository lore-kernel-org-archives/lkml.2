Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0DZXXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:23:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38505 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab0DZXXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:23:51 -0400
Date: Tue, 27 Apr 2010 09:23:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning after merge of the tty.current tree
Message-Id: <20100427092346.12c4ecaa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_09_23_46_+1000_hIq1GjxQRooQpg7e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_09_23_46_+1000_hIq1GjxQRooQpg7e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty.current tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/char/isicom.c: In function 'isicom_open':
drivers/char/isicom.c:875: warning: unused variable 'card'

Introduced by commit 746b212efb4664117612c7f43f880d230588d617 ("tty: Fix
regressions in the char driver conversion").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_09_23_46_+1000_hIq1GjxQRooQpg7e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWIIIACgkQjjKRsyhoI8xpMQCePrNm4sNPQbjOy4aeapbSwne/
aSgAnjUKPjRrXgTRg8/ekXhpwWh16u3y
=V3OR
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_09_23_46_+1000_hIq1GjxQRooQpg7e--
