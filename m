Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2HMKSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 06:18:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:53370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab2HMKST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 06:18:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="asc'?scan'208";a="179926848"
Message-ID: <1344853376.3393.8.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 6/6] ARM: imx: gpmi-nand depends on mxs-dma
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Fabio Estevam <festevam@gmail.com>
Cc: Dirk Behme <dirk.behme@de.bosch.com>, Arnd Bergmann <arnd@arndb.de>,
        Shawn Guo <shawn.guo@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Aug 2012 13:22:56 +0300
In-Reply-To: <CAOMZO5BtStkEWGRWi7LcVT_DK0C2WnjPiCOh2ZriVzrP+1NW3g@mail.gmail.com>
References: <1344430493-5304-1-git-send-email-arnd@arndb.de>
	 <1344430493-5304-7-git-send-email-arnd@arndb.de>
	 <CAOMZO5CZ7mJd89cN_S0KBS74mc5qTzvrfRbmHVX3nmEakx19ow@mail.gmail.com>
	 <50226409.1060800@de.bosch.com>
	 <CAOMZO5BtStkEWGRWi7LcVT_DK0C2WnjPiCOh2ZriVzrP+1NW3g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZsxSYGVbELspLa7J07ed"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZsxSYGVbELspLa7J07ed
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-08-08 at 10:18 -0300, Fabio Estevam wrote:
> On Wed, Aug 8, 2012 at 10:05 AM, Dirk Behme <dirk.behme@de.bosch.com> wro=
te:
>=20
> > Yes. But it seems it's not handled there? I'm trying since ~2 weeks to =
get
> > something like your patch applied to get the broken mainline fixed, but
> > unfortunately without success so far.
>=20
> Let's try once again.
>=20
> Artem,
>=20
> Could https://patchwork.kernel.org/patch/1236551/ be applied?

I will get to that. I was busy and also having vacation, so I have a
huge back-log, sorry.

--=20
Best Regards,
Artem Bityutskiy

--=-ZsxSYGVbELspLa7J07ed
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQKNWAAAoJECmIfjd9wqK0WSAP/0Pvf3t3gMSHTGsrEwA5kEA1
LuhlA9nr+oPTdLQAaOQrRUzNr+ONhFOtxGaaO1r3XwEcziYurnGwoy+3Lq/djZPr
sDZAaeQf1DBuM/cRrPIOOvl4e6S2wKqrHRgHSiOPBOPyR655CnJ5chtIr8Ig8p3q
CEp8xxwKQ1t7DJRyKdOi5lWfs37iOV1Omr4iqghqrfnuiXlqtQKPYQzzERzepA7g
jHyEYNVywc/4hQARkdtynxnsQIwBkTaSMQJE6MGoYj1POZZjSf+xvESy4yuTQ3Sc
gxc5QijFbN0xy5yuoiM4m58CIRikdyVX7jNgPp5ADGz47h9S+xp5MNQyIxSTFcH0
A2I/KrOcQgg1Eky3EMs7QNhSl2QeAx8YY3WyNTwYHOQErD6k3v9tp2JUJdQ53gr4
LHJbgZ5ZtIUDBhlS836AIGXcmVfbM2kJb5hCBzh5C7gQ5X7TSkAWiiGOq+bOi+8E
ju3wsKoqREx4d6eeWxFnC2sWpq70LjFNsXw8Wu39HlX7NkEO7qbQtzUHWF539bK+
CfD132z+ErjuFHNiN1ds20yCyE1eiQ/PlefYRpLyo0EAdIRxTSXyMhA3v40mueAg
7aW5tNR2we65uAvQuyYmtXFTsS41FXDWTzfmytirskD/D7oRhdggJ1E77wVuGmxK
qgkVxN5drnEvBkHlPvF2
=6uIK
-----END PGP SIGNATURE-----

--=-ZsxSYGVbELspLa7J07ed--

