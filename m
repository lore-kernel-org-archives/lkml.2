Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250Ab2JXCno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:43:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46007 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab2JXCnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:43:42 -0400
Date: Wed, 24 Oct 2012 13:43:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>
Subject: linux-next: build warning in Linus' tree
Message-Id: <20121024134333.baf0c90a323a831675ed7e79@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_13_43_33_+1100_.BIS9EXZX21pVwea"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_13_43_33_+1100_.BIS9EXZX21pVwea
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the origin tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/media/usb/dvb-usb-v2/dvb_usb_core.c: In function 'dvb_usb_ctrl_feed=
':
drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:291:12: warning: 'ret' may be u=
sed uninitialized in this function [-Wuninitialized]

Which points out some badly formatted and blocked code ...

Probably introduced by commit 62a5f449cab5 ("[media] dvb_usb_v2: refactor
dvb_usb_ctrl_feed() logic").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_13_43_33_+1100_.BIS9EXZX21pVwea
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQh1XVAAoJEECxmPOUX5FEJj8QAJfoJjgacB899oqZE+2tx5ht
hmSvEMG9gaBC+zU8f8Bqyz6Iaiw2jkC9NncO/6NzW+ePWyyyakYuFYWzoLurAEBu
Tzp+bdhUBGF5yQ7D2eEGRWg/0oIuN7YNsJuQTrvSz4ySJwm/cQDIakhW0Wg4P5pn
yVZkLD7/SLeUSQPpsKhCIUyK6O29rgjDZ6S4XmaUr4FEcR4JKIXmoNSQ1Ca3GFP8
j7lVykjvcJjfq4E7Q6vhGPYoBRDZTKa2KR/DMXQs+J7gDcy7mJlHjqsGSL6Rmztu
+Tr5nU1/vug2NTEU2hWWlpN9Yphn2dJ9G9LeDjua4pXAo0sX1+x4gIMDrnUI0Wh6
4WQNqRjuU0M53GCaQn5IWT+J+CUEiDfn05F4NbZ0s/nYYjR5MuZEIxpv8Qx/bUht
TPBdQ1tDrSo+3ZLDIi/ZmZtQED3cHBTyO5bqBrE2VEWYCl2KaQMs1GGKZr4joric
lKnjjdw274g7WAkiO1/ms918RTjBew5zGAM2mRo0UEsqaKDd/i4RWkbyZjfv2YM9
PglSulsBTj7c+zBV6H4pNh1XtzgOi7e/+8He5iOIqp/m4UJrcRSZhQlbg2YfG5c7
RRIOnL9Jaw1BHRrNkiJSAAzGU91UvP0jWFELwHXuKM9QUVh+0gop3no5BJx5Mx46
rmLW5seCnnexVt6H2wSH
=Yvk0
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_13_43_33_+1100_.BIS9EXZX21pVwea--
