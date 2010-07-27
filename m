Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0G0Bss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 21:48:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49425 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab0G0Bsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 21:48:46 -0400
Date: Tue, 27 Jul 2010 11:48:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        <linux1394-devel@lists.sourceforge.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the ieee1394 tree
Message-Id: <20100727114839.06d25309.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_11_48_39_+1000_KR6DasizNe0Bh+Ss"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_11_48_39_+1000_KR6DasizNe0Bh+Ss
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the ieee1394 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/firewire/nosy.c: In function 'packet_buffer_get':
drivers/firewire/nosy.c:154: error: 'TASK_INTERRUPTIBLE' undeclared (first =
use in this function)
drivers/firewire/nosy.c:154: error: implicit declaration of function 'signa=
l_pending'
drivers/firewire/nosy.c:154: error: implicit declaration of function 'sched=
ule'
drivers/firewire/nosy.c: In function 'packet_buffer_put':
drivers/firewire/nosy.c:221: error: 'TASK_INTERRUPTIBLE' undeclared (first =
use in this function)
drivers/firewire/nosy.c: In function 'remove_card':
drivers/firewire/nosy.c:514: error: 'TASK_INTERRUPTIBLE' undeclared (first =
use in this function)

Forgot to include something?

I have used the ieee1394 tree from next-20100726 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_11_48_39_+1000_KR6DasizNe0Bh+Ss
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMTjr3AAoJEDMEi1NhKgbsYCQH/2cQ8xx10c+ZcwyVzQgsBpY7
eaz5EzSkH89R54zaEyn+PnQCq/VSAxC7ZpRL1SMfbhks9qhmhA6ntHEO5PBZgRg3
0gZYDMIqzCqbvtxwiSzj7KvLybi3M/+vSZ3yz9KOUqTYn7fKCZj195eTciPPwtHi
HE8wDL5KHOS9AIhlR2xynwuqCaco0AJS/9kz+ZL8D2OCxJNAJX9ew5eBXgqDODBH
8TEMo01rRZY43Sh19OB53XbxvT9/Hd8IRBzhMitjyqpCWOzk/rtRGK65xXEo0QpS
UMNr+7Rxm+ZIiD3UZuQRQXP/Brr5hYrcY7oQdS7BoiWW8fgYVNJaYWVBG7ibjPw=
=McMz
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_11_48_39_+1000_KR6DasizNe0Bh+Ss--
