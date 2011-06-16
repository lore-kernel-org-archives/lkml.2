Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1FPClH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 22:41:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1FPClF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 22:41:05 -0400
Date: Thu, 16 Jun 2011 12:40:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the sound-asoc tree
Message-Id: <20110616124055.520eb947.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Jun_2011_12_40_55_+1000_VDGwzUN6.yx45y2."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jun_2011_12_40_55_+1000_VDGwzUN6.yx45y2.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree failed badly.  It seems
that it has been rebased on top of next-20110615.   You cannot base a
tree in linux-next on linux-next itself!

I have used the version of the sound-asoc tree from next-20110615 for
today.


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Jun_2011_12_40_55_+1000_VDGwzUN6.yx45y2.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+W03AAoJEDMEi1NhKgbsuFYH/1q6xNqrgCmEwbdx1gUi9dVa
kSca289uwdG6OjpRfK7X+GN2vUYoG0rBeTbajmBH0lrfjkx7AdVc0KDVcnupbj8g
/9IfLPYSTLwYaDj0RBD3WQgJ6oUSFAYdF0MF2XY1PeowVvjoSBlP0ydr1oV87ZjI
+kLGEnhqo931OwR3kNc1HpYtA8oB3G4pZX1FQIjNW9a9v1PoWEA/nxM6RD06z72F
NpVx4uOsw7HP7dvB8LtlfUpDXmgXmgTvjUwSk6aizTDlHyrDJFT1eTpIPYWnXCcS
p+vCEwJRirlnASenoEPZJ0Oc4eut+7XgKnrEkB/Y0y988HdUmzM6Q6b6zPsUqqU=
=YmQO
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jun_2011_12_40_55_+1000_VDGwzUN6.yx45y2.--
