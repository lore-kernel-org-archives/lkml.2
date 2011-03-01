Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1CAEml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 23:42:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1CAEmj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 23:42:39 -0500
Date: Tue, 1 Mar 2011 15:42:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build warnings after merge of the mfd tree
Message-Id: <20110301154230.df32be17.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Mar_2011_15_42_30_+1100_soykBIbCO58_B0Rx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Mar_2011_15_42_30_+1100_soykBIbCO58_B0Rx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/video/tmiofb.c: In function 'tmiofb_hw_init':
drivers/video/tmiofb.c:270: warning: initialization discards qualifiers fro=
m pointer target type
drivers/video/tmiofb.c: In function 'tmiofb_hw_mode':
drivers/video/tmiofb.c:314: warning: initialization discards qualifiers fro=
m pointer target type
drivers/video/tmiofb.c:314: warning: unused variable 'cell'
drivers/video/tmiofb.c: In function 'tmiofb_probe':
drivers/video/tmiofb.c:683: warning: initialization discards qualifiers fro=
m pointer target type
drivers/video/tmiofb.c: In function 'tmiofb_remove':
drivers/video/tmiofb.c:811: warning: initialization discards qualifiers fro=
m pointer target type
drivers/video/tmiofb.c: In function 'tmiofb_suspend':
drivers/video/tmiofb.c:941: warning: initialization discards qualifiers fro=
m pointer target type
drivers/video/tmiofb.c: In function 'tmiofb_resume':
drivers/video/tmiofb.c:973: warning: initialization discards qualifiers fro=
m pointer target type

Introduced by commits 2a79bb1d72f5ac22dff96de340d90d512f852ecb ("mfd:
mfd_cell is now implicitly available to tc6393xb drivers") and
b6361637190e6cb7acb84509499942ada69e7136 ("fb: Use mfd_data instead of
driver_data for tmio-fb").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Mar_2011_15_42_30_+1100_soykBIbCO58_B0Rx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNbHk2AAoJEDMEi1NhKgbsYRsH/jCd5Hr3XqDG9k0R7lCxTZbS
S55jZiPqQyOASWWzwNajxyGmXVxBcAcsHmxeeRcQ9Gu/tVDkUdqbOzeskDDSnGKH
q0PXzW8pjOmg0qHzcWrTQ7oojlrWrhkjNK1lnIjS8Dnpzg9CF5cHPJ2/kHve0We8
vyq6HRD8KFEUJq1br7DYEYimefyoF05IcsBnNB1sXMrGIZePjULY0MyL5NaO0zt6
2OvAYLfAbC3or0YIpRzZ7SCpxC5qhILRcamo2CO309fwDiPoHJukixbmtsP1GX8u
qNgi25xw+W1UWYMbpoyfGmR3waye8PRb1aaubBx8180MEKZjXWj8FTODmU9cFjw=
=m03S
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Mar_2011_15_42_30_+1100_soykBIbCO58_B0Rx--
