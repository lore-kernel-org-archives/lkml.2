Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab0CVBop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 21:44:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53942 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0CVBon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 21:44:43 -0400
Date: Mon, 22 Mar 2010 12:44:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Shane Huang <shane.huang@amd.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: linux-next: manual merge of the libata tree with Linus' tree
Message-Id: <20100322124422.4a10bc4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Mar_2010_12_44_22_+1100_hC7WG2ci9J.jgf3N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Mar_2010_12_44_22_+1100_hC7WG2ci9J.jgf3N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeff,

Today's linux-next merge of the libata tree got a conflict in
drivers/ata/ahci.c between commit
5db5b0215af94a36d4bf10900ff9707b6d5c1610 ("ahci: pp->active_link is not
reliable when FBS is enabled") from Linus' tree and commit
efd7cb719e07433588ee5c6a99b1208b0aff6295 ("ahci: Move generic code into
libahci") from the libata tree.

I applied the changes to drivers/ata/ahci.c from the former commit to
drivers/ata/libahci.c (where the latter commit moves it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Mar_2010_12_44_22_+1100_hC7WG2ci9J.jgf3N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkumy3YACgkQjjKRsyhoI8xAjQCfVEf66cR3hkJ5HiA44xXCtvsp
5R8AoKFAF2eY+N2um9jRBMoFhgNRdOV3
=up7w
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Mar_2010_12_44_22_+1100_hC7WG2ci9J.jgf3N--
