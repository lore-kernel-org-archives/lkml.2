Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0LQOFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 09:05:04 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54971 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813Ab0LQOFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 09:05:02 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Joe Jin <joe.jin@oracle.com>
Cc: Alexander Indenbaum <baum@tehutinetworks.net>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Guru Anbalagane <guru.anbalagane@oracle.com>,
        "greg.marsden@oracle.com" <greg.marsden@oracle.com>,
        DuanZhenzhong <zhenzhong.duan@oracle.com>,
        Jaswinder Singh Rajput <jaswinder@infradead.org>
In-Reply-To: <4D0B0B70.9050306@oracle.com>
References: <4D0B0B70.9050306@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-94asVg22sjK3uZxD82im"
Date: Fri, 17 Dec 2010 14:04:51 +0000
Message-ID: <1292594691.3136.840.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [NETWORK] Firmware file for tehuti
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-94asVg22sjK3uZxD82im
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-12-17 at 15:04 +0800, Joe Jin wrote:
> Hi,
>=20
> Regarding firmware for driver tehuti, it request firmware name is
> tehuti/firmware.bin,
> but from kernel source found no such file but have tehuti/bdx.bin.ihex,
> so the firmware
> should be bdx.bin rather than firmware.bin?

Yes it should.  I'm sorry for this mistake.

My first version of the patch to use request_firmware() used
"tehuti/firmware.bin".  I then found Jaswinder's patch at
<http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=3Dcommitdiff;h=
=3De41f3e5f8c5110871e376a2566b8eea2932b813b>,
which used the name "tehuti/bdx.bin".  For some reason I changed the
name of the firmware file in my patch to match that, but not the code.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-94asVg22sjK3uZxD82im
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUATQtt/ee/yOyVhhEJAQKnLRAAhvuSCM5RQv9mIzQVgsJQ9LG70puJyXXd
qmne/ZGCNwkFdLO8RU6//RjFWRTYLIDP4pjzhUflT6Y5HnD0HS561uWWwEPuqY2w
+hR3DbpvX+ck0qGs/Ye4+dZPkI0jEDDA5mpb7Mbsdsszd2/86b2fzbyT6mFHseQe
RhjW+L4xYZ/a2UYZAcls7NpJMGysY2f7t+osR8oJyjiYf/croT9lSe69FFDFNdGK
3moML8/sGkwW9fqMFX8JON4C93KVjposGxsEbMTIBOZzmtzV5cHdOKwAZEiQYdyi
Qf4iHHqRWnxr4+H6dMpLmdV/Q7OUw+DIUVV9dfeMS6jt1Ux2sCs6Lx7vbr3Fsz8L
QfshLAASFWZNE+mWiL8bTS6MQ5ReXAwXvCX+AtN03en71KZy7D3sWcH30Lv1jhP0
fNMU6m/yxDfjgPqkTD4JqExwR1UsHOWjxLUHcfPvlWr+Yq4Q6vREGXeiarwPWL69
bQAd3YP88AxGjHoZXVzergbb4Luyvb/0N02mlnG0OjUK217a8LB7M/EGEj94F8Ui
Vri8B0vf5DtmbTDlnmEwJtXRoyofJw2gN9aHmFu8L10VIbM1Slj+zVosVdvUrKOd
7ygZlmbvKC1YMclq0UxhaWrctfRdcmfNzjyUYlzV77RqNajzCTPE0wdP+H1v0/6a
OLP0snWvQEs=
=kLdW
-----END PGP SIGNATURE-----

--=-94asVg22sjK3uZxD82im--
