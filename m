Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2HGHaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:30:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab2HGHaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:30:22 -0400
Message-ID: <5020C3EA.7010009@nod.at>
Date: Tue, 07 Aug 2012 09:29:46 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: artem.bityutskiy@linux.intel.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
References: <1341836323-43916-1-git-send-email-richard@nod.at>  <1343919530.25013.116.camel@sauron.fi.intel.com> <50200096.1070002@nod.at> <1344313269.1865.2.camel@kyv>
In-Reply-To: <1344313269.1865.2.camel@kyv>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE4384714B8005F2D6DD32325"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE4384714B8005F2D6DD32325
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.08.2012 06:21, schrieb Artem Bityutskiy:
> On Mon, 2012-08-06 at 19:36 +0200, Richard Weinberger wrote:
>> I think we enable fastmap only if a MTD device has more than
>> UBI_FM_MAX_START*2 PEBs.
>> Any comments?
>=20
> With double space one can make it power-cut tolerant, because you shoul=
d
> be able to have either old or new fastmap at any point of time.

UBI_FM_MAX_START*2 has nothing do to with the Fastmap size.
IMHO we need a threshold where Fastmap makes sense.
Technically Fastmap can only be used if a MTD device has >=3D UBI_FM_MAX_=
START
PEBs.
But does this makes sense? Fastmap was invented to speedup attaching on *=
large* MTDs,
The benefit in small MTDs is very little.

Thanks,
//richard


--------------enigE4384714B8005F2D6DD32325
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQIMPuAAoJEN9758yqZn9ewckH/jFyGnE0rgDut+Hx67jiHZSX
x19cMhHa8TOdlUmk9d+IYDRNlox8zmLe8wZRz+l60rkySPlbcc3atdtBUHOHxHm9
fI/LwoneJvnDxJuTVQw1KR9/Oc9ASFsz62Tha/FYMMqkvFDiGp+bL08r2dTOCs6g
697HICrVn0o3vxBuSRTyl7SGEe1JYRKGX9tTdZ0gjyb/6ZvhoIEWkBLeyU9+u7I2
xSFrFdo7Z51ZoXIIrn/u9GGhTOAXzOX2OsINgyCwy8AagH7TZ9zblcyr9AQtRykZ
2cT1Dott+OvJAaD3DwmRZzuE3uJiGzde3r7UukGW6j4vV+kdoB44DqkFlmTRZUk=
=e2tG
-----END PGP SIGNATURE-----

--------------enigE4384714B8005F2D6DD32325--
