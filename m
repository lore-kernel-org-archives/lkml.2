Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab1LEHne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 02:43:34 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50301 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1LEHnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 02:43:33 -0500
Date: Mon, 5 Dec 2011 08:43:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Heiko Schocher <hs@denx.de>, Wolfgang Denk <wd@denx.de>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
Message-ID: <20111205074305.GA7806@avionic-0098.mockup.avionic-design.de>
References: <1322991921-21096-1-git-send-email-hs@denx.de>
 <20111204114741.GA5788@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20111204114741.GA5788@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:asnlBT70ZhSu9zt5wMhF9HWrwtB4DQnOYSQtyHOfR9k
 CyN3+Hs2YGdEgyrkXSBnT48Spklri2QpU1UPtlyue/5R+B8KmK
 0ImjH3b89D+vWcJUt0je/KDeV/O6kkS9a/Ukw0qpXAlBWW2VEq
 F32Ad5HrIgDCB6qIpAXTGSk82dGO2TRd5Ao+VnDAHVMJPvHkHe
 YPFDLUJJch79NzZ3QHkyKHxp7nWgUPFHGq6nE04YBSkzDoXorG
 ZpFZVvVQXQkRjuJTknOoK3VyfgdJM99cLxXHIJ/dAoahGW5M42
 /pXMZ5FvpahvnKwy11YxSzcmVj7XaGRBClTyEAkUgjSc13SyT5
 +3OujcUn5/oMY6OBUTxxY8SU2tzk3dFc6XTuwYPjrVNDpHFqYp
 mNnDWkWZSU5Wbpt0/6wfHmKTzasEISE3Gg6ItVgpq82AejhhkM
 JbMoD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Wolfram Sang wrote:
> On Sun, Dec 04, 2011 at 10:45:21AM +0100, Heiko Schocher wrote:
[...]
> >                   reg =3D <0x23060 0x20>;
>=20
> I assume that non-volatile memory would qualify as a boot-counter, so tho=
se
> could be tied to I2C busses etc? reg would not fit then.

This is not really on-topic, but in the device-tree the "reg" property is
used to encode an I2C device's slave address.

Thierry

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7cdgkACgkQZ+BJyKLjJp+5QwCfeX4ZaVA2ok1ZGKMt/jDI2X6E
fGMAoK5wU19BDYES7zSJ7/iBMfzg6VXD
=FRhB
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
