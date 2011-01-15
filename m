Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab1AOBFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 20:05:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59136 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1AOBFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 20:05:53 -0500
Date: Sat, 15 Jan 2011 12:05:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: linux-next: manual merge of the xen tree with Linus tree
Message-Id: <20110115120544.98a1f091.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__15_Jan_2011_12_05_44_+1100_lVrfyAeP.knEwynh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__15_Jan_2011_12_05_44_+1100_lVrfyAeP.knEwynh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen tree got a conflict in
drivers/xen/Kconfig, drivers/xen/gntdev.c and include/xen/gntdev.h
between various commits Linus' tree and various commits from the xen tree.

As previously discussed, I have dropped the xen tree for today (as it
contains an older version of the changes that were merged into Linus'
tree).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__15_Jan_2011_12_05_44_+1100_lVrfyAeP.knEwynh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNMPLoAAoJEDMEi1NhKgbsHWQH/0YoS5Lw23JD28G2FK0wpVbI
+aBXmAVtwQU96W1OD1BKy3QDxmSJ7an5s5YOm1wDnKGb8esXSfOm8DoQfxYbZe7b
iFx57F9QT9h8qaBQZtRjcxj6tADnWIHG61b4ObPNjgM8eXiQAU6OMSFEnBOUb8v5
a94LElKhT0tPMOadZQ9A4fxtd8juC8iuuZXyvlSf2jni/LwjdEsfyU1FAHWOdZtD
W5qpJU/2InmlySguY3eUATtzegHkWqO7S9e0gQ2VKwsvclFZsRG0+rLlsa7vELGk
JicdqxHhnwcoOaHEj5ugMnDxuuuU6PjJdBc07jbg3VHPgKCv4wi2FpdqcgCoopE=
=VWs6
-----END PGP SIGNATURE-----

--Signature=_Sat__15_Jan_2011_12_05_44_+1100_lVrfyAeP.knEwynh--
