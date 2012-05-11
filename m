Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2EKLXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 07:23:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:64457 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab2EKLXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 07:23:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="asc'?scan'208";a="139467110"
Message-ID: <1336735603.2625.42.camel@sauron.fi.intel.com>
Subject: Re: [RFC v2] UBI: UBIVIS (aka checkpointing) support
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, tim.bird@am.sony.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de
Date: Fri, 11 May 2012 14:26:43 +0300
In-Reply-To: <4FACEEA1.9020400@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
	  <1336624000.1936.22.camel@brekeke> <4FAB7D70.1040704@nod.at>
	 <1336733182.2625.17.camel@sauron.fi.intel.com> <4FACEEA1.9020400@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uKZ1GFmsTuARIPv5WQMH"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uKZ1GFmsTuARIPv5WQMH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-05-11 at 12:49 +0200, Richard Weinberger wrote:
> Am 11.05.2012 12:46, schrieb Artem Bityutskiy:
> > On Thu, 2012-05-10 at 10:33 +0200, Richard Weinberger wrote:
> >> First of all, yes it's fully backward-compatible. It uses two new inte=
rnal volume IDs
> >> with compat =3D UBI_COMPAT_DELETE.
> >> Old UBI implementations will delete the checkpoint and continue with s=
canning...
> >=20
> > OK. BTW, these patches do not compile when the fastmap is disabled. I
> > hope you'll just kill the ifdefs in the next revision and this problem
> > will go away.
>=20
> It builds fine here with CONFIG_MTD_UBI_CHECKPOINT=3Dn.
> What error do you get?

If you are going to kill the ifdefs anyway, I won't spend time on this.
I have several defconfigs with different combinations of the UBI
configuration options, probably one of them did not build. Or may be I
made a mistake.

--=20
Best Regards,
Artem Bityutskiy

--=-uKZ1GFmsTuARIPv5WQMH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPrPdzAAoJECmIfjd9wqK0sZ4P/2GUvV81e/9GRO2XnP8vO+Jo
VxH48hrM88CLa/wQgHgnyOUxTZdC1wjD2wGKwlcubo9fcRxi+cCTwnmC3oTx1ocp
TLcQicqdXlrz81wYVD/tci7KcY6pPDiDaHOvU1gc/FAr1AX31CpNFIliJFfxDBoL
SJoIufIvF8yZbDRE9iQPI8XECHOXEyNTOBYIaio1ybPlR2wfNqxCvx9Twno+qxeG
fYASumSmFwh+2IkSkxTvfEVE6SpQZREe1Hlq+rpfExAswy2EMXdpqQPytd26V+Kl
5Qj4suh5pLK78AR32r0+yDDiUPdURT3d3A0jtQmf41E/SAciPOl2q01WCUUkPBM6
G4xgWCYKNwJ2Tgu+KwJb7G6YX0UiaXPxbvX2uei63qHDfJuHNEvbUQpi5fnQ9zdt
eNlYYBJjA6JIvZhzCVIGtio2lcLbgxYkFauShovqvoRFR9JV+UfEhj6Ez173w6P0
YY56RmirxgSUbbRjkZfnwEWTZbDLACg+PLOdTTUtuIV95Q8RcKj0b6QrFsrSg9Ca
Eew4HyqONnLgZvS5y6O2fO3kF3vH9tNQGmAx+ZM8UUJkU4mOEEOxSI6Sag7xnSeH
xqAzuVS0sj9hLSocrIuPguyJ8zoK3X6DGcKy54NFW7aj7sMRh1Cn3yWMJFEroDut
rbkrMYE4gBum6ex8GbQY
=qpob
-----END PGP SIGNATURE-----

--=-uKZ1GFmsTuARIPv5WQMH--

