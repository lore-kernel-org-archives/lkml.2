Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186Ab0ETBpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 21:45:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51369 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab0ETBpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 21:45:49 -0400
Date: Thu, 20 May 2010 11:45:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20100520114543.898f02c7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__20_May_2010_11_45_43_+1000_tdJMfi/O.1p4cNjS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_May_2010_11_45_43_+1000_tdJMfi/O.1p4cNjS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/input/evdev.c: In function 'evdev_do_ioctl':
drivers/input/evdev.c:596: error: duplicate case value
drivers/input/evdev.c:574: error: previously used here

Caused by commit ff2956560d97ccdd2c54cb9d0fdd7eb78c113ba9 ("V4L/DVB:
input: Add support for EVIO[CS]GKEYCODEBIG").

Please build test.

I have used the v4l-dvb tree from next-20100519 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_May_2010_11_45_43_+1000_tdJMfi/O.1p4cNjS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv0lEcACgkQjjKRsyhoI8z9/QCeJ5FHzDe6G3kGcezts9Vvodir
eggAn18jc9rcbluKjsfu8mv2yXl0T73X
=oIqg
-----END PGP SIGNATURE-----

--Signature=_Thu__20_May_2010_11_45_43_+1000_tdJMfi/O.1p4cNjS--
