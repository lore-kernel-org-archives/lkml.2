Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab2F2NAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 09:00:25 -0400
Received: from mga14.intel.com ([143.182.124.37]:63798 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab2F2NAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 09:00:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="162229285"
Message-ID: <1340975067.3070.180.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v10] MTD: LPC32xx MLC NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dwmw2@infradead.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Date: Fri, 29 Jun 2012 16:04:27 +0300
In-Reply-To: <CAAAP30HZ1Z5U44wLwSEfcaJSLmVp8AbXPTCagS31hnoCy_tf-g@mail.gmail.com>
References: <1340834129-15545-1-git-send-email-stigge@antcom.de>
	 <1340973434.3070.168.camel@sauron.fi.intel.com>
	 <CAAAP30HZ1Z5U44wLwSEfcaJSLmVp8AbXPTCagS31hnoCy_tf-g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-B38n0FokRUfCGVsXP7DU"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B38n0FokRUfCGVsXP7DU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-06-29 at 09:56 -0300, Alexandre Pereira da Silva wrote:
> > @@ @@
> > +drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_nand_probe':
> > +drivers/mtd/nand/lpc32xx_mlc.c:679:10: warning: variable 'sr' set but =
not used [-Wunused-but-set-variable]

gcc 4.6, aiaiai uses W=3D1 when building.

> > +drivers/mtd/nand/lpc32xx_mlc.c:561:24: error: bad constant expression =
[sparse]

This is sparse, not gcc.

--=20
Best Regards,
Artem Bityutskiy

--=-B38n0FokRUfCGVsXP7DU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7afbAAoJECmIfjd9wqK0hNIP/1RyhN3l041+KGPGjWa9LSxP
slXQ5VinUb2uYcmruYPkTTcCMI+sXSxMwv0FwX5JyQxEKumtcBlYDFLeAc2e9eyG
vyhY0jwvtZBluqWqw0qcq3eFulbkAAhGT2kXBDMhJT/JoUQB46gnyExdlSNS99p2
CFCPirg5VQbDeZGVNUKN/Y9AAjq8PDx8noPieIlzpRRn2vjFHwaGacDSFkvSw2MH
rrmL25ZRT8vfpig7m+1pTpVBBWT5d/LV/T0ag11kujbblyypazQyIQfh8KgpzTAS
wl+OKMLVnB9UjJUKjOJ6BxMTJFeIjOB4P2f9/rOeUWoV4Ogu4gcabqfxFtyI2REQ
rb3eHPiyGfyTXvrw8yw9MqYuyu9zYw+pigMeyaQEZ0PvMFVfMCBSBY2tBoZMC0q9
4oxq7Q5hqaBSAbF3xJc7KxEcBnF4E1S4bPzbVu5JNJdbG+BJ5diCesHMJTON5PNj
WPdavmX75q6a4FTAVupS9lI428WoWh7YQYEsLZZkeIfL1zjJbJylEUw/yfYzisuD
4AvbauEQU8JCiWqFvAAb22j1K0KnKS3AHm4Ym9ikp3T+4M2A58ch0eGWYNnY8aSA
ibAlvC4jDx8fuAtOjZiOHJjlpMl1b+MhsEWhFzOdtQZPSXhNqBz7Ulm61vuCopYe
H15CFragPXRWILi9nb4T
=5mS7
-----END PGP SIGNATURE-----

--=-B38n0FokRUfCGVsXP7DU--

