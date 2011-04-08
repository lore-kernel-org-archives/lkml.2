Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1DHGAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 02:00:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60335 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab1DHGAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 02:00:10 -0400
Date: Fri, 8 Apr 2011 16:00:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110408160003.acedc024.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_16_00_03_+1000_zxaYybOqIEkGIkkF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_16_00_03_+1000_zxaYybOqIEkGIkkF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/ath6kl/os/linux/ar6000_android.c between commit
25985edcedea ("Fix common misspellings") from Linus' tree and commit
8efba264d45d ("ath6kl: kill Android specific code") from the staging tree.

The latter removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_16_00_03_+1000_zxaYybOqIEkGIkkF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnqRjAAoJEDMEi1NhKgbs1qAIAJ3eaxTpujl7kEryXHozli6o
olId/36I3pm/v6G51PEPBaHPFvq3QKvitIUx5Wrx9RtPn+7v81aTL5UeKxMk5PwA
vF3+T9AubBTA4d0y6EiS4QtrZuquN92hb69z5ebSpv8ZjS6AWVq+pe1F8P4mu6CK
pvF+smWZ25CH7Q01f1j2K9V9oshfcpJTUZLh1CwdgD6usb+qEFrprmMvkN5Rsu3D
YCgl6NyYG1h5mAdwgIfZ2D0B0KT2+uFFeWrAy59ua+PykqhQtLsfZccTMZvqrsvO
1sfK1acF0Vhlkk8kKCln9D7jiMCOK+eRJmCbspWOr6vMUya+RvKwI+i1HpOGAGI=
=Us78
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_16_00_03_+1000_zxaYybOqIEkGIkkF--
