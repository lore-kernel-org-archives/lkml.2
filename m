Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161132Ab2KNKsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 05:48:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:16157 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932836Ab2KNKsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 05:48:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,249,1352102400"; 
   d="asc'?scan'208";a="219435461"
Message-ID: <1352890119.20481.3.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 074/193] drivers/mtd/devices: remove CONFIG_EXPERIMENTAL
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Richard Weinberger <richard@nod.at>
Date: Wed, 14 Nov 2012 12:48:39 +0200
In-Reply-To: <CAGXu5jL6rP=YQfgDhGNhcq4nGLj6Tjzv-XgxQXBTk4EReriySg@mail.gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	 <1351022666-6960-75-git-send-email-keescook@chromium.org>
	 <1352734564.2262.7.camel@sauron.fi.intel.com>
	 <CAGXu5jJ2XMB+hhzH0MFY3=tkF+iFY8srbKbvy6RMxdrnb0-FYA@mail.gmail.com>
	 <1352796571.2262.50.camel@sauron.fi.intel.com>
	 <CAGXu5jL6rP=YQfgDhGNhcq4nGLj6Tjzv-XgxQXBTk4EReriySg@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-GSCK9CLruIMmCV6Jy1Zq"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-GSCK9CLruIMmCV6Jy1Zq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-11-13 at 09:58 -0800, Kees Cook wrote:
> Cool, great. I CCed you on a few of the patches in the series; should
> I just push this one mtd, or all the ones that you're CCed on?

Please, carry all those touching "drivers/mtd" of them in your tree,
thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-GSCK9CLruIMmCV6Jy1Zq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQo3cHAAoJECmIfjd9wqK0P9gP/iuH0j/S/6OuzNHSbwBSX8I7
vOrFPB43NIGPGDFvAeLM0NclIvKhHR608WZxVoOXV/tQeOwHivVwsHyS8z8f9co7
AlcmZ6oIa0HFNn9e2yEhIdBsF35xlRmjmV+9XGIhjMRTJXEDaqPWjEsrg1Uji5Ew
Z7GHcotK5srDscWubqj5Z5kJAwvCH+N57i72c1d2BLGBjU/nlwx1hEaHasFEp2EG
+Ca7qNz7yNn0OsWQcbvkCXIFdZ0N5GR1JCGLtzxUPAcdkQ0erOgfZEXk5LKhSafU
QFYlfeirT4ROesaviTSXBuNccWs6Ocsh7sBky2rnA+6598oifGk9PTcPdVe740rC
2Pas3XNN7dnpZ6utcAgYYe+0k28x8SS8hiWreeNfVB3Tf2AbNuF0Z3mIUUpyBGnn
+VQSyEvAm5CaGbb6whC8xG62ACU8GxX+89BBMwQ3kYOtAp0ZCEaHYXuZU6sLk6sS
5yRaWjQrvZWUHrCYDCQxyp3wDkDbNvG5BTM+V8dYbHdVh0V2FevbcmbJN2PP6kw1
rLHN2Dss097Y4Ewo/3yrVpF4Ip0fKVT9SBvcv+teWe4KbrYnztiGSuxTfbA3Ujp2
1y4r4o7UsB6f6TwdXewWxHrg5M1qamu1qNhW8x4o+8f/R6MHQm+K0si655za+Bz9
mk5+PXTO7uVGzfjVspyb
=vUGq
-----END PGP SIGNATURE-----

--=-GSCK9CLruIMmCV6Jy1Zq--

