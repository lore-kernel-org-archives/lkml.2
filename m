Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab2GKFuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:50:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:31441 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2GKFuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:50:13 -0400
Content-Type: multipart/mixed; boundary="===============0525055118=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="166601965"
From: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] of: mtd: nuke useless const qualifier
Thread-Topic: [PATCH] of: mtd: nuke useless const qualifier
Thread-Index: AQHNXqDroSWSETrlh0y8z1k3KAfUgpcilTGAgADvwIA=
Date: Wed, 11 Jul 2012 05:49:06 +0000
Message-ID: <1341986003.2963.102.camel@sauron>
References: <1341927604.2963.101.camel@sauron> <4FFC4BB5.7040604@gmail.com>
In-Reply-To: <4FFC4BB5.7040604@gmail.com>
Reply-To: "Bityutskiy, Artem" <artem.bityutskiy@intel.com>
Accept-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.155]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============0525055118==
MIME-Version: 1.0
Content-Language: en-US
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-2gLJaNXN8MphCsg/riBB"

--=-2gLJaNXN8MphCsg/riBB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-10 at 10:35 -0500, Rob Herring wrote:
> > Remove also the unnecessary "extern" qualifier to be consistent with ot=
her
> > declarations in this file.
> >=20
> > Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > ---
>=20
> Applied. Next time please don't PGP sign patches.

Thanks. Sure, I'll try.

--=20
Best Regards,
Artem Bityutskiy

--=-2gLJaNXN8MphCsg/riBB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP/RTUAAoJECmIfjd9wqK0iT0P/j/GrIUIzMIU8Q6370sIWPqc
QCt94W1Vf9yK6A0Z8cmCdozD2sbBCHG+eEi0YbhcVoF1u4i2povQVNYr0KwAA9IV
z7z8Ql3Js78Jjlf41DmpWlHF4u/ufoP6QIsALqD/Fu8+qCTWHnp652hCrMZ5Me7+
5edr1qHCyZjVx8Ma6k85emOgnPOdel8UZq1/oc4y3hDN60TrDLilyxoFHkeNtqGB
SnZ4ZitEvonb0yZOGi7GhuqV9tQvid+rg7sjDeRyoK9V8Hnfo/jV3mrKahD7Vi8W
ThmF3wZTQCN9QNhqsLBDNmPqQs9el0C2aTDN6YET62TD4PXEZjnK+02TMgSYejrX
iCg1gQ6Msc5I8y70QpBacx8ZBrSBsZdZ6Xb/IpeoQUwfXqGb08HWX8wCuUXQ/RoZ
MbjdMqtNieCvE0krGslsE4A7uOzG3y+5CQnm8R3Aqoti8D6x6Frwlbl2UWG/WuEW
6Jm3krIK+l4ZpQdDGrUWwBZYrYlpOgg0FotaL0ZhAZYKAdfazgE++8ExE4f6hjhv
g3Gw7U9oqZdHoPJKXHlx9nHEaKSZixl5B/3GOi3gfBmrsCWPT7+cMNmo0G62ywnv
GRBAv6poVS+bVrFmAdnP5GEM1yuFUDOlWF8FcH6zQj4N30L7+QiULFaNuJ5eQMN+
80ECuCtZ/o4ZLmKhPWqM
=6CNM
-----END PGP SIGNATURE-----

--=-2gLJaNXN8MphCsg/riBB--
--===============0525055118==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel Finland Oy
Registered Address: PL 281, 00181 Helsinki =

Business Identity Code: 0357606 - 4 =

Domiciled in Helsinki =


This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============0525055118==--
