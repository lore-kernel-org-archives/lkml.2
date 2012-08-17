Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab2HQLFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 07:05:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:21364 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab2HQLFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 07:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="asc'?scan'208";a="187684125"
Message-ID: <1345201835.27859.52.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] ARM: LPC32xx: Provide DMA filter callbacks via platform
 data
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Date: Fri, 17 Aug 2012 14:10:35 +0300
In-Reply-To: <1345201311.27859.51.camel@sauron.fi.intel.com>
References: <1345122935-22115-1-git-send-email-stigge@antcom.de>
	 <1345198171.27859.39.camel@sauron.fi.intel.com>
	 <502E2279.1030604@antcom.de>
	 <1345201311.27859.51.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-QI+4qYqAJ+EA4syHG23T"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QI+4qYqAJ+EA4syHG23T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-17 at 14:01 +0300, Artem Bityutskiy wrote:
> > To later avoid collisions on subsystem merge, can you please leave the
> > patch with arch/arm/mach-lpc32xx/phy3250.c for arm-soc.git? (I will
> > provide a pull request for Arnd and Olof, as usual.)
>=20
> Only if Arnd insists. Otherwise I'd prefer to resolve collisions (they
> cannot be hard with this patch) than pulling the soc tree to the mtd
> tree.

Actually the mtd patches do not compile-depend on it, sorry, I am
dropping it from the MTD tree. Thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-QI+4qYqAJ+EA4syHG23T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLiarAAoJECmIfjd9wqK0KTwQAIBuZnv8JZz8t5wucrbYo4WJ
VXhOH9XxxejjlmW4h+w5bPA15ALs1x1Z5aLm5vVbYf622DN6VrAP6mXO35OtJgtm
KjQFBNPz6Yq+x+CkuPu/VrucEGBvLDYnAoGL5p/sT8ZpWZay51Rh7X0l2T/oGdSY
4vz/QWsxGZtZxBb+EUL5YGLhoOcJQRD09Jy/Icccbjs99YERxCe0kkmktVg1AIcd
feQWlVUvRSsR9ey4bPm3xZUsM5J2V/y3fDkiIaqFhKhsz9944300mfXLGv6HeeLg
TQYPTNzpPUs4mosRrHg2KMoFN4Ubvd86jySxM/wPe9cGobF8F2lBeuvaKPsQEcUd
rPli13dRkuXb03OKoBolp97BDp0l0rxwbSIPCuGcgsbeITGlYHUGiEDX6bRfrqT6
kaY3zDD9e64BRBSLNC/J6KWOJpT2pogtHVlkGUgjsQo25xW6PuJpOCDZHjoaxP91
ghEcxrB0wyqLoi+za9DnYJdGlVJzo/9ErkPaRBno60yrgNMhTTAp7HL+u5kMMlFA
6JzCq8VsJ4infJGuzTgoEAXg5pvOlcRdeHuv9xChblhcM5lM8zCBMCLSMjXtARiK
WafICAgfzBLDGS9DzWfWuJcWtS1MyLZtpiZF4K+eS+Uk9A4azjKpvKvkmr354kqp
xtGTqzkx+KPtIXNjUv2S
=XHLj
-----END PGP SIGNATURE-----

--=-QI+4qYqAJ+EA4syHG23T--

