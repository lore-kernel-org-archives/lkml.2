Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860Ab2HQK5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:57:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:42738 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab2HQK5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="asc'?scan'208";a="203436511"
Message-ID: <1345201311.27859.51.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform
 data
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Date: Fri, 17 Aug 2012 14:01:51 +0300
In-Reply-To: <502E2279.1030604@antcom.de>
References: <1345122935-22115-1-git-send-email-stigge@antcom.de>
	 <1345198171.27859.39.camel@sauron.fi.intel.com>
	 <502E2279.1030604@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-6hToxl1UKw/3xy16kG3z"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6hToxl1UKw/3xy16kG3z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 12:52 +0200, Roland Stigge wrote:
> On 08/17/2012 12:09 PM, Artem Bityutskiy wrote:
> > On Thu, 2012-08-16 at 15:15 +0200, Roland Stigge wrote:
> >> The SLC and MLC NAND drivers now need their dma_filter callbacks
> >> via platform data to make them independent of single DMA engine
> >> drivers.
> >>=20
> >> (This also helps fixing build errors of the SLC and MLC drivers
> >> when building as modules because direct access to AMBA dma filter
> >> functions isn't available via export.)
> >>=20
> >> Signed-off-by: Roland Stigge <stigge@antcom.de>
> >=20
> > Pushed the 3 patches to l2-mtd.git, thanks!
>=20
> To later avoid collisions on subsystem merge, can you please leave the
> patch with arch/arm/mach-lpc32xx/phy3250.c for arm-soc.git? (I will
> provide a pull request for Arnd and Olof, as usual.)

Only if Arnd insists. Otherwise I'd prefer to resolve collisions (they
cannot be hard with this patch) than pulling the soc tree to the mtd
tree.

--=20
Best Regards,
Artem Bityutskiy

--=-6hToxl1UKw/3xy16kG3z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLiSfAAoJECmIfjd9wqK0cPIQAJqP7fmYr0H8IOwRy28nrdIh
7voBKr2G88ZpnncnDvWCBVLMB9NHGAbJWp4uGQe94WJEmpb55kzy/Xqos87lHBvP
bYa/qz2yZLzsCOccaC8XrZ2UXkJ8Cembrvw3cbV7aovfcz/138Idk+nzCUGIQA91
RG8TB8m0EFt811Tv9+RR1DJksb209RmFuGbJm3Slk6nNxl0FvI2VHNCtKk0wXinV
mK4+o0RtnJ3pkzxC1bBFJhL/+/Q4sq80InqVyo9miQ/BFSVqMDuOOnBSsNLjoHpd
lEd8NHv9yx9bjJLXXkKJQ1ACoN2XWVKvJP7syQ3AeyFdFeGfr1p6683zM3oCk3t5
ISiM4wz6QC6tyOiaXBLvfP71QQvEsT+uUwi3sYu3mF2kx//I+F7FfdtieOVOftjU
HRyZW1x3y9pkG7RwfMCw0eGSOUJz4KXGWFjlBXSz/K2SLTdiimVD+WVs/Tsq1Apl
yOWQtDSO4WQuhkXduE458II8+gPB/F1MdWr20BvYRXyXXKzJmAxknkx4wx6dQk/s
11IO5Sv/hbGTfe1x84GnEwR/VLRLFR5pzC3vSC0KQgmMzyiaID60TpX1+997pkAS
qYb9nMMEgz0Fo8nln4TQHF63PWG5D4algyqytATfXF6P9NsREEcrWuDsww/j0GCl
0Z5fePOwa7Jev1LO1iaZ
=KdvF
-----END PGP SIGNATURE-----

--=-6hToxl1UKw/3xy16kG3z--

