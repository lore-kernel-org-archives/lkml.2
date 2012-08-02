Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab2HBSwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 14:52:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:16710 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053Ab2HBSwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 14:52:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="176299290"
Message-ID: <1343933794.25013.225.camel@sauron.fi.intel.com>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com
Date: Thu, 02 Aug 2012 21:56:34 +0300
In-Reply-To: <1343933454.25013.224.camel@sauron.fi.intel.com>
References: <1341836323-43916-1-git-send-email-richard@nod.at>
	 <1343933454.25013.224.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-qPGcdnox6LYTFvGcGUhP"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qPGcdnox6LYTFvGcGUhP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-02 at 21:50 +0300, Artem Bityutskiy wrote:
> On Mon, 2012-07-09 at 14:18 +0200, Richard Weinberger wrote:
> > This is the next round of UBI fastmap updates.
> > It fixes all issues pointed out by Shmulik. :-)
> >=20
> > If you want to test fastmap you can use my git repo:
> > git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git ubi2/v17
>=20
> Richard, would you please rename the 'fm_auto' kernel parameter to
> "fastmap_auto", which is a bit more user-friendly.

Sorry, I meant module parameter. Too late, time to go home.

--=20
Best Regards,
Artem Bityutskiy

--=-qPGcdnox6LYTFvGcGUhP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQGs1iAAoJECmIfjd9wqK0HicP/1vhqzKhdDhzzgl/TiuF4imo
RbtBMUuevV5YtBu4FBJpFURG0oNuD1kaIqG5aDQQ8SfIfCVPAvURiC0eaEdVBNY6
ZYUoMpIs2snbpOjl01Ep4I4XNmnYxAfHtl40DIduud5aPakIi4PxSJowzSFKImXa
2Bky8bkE5SMkJX/BpDhGhtOTH9qYJf6a1gWHO4+n9m1XxRAJq7bJMZjVPrPXVHy9
35zJOU+DXvwJZKvHH+ug6cbotfeSJt8m2qU8lAhZmDHEtuzIHJuJUEKraRvNORGs
PafkpD637IQB3DxM+FG7O3ybZqsc2GS/0WlVyrBu/FJKeKl6vRoi3tCbnQHNLJ9h
20ITa5fHo6CJg3UoHx5SCOD2h4XNVJRefzq82LGGt171npO/cUEBNijyjnhAVpW6
BRMGVaQaQs3YAEBTf0S3T7n/aEaDNQWtDUYy1dMpOtJwMsy/DUSc9VOv0MU6Nmoj
x8UZbXbxDgiq6XsGBbJgbgCeHNW8tQvb2jS8uEShFv6GQsw1i2Ed4NakRORYiJS5
r+xZ0RYgOmnM9QBwUsnPYcXa38X76jPxfr9qxx2C/PdKN/nUWmLiNlTYo4eRaCnf
h9CcSxXPU1AIDfcXoL03a3eEAsAC5Q/ateZzN8ZM4zyzUA43Ve3v30hNkCHeGMgA
VBq/9tOdMNI3MFV+xZKH
=kNP9
-----END PGP SIGNATURE-----

--=-qPGcdnox6LYTFvGcGUhP--

