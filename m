Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab2JCLSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:18:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:40515 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab2JCLSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:18:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,527,1344236400"; 
   d="asc'?scan'208";a="219027859"
Message-ID: <1349263132.2017.146.camel@sauron.fi.intel.com>
Subject: Re: UBI: Fastmap request for inclusion (v19)
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Heinz.Egger@linutronix.de, tglx@linutronix.de,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tim.bird@am.sony.com
Date: Wed, 03 Oct 2012 14:18:52 +0300
In-Reply-To: <1349262302.2017.141.camel@sauron.fi.intel.com>
References: <1348674710-102885-1-git-send-email-richard@nod.at>
	 <1349252745.2017.120.camel@sauron.fi.intel.com>
	 <20121003103625.0bbff63c@spider.haslach.nod.at>
	 <1349262302.2017.141.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gjhI6O/WTmK76RQgabAX"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gjhI6O/WTmK76RQgabAX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-03 at 14:05 +0300, Artem Bityutskiy wrote:
> On Wed, 2012-10-03 at 10:36 +0200, Richard Weinberger wrote:
> > Am Wed, 03 Oct 2012 11:25:45 +0300
> > schrieb Artem Bityutskiy <artem.bityutskiy@linux.intel.com>:
> >=20
> > > On Wed, 2012-09-26 at 17:51 +0200, Richard Weinberger wrote:
> > > > UBI Fastmap is an optional feature which stores the physical to
> > > > logical eraseblock relations in a checkpoint (called fastmap) to
> > > > reduce the initialization time of UBI. The current init time of UBI
> > > > is proportional to the number of physical erase blocks on the FLASH
> > > > device. With fastmap enabled the scan time is limited to a fixed
> > > > number of blocks.
> > >=20
> > > Aiaiai complains and linux-next build fails :-( Last time I forgot to
> > > enable the fastmap kbuild option so aiaiai checked with that option
> > > disabled. Now I enabled it with a simple hack (default n -> default y=
)
> > > and here are aiaiai's complaints - there is a build failure for
> > > ARCH=3Di386.
> >=20
> > Build fix for linux-next is on the way into your inbox.
> > I'm currently looking at the aiaiai output.
>=20
> It did not help. I still get:
>=20
> ERROR: "ubi_update_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_scan_fastmap" [drivers/mtd/ubi/ubi.ko] undefined!
> ERROR: "ubi_calc_fm_size" [drivers/mtd/ubi/ubi.ko] undefined!
>=20
> Please, see branch 'linux-next' in UBI to see what I actually tested.

And aiaiai has another correct complaint:

+drivers/mtd/ubi/fastmap.c:1078 ubi_scan_fastmap() warn: possible memory le=
ak of 'fm' [smatch]

--=20
Best Regards,
Artem Bityutskiy

--=-gjhI6O/WTmK76RQgabAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQbB8cAAoJECmIfjd9wqK0S7MP/0WwCg+HTRQL15C2dWosSkyO
g3L7X2j0y4DD0YyveF7iFFlsGwxOPoZ5GfnRbrwlwJZ/hozcH2yRuYOVDbQ/O+MM
ynfTXbMGcV992jBhXEKOmqEg61awdZ3wABSjoRLCHcVojNf0NSmGKhRhDimG2SlV
tKVzrvOZ4efdAd4Yt/ZPKMSaqOHfWDXJ7A34BGOU6V/9OrXamTqSIi8B8GXWtFvW
c1hzoiwU88QPOpAo36yD2WQ7clz5145pfLza80ToptfSykZbJ/MuWCnyS6D4Xsdv
MDuSlQXgZi3kdWxLiuXNM19bgJ+lQugAGGfVajSxzwO1ljHH8awaoRlHH5dQRr5e
sbI1u5IOK5J3BRzLCKznumM/lg4isvhWN/5lBjK2LsyQoQjangQf5o/9JYYVf8jg
Feq5/QG7/FJavT8MDae6czttvVdtbl3+EwXF17S3CIJYqTnQ74vbBWxQpETVxkiS
Sv3wRlElEBwIU+NMc9iLgEF9SvXBqhGlJj/gofJN4d0zzMWOB3qZ1TqQvxadfqpK
nmXmZ09Ch9nB7WV3aEoFGBUQ5a1Yu+W/O9juRWiocVjzeA1GpAGgP2azDddKPWGf
HKamvr051OwrQPUFuY3C05tmfL9f1DgfDk3sRsVnHwIAotQ94FhdJGy2hG7SXq4q
CkL/FDJY34iL7yEX3JLt
=yyia
-----END PGP SIGNATURE-----

--=-gjhI6O/WTmK76RQgabAX--

