Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030735Ab2B2DeJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:34:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47281 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030660Ab2B2DeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:34:08 -0500
Date: Wed, 29 Feb 2012 14:33:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: linux-next: manual merge of the trivial tree with the v4l-dvb tree
Message-Id: <20120229143359.e983bed880aded7b8f99b6bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_14_33_59_+1100_TIHsBR_Mos_URQsq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_14_33_59_+1100_TIHsBR_Mos_URQsq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/media/video/s5p-tv/hdmi_drv.c due to commit 382d19f197f9 ("media:
Fix typo in mixer_drv.c and hdmi_drv.c") from the trivial tree also
already existing in the v4l-dvb tree (same patch different commit) (and
there are further changes in that tree to this file).

I just the used the version from the v4l-dvb tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_14_33_59_+1100_TIHsBR_Mos_URQsq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTZynAAoJEECxmPOUX5FEpEYP/1XwI3uLGt1fQDwTWFpUaTld
iSEruOr/4l5c+3AETGS4NX1Dn69yRMXmCM3o/g406Pbh2QtEd56J1Nr4WEjdX3wo
L+WSilP3znFEIqp50msl4momvysKargzlHknUBd7t3G3ULolqEJcWsZzTR8eyhZ7
CyO31esHbM2YNAPXPLqAMDuHK7wabDD1XNR6R15G6LZLKjuEbgvRDJeGB41rw47+
79q0HPoXMFkix/X9247f+fbxP8j8j9d+NU5d1f1aSUb06SuQm3+G0Pe5RIxuzW69
fyxx9NswrA0vK1cZzIc30+bP3V8MOIBQUmOcSlAnXtmZNK2uZLHjGlR6S93yNvZm
k/iYvUVtDx2+CbweNiWlQ/X7PDiHEV75Kv7eZxwb3804VEqA0AgrpE5jhrmMLQRn
dq2BQ7IyPg5MTuPF7oAETKnuLCVd8O+3Y2LHC77xJGZRkpgUX3imImxHH7pfO3//
mx4kYGfupZapy7KapA6Ezr5JFJ6HxaomJ9djw4mZ6F5l8Be40S5KOoGZqpzhh/y3
6T0R2o77ySrREfQMp8ZFh4FDqUUkUKVFQJ162Wm2SIDbolHZS8OyygA19SK4HXR7
s9IN73x13AEt9Auom0d709PtFscQydD/y1xcfDvPEB63wBfRJXHu0PPvM3bZknoY
QSIk10VtPNbflj39g+so
=czyc
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_14_33_59_+1100_TIHsBR_Mos_URQsq--
