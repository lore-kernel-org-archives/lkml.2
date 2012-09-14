Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2INMa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:30:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61752 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab2INMaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:30:24 -0400
Date: Fri, 14 Sep 2012 14:30:18 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Julian Andres Klode <jak@jak-linux.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ac100@lists.launchpad.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: nvec: Update for recent MFD core changes
Message-ID: <20120914123018.GA5709@avionic-0098.mockup.avionic-design.de>
References: <1347623064-28348-1-git-send-email-thierry.reding@avionic-design.de>
 <3024745.a3O1qxCH7D@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <3024745.a3O1qxCH7D@fb07-iapwap2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:LXhTb1WXQqI45PZAhm5J018A1tE9mTkJDsnfwJFwb/M
 KGDQRPPa7OS/HrcmBz5LLTmOQZsMG9DCZDQtOCpZKf0Kp0HZ60
 +UyJSoWYJ9quYusSF0tbbuO/773lgkbPqrM4Ne4p4+4R6XGUV4
 prDPAvoGJ963B0GIKCCx6EA2BxBABLF4rzkFqk6byIDtxhHpki
 k7CodkDEwxBa4Z/BSPuo8CXjglwzOsKleL84+o/5QO6Lrrt86j
 cPXIV1N49d0unig5s4tC2bKIpYW4CneSFTOeEDAiB7jL5avtBj
 8rWdmE3l/g0N3rKF8NmIEQbthZ5xTtUQv6cTpLTD2ZvVOxuZ6u
 V8fFae4Za8F5O7rN4ali4GjJFqLmeAkSdzoIhMHWAOtkq/7pnV
 sgI8WcLWrC0Jj8NdL6KENk4TumZGh/7TSXYebokc3bCCP/EKQE
 Jzot1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 14, 2012 at 02:25:53PM +0200, Marc Dietrich wrote:
> Hi Thierry,
>=20
> Am Freitag, 14. September 2012, 13:44:24 schrieb Thierry Reding:
> > mfd_add_devices() was recently changed to receive the IRQ domain through
> > an additional parameter but this driver wasn't updated accordingly.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > ---
>=20
> this was already kindly fixed by Stephen Warren a few days ago and will b=
e=20
> included in linux-next.

Okay. It wasn't fixed in next-20120914 so I supposed nobody had taken
care of it yet.

Thierry

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUyNaAAoJEN0jrNd/PrOhsoYP/i5U/n7dlhS7WrcCvcWG3KL2
C7DkvVQ4XzmxpAOJq50LrP8RHXkJJaoGrsJmnIVcWhIJ9VFU2C24CkAkFDg3dUR7
p1Zle/GY5k4/d/IJQ6Z86xmPEPichFNKcgXYWWBJXxze8/SGJYRS5zG9lwQpXi8Z
Iu76s94HlruADgpcRKLkXwgclXWZbpcjn8rPl53LqRuY3GWI+Alscc47ilHguN/5
j53pMhyYT6O42iw4iyRhJ4O+T8PkGWT9cjpX7/lEUtsemgPLyDTwyOZG5yG949El
RpqvVLLRBw/Pi3za2S5mRtBDgPmVmX2gRsdxQrZJdorOnKIFx/SwqYqrZeRTJHCQ
6E2MpFC8DEq8D+knKTjJxxNuiGzucGCMwpAJspqTe9m3M1e5ty0zuqECezSZ62Df
yJPTJUkGMY1Xwijv+WszMKBbWs8QYBZUHfOHOmthkoC8ji58cNoMMEdZnRH5xkLO
Izm/iqPbOD1dzFl4Fxd7Z7V3euZursS0qqY32E56Ubhx+BOrKy9poC+8TaQP7NYM
Lqp344yPjHCZJYdRJXFw78WFXonfxWEfERXQB3nDGHSt2+S9nqkIDzftQpg78Npl
nPtrzb6gUw47EFP4uuVXzWx5JU/lyeUU5q2SAWwdLiKrYIZOh2QIXgfvqEEceO2o
fydbGhdxE5IybZM84j01
=vdvv
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
