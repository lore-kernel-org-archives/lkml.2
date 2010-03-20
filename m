Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0CTJdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 05:33:32 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:58267 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab0CTJda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 05:33:30 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, jeremy@goop.org
In-Reply-To: <alpine.DEB.2.01.1003200058030.5493@bogon.housecafe.de>
References: <alpine.DEB.2.01.1003200058030.5493@bogon.housecafe.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5dDxDhWm6jBG3MQ3V/TQ"
Date: Sat, 20 Mar 2010 09:33:22 +0000
Message-ID: <1269077602.28761.42.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.34-rc2: xen DomU not booting
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=W3tOLUehizD4qj6VhtReFuw5MKb8d+XqjIxlDsIazEA= c=1 sm=0 a=VwQbUJbxAAAA:8 a=y4SIFWps7tDG8s910BgA:9 a=kaKq-uZD5yrd7BEiL1GzOxGg8rwA:4 a=wPNLvfGTeEIA:10 a=Sa4oUCdbiRavKDJs:21 a=C3zsyzHwsrc6wsf1:21 a=IWuEwS1lsXtoGzHoj9UA:9 a=Zy-cH7wCqQY4Toj4O7BFPO7Woi0A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5dDxDhWm6jBG3MQ3V/TQ
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-03-20 at 01:14 -0700, Christian Kujau wrote:=20
> Hi there,
>=20
> again a bit late in the game, I tried to upgrade one of my DomUs from=20
> 2.6.33 to 2.6.34-git (tried -rc1 yesterday, pulled again today, so I'm on=
=20
> -rc2 now):
>=20
> ------
> dom0# xm create sid.cfg -c
> Using config file "/etc/xen/sid.cfg".
> Started domain sid
>=20
> ------
>=20
> Then it just "hangs" there:

Can you try this patch please, I think it will resolve the issue you
see.

https://patchwork.kernel.org/patch/87081/

> it won't return to the shellprompt (as if the=20
> domU crashed) but it won't connect to the domU console either (as it does=
=20
> perfectly with 2.6.33). And indeed, the domU is listed as running:
>=20
> dom0# (xm list sid ; sleep 3; xm list sid) | grep ^sid
> sid        55   256     1     r-----    140.8
> sid        55   256     1     r-----    144.3
>=20
> Also, "xm dmesg" is blank and netconsole doesn't work inside a domU, IIRC=
.=20
>=20
> Hints how to debug this (besides doing git bisect, again) are very much=20
> welcome!
>=20
> Oh, the Dom0 is Ubuntu 8.04 (2.6.24-24, Xen 3.2.0) on a Mac Mini.
>=20
> Thanks,
> Christian.

--=20
Ian Campbell

You!  What PLANET is this!
		-- McCoy, "The City on the Edge of Forever", stardate 3134.0

--=-5dDxDhWm6jBG3MQ3V/TQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkukll4ACgkQM0+0qS9rzVmM+wCfSzBT9FjRAYa71hbkTK/lTN0x
BL8AnRk3NzVLTgT0W9h8N+w/fkwZwX15
=Us2U
-----END PGP SIGNATURE-----

--=-5dDxDhWm6jBG3MQ3V/TQ--

