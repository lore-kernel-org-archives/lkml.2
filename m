Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1LBUuD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:50:03 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:47980 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1LBUuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:50:02 -0500
Date: Fri, 2 Dec 2011 23:50:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@susse.de>
Subject: Re: [PATCH 1/5] staging: vt6656: datarate.c: Use memset instead a
 for loop
Message-ID: <20111202205026.GA3195@mwanda>
References: <1322783915-19570-1-git-send-email-marcos.mage@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fowzm2eVyDiEwGH"
Content-Disposition: inline
In-Reply-To: <1322783915-19570-1-git-send-email-marcos.mage@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090204.4ED939F3.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fowzm2eVyDiEwGH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2011 at 11:58:35PM +0000, Marcos Paulo de Souza wrote:
> As Dan Carpenteder suggested, this makes the atribution more simple.
>=20
> Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Normally I wouldn't get the Signed-off-by line here.  People can
only can sign things for themselves, but in this case it's fine,
whatever.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

--2fowzm2eVyDiEwGH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO2ToSAAoJEOnZkXI/YHqRFgsP/3vV1nTX8jYoX8JCLJE5o4Jp
SyEmzjbfNJlA/1kkynDZgd4oHx1ftKQDW2zDLEQsGrSYAVvrGW3KDFh9YWpNCw8w
vbZa85+r3s/027G2dar4YVl7pCRH1pUtx6LIfk9cr2isN0neCXYblRAD3Y0qhHMi
ohANf379lQuNnFvZYi3LeqyzbMGif9oU4C8lPbB91yMIDbx1p+qtmG7Fm1rApLG1
Uuy1OA27ZX6l+phn7QCXPvbTK/GHFuWGXEGiBwhrfptxuDpjCv093m9Jcu/lcYS5
eBGHswcc8G82i4JXwu+Y5lZnP6fipOe9tuypJIa1c8HTyf9ykTsqQIAmLhn7Uijm
VoyHdRuAVDTNlqerMo5aQ5UJb+7Rj+DNnGjgElS5M8tmKFHTQG26PEsRbOAupbhb
QkB36af5uXYcgCBf/hGloMzFXmJwkYJaeLL71wiQhpHjZXyEUWs2W+wNtItADZuo
JQjioJDx5uEN7rdQHfb6qdELE8tVu4DkIlIeMZ3NvKqSSFGI599l3b2FH2ruN60e
z1BCK8Rdf62lY3ssP8N1mAyHz/liIng8Qsaxah8CfqccwIWFIzD13/Q1A8PCa4Xj
QIw+++3Nv85Wdy41/+IvmfkFmwHvtjWdwJRLsT66+jB677eq36DyADlGUQSTDx2h
XdID2NAm3r8ni1j9C0LS
=L3j6
-----END PGP SIGNATURE-----

--2fowzm2eVyDiEwGH--
