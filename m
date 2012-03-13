Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab2CMMg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:36:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:56419 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2CMMgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:36:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="128416977"
Message-ID: <1331642368.3595.31.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] jffs2: Convert most D1/D2 macros to jffs2_dbg
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 13 Mar 2012 14:39:28 +0200
In-Reply-To: <1331572270.13200.30.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <2d68e76db16d42f451370714f03ef952e0839692.1329349881.git.joe@perches.com>
	 <1330965033.7220.16.camel@golum> <1330966615.3140.6.camel@joe2Laptop>
	 <1331294012.29445.10.camel@sauron.fi.intel.com>
	 <1331318968.13055.8.camel@joe2Laptop>
	 <1331557935.12037.11.camel@sauron.fi.intel.com>
	 <1331566415.13200.14.camel@joe2Laptop>
	 <1331570150.12037.55.camel@sauron.fi.intel.com>
	 <1331572270.13200.30.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-fYOsaZgv7ryuBzSawbPD"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fYOsaZgv7ryuBzSawbPD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-03-12 at 10:11 -0700, Joe Perches wrote:
> On Mon, 2012-03-12 at 18:35 +0200, Artem Bityutskiy wrote:
> > On Mon, 2012-03-12 at 08:33 -0700, Joe Perches wrote:
> > > I tentatively converted them to a bitmap
> > > and a single jffs2_dbg(mask, fmt, ...)
> > > but perhaps all of these could be deleted
> > > too.
> >=20
> > I think it is better to convert them to jffs2_debug(). And I guess afte=
r
> > the change the "mask" parameter will go away?
>=20
> Mask would remain and perhaps become a module
> variable instead of a compile #define.
>=20
> What is jffs2_debug?

Sorry, I meant to suggest to just turn them all to jffs2_dbg() which you
introduced, without any bitmasks.

--=20
Best Regards,
Artem Bityutskiy

--=-fYOsaZgv7ryuBzSawbPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPX0AAAAoJECmIfjd9wqK02nMQAJAMxDVYKKC4tw2P6qZT15DO
iTuzPOER7yiTn0nmhs7WZfR4Fk1yrRWcNFXDV/CLeD+SwVk0FFPJt1Tqfey/rhFj
uLVNCi0taf1pBBU6S5vWxAxhW5G3MtzJ4UTUpJhJR9kgidicyce9y8bwiEgMO1hg
0NknF4eU64SAO0SfdbUS9f681mA+9ExkCs7Gk4eEMhWvgH8BUcb4JGkDpQ0uB59n
c3VyN71lBtGOulb4PtqTL6DvIik/Vd8jAuTRkMVu+JKdPXsZpfNhjMUjehXAp7T/
OXNGQXqDxIFxcIgFb5lwl+Q2rs2zRn3B+k3ye20Trn7wImC9giPpjr15xBGjbMn7
iahWb8QIDumR5+a9ZdyFIIIm0E2hIGXPcfnb+dkoO0x+iLpdzoxkXefEYlHXiGV/
6SQUu2lHCp3fik3NxANEWt5PkSywmPDI41Us7dMCh+yrlJMsFEGzpWCIHaOR4twP
3n/QEcSgZEkTYga688R98+8HRkd2+j6kDrcTemX9KGcoIRFycIX5r/vY8Yh9KqcQ
bytVa+feXRSUb59Y86sGLyDQHPFbIJK6HVetBRsYeeFFrxmvbGMpSVaeppSdII3F
gt1tFqIuAPt3Rz+NPQXSh4guxd47SKu6o/1Y4F4Q9gKrFBTpblEOgeglHnHROf2H
rlPrSz1pcWFEIQ9I7LI2
=Uv5g
-----END PGP SIGNATURE-----

--=-fYOsaZgv7ryuBzSawbPD--

