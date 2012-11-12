Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2KLPfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 10:35:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:30813 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab2KLPfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 10:35:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,762,1344236400"; 
   d="asc'?scan'208";a="240739244"
Message-ID: <1352734564.2262.7.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 074/193] drivers/mtd/devices: remove CONFIG_EXPERIMENTAL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Weinberger <richard@nod.at>
Date: Mon, 12 Nov 2012 17:36:04 +0200
In-Reply-To: <1351022666-6960-75-git-send-email-keescook@chromium.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-75-git-send-email-keescook@chromium.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-AboPsNnvP2AgFmt2atCt"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AboPsNnvP2AgFmt2atCt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-10-23 at 13:02 -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>=20
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: Artem Bityutskiy <Artem.Bityutskiy@linux.intel.com>
> CC: Robert Jarzmik <robert.jarzmik@free.fr>
> CC: Fabio Estevam <fabio.estevam@freescale.com>
> CC: Richard Weinberger <richard@nod.at>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Will this stuff be merged in one go or you want it to go via subsystems?

--=20
Best Regards,
Artem Bityutskiy

--=-AboPsNnvP2AgFmt2atCt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQoRdlAAoJECmIfjd9wqK0610P/1h3rB4J3oEQYjjquQuP8lx1
zONcpvM1YYTNACbGXOS0dTaTTUUCVQLfTpxU5lHTfE1nokKbyT/Jc/2mnK6oYQZs
WsKU0XbntyjcLlpPWHlcZBgq/Qby612yG/PcnbW0ACeliPFJy+gKUbDCHEFsxG2m
I7Bcxuyb7KcJJ4TWbNIuawUOigZU/i9mgqqh68XNxfBgcmjLSPcxdGS6H0URr536
ViakPcqSjbF7xSB7gc4ri1QhnPs1ekQmHvn7ms+EJuqFGGz1v+JSj1Uooh97CuGf
WDjpn14vjcyQ2GE0sAwK43DG80Nrsr/6935oiI1M5pgX6D+LWCIjcca23/dEkH0z
QIgSL2xVbHdGHEKJPpH3CrvGogZCr1/+V+KKzHxvJWCPAiyBCmVb4wtXoYknz9e3
AoVwPv/9Q8BOfXpKl/89N2/ZPuITqSZHVT4C682ICsLRY2sHa3J71tRwo1Gjbm0e
kaF0FxjfeW1dIqOK4/k06dbNR4RgzgUah9tYuLSO7PPMvKqWwr7fpzMO89OjgZOv
j5IrrtqMO+RcFSHPU8v2P2yC6thZZCxUciBhp0ZOKa/zLOStVPsnCOj3VIynzjFj
Z3s4faAbsojT7Tg/K0oLSJ6p1bhPoFtsPKRzTFty1sDnTHXFtA58Oi8ZjFfYlf6u
lGoMIuRwfOY7b/4X72Rc
=Pk69
-----END PGP SIGNATURE-----

--=-AboPsNnvP2AgFmt2atCt--

