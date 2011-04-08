Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab1DHD1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:27:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57566 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757375Ab1DHD1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:27:53 -0400
Date: Fri, 8 Apr 2011 13:27:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20110408132747.57085f64.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_13_27_47_+1000_bNnpd6VEArhkqytF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_13_27_47_+1000_bNnpd6VEArhkqytF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/media/dvb/frontends/drx397xD.c between commit 25985edcedea ("Fix
common misspellings") from Linus' tree and commit a8e8541bc7af ("Remove
the now obsolete drx397xD") from the v4l-dvb tree.

The latter removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_13_27_47_+1000_bNnpd6VEArhkqytF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnoCzAAoJEDMEi1NhKgbs7joH/0WZhkjqUZuncHjLqmvN0Yc5
1AOIVJtiT/nQ/5rrhAgZb31NVTKHPPnXwTmpd0gFUeHcMm/3Z7LV4x2AzlT+Fz/h
D/ur+qam4ueFCGO771Uq4JkzYzC0e3FM4dMR8R2Zsga/LAjYA1ITr1424FSc2iaH
WanzoF6iCT33dt/JpuLC61oIZTSJCQZr/Adtxc5+B93/9PP3AWMMXtnDKrdFko0E
r8LB1lsyY3kuSv7+ZFrEYgJyd89upBLj2FEOFwa2M1f/coc8d9XyK4IP5+jABTHL
1YBFm/5qPHfrYB6GK5en4Rwpb4C54AFJVPJZj7PAtob4w/8xfJoaYeZR0PaKxcw=
=tS1C
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_13_27_47_+1000_bNnpd6VEArhkqytF--
