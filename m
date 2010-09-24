Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750794Ab0IXED6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:03:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51872 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0IXED4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:03:56 -0400
Date: Fri, 24 Sep 2010 14:03:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning after merge of the tty tree
Message-Id: <20100924140351.b137a3b7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_14_03_51_+1000_lzP1KSf=rqrBT17P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_14_03_51_+1000_lzP1KSf=rqrBT17P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

drivers/usb/serial/ssu100.c: In function 'ssu100_ioctl':
drivers/usb/serial/ssu100.c:448: warning: unused variable 'user_arg'
drivers/usb/serial/ssu100.c:447: warning: unused variable 'priv'

Introduced by commit 20e2e6fa50180468e4240a91f811dca3a1c30304 ("tty:
Convert the USB drivers to the new icount interface").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_14_03_51_+1000_lzP1KSf=rqrBT17P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnCMnAAoJEDMEi1NhKgbsrg8H/idC90ArdvX/4qpuZ8UJescY
WzZVyeBf6AS47tWoYm5IUxZ1RA5Bl3Cd7/sUxptxsKUgfu0DIP/p8FEm+Fz3wFSS
C6kaoinm5oqrChl9aiDv8MA715/GuLtM8KHrHOcZq1sCuoq31Q9v4Tjk/4ebCLdN
uxmyj1E/XTmB9qPkF+/zuUn6OwoULJ/T3AS0lX+wMN1rlElwHoIZhVOOdtSawYO7
ENbMsXct7NUxpesCT63DJNzaMW7OLWpu1PanwZhgGiuyBAF4UZnUJWP+Z/8ho6Pw
C8Lrp0HRh6rdoebhRz/SN+YzPjkE5LBfd0W/aAwCfEUNJS22cQwrPvcpo5NXv9M=
=Fgt7
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_14_03_51_+1000_lzP1KSf=rqrBT17P--
