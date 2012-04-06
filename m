Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab2DFIvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:51:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55836 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751887Ab2DFIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:51:51 -0400
Date: Fri, 6 Apr 2012 09:51:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, paul.gortmaker@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: rc5t583: Correct MODULE LICENSE to GPL v2
Message-ID: <20120406085148.GE3172@opensource.wolfsonmicro.com>
References: <1333690113-8341-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Content-Disposition: inline
In-Reply-To: <1333690113-8341-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 06, 2012 at 10:58:33AM +0530, Laxman Dewangan wrote:
> Fixing build issue reported by Paul Gortmaker:
>=20
> It appears this breaks linux-next allmodconfig build, because it
> uses an uppercase V in the v2 of its MODULE_LICENSE.
>=20
> FATAL: modpost: GPL-incompatible module rc5t583-regulator.ko uses
> GPL-only symbol 'platform_driver_unregister'
> make[2]: *** [__modpost] Error 1

Applied, thanks.

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfq6XAAoJEBus8iNuMP3dwtYP/jHuTigRL0O8qPmxbrT8LSYP
TkIAR5BhvAogpc53SOPnWEZQdrzdUajcRZuDtCVJHtR75OyFIhC7ofGePkpdaNUQ
e6augUhkWZgS1IvjplgTgvp6By8E4Htd0bEbly87vzboAkSt49IRC9cHgnB7uEby
m+vOc8sLQfDCnVO8uQtwJ5YlyN4YL0Gx2MgYzVmB4LWG1gp3M3kqE6R0Qgnb37pk
WspGEFVrDYrez0yYKTrrmB6mus250oJnIuDCq+V8scs1HVsMBOJiL5gjn4Utrrvg
VtCKRnYYbXaNADTTgtuDRptsxp/BdGobLd5o4rW6TsiEiIFrMcGk3nVHDK/ulihM
d/FLWVU/r0ikEqFHkNxoLuGr8zWwduTWyIrX8Wzy+lVls+WF/eq6NAwMfNStGBWS
tlPvTtDnGiRc2gu9ylcONut+huOSP3/B5z3sB6C8pEzEYbpzRTn414QsXsJGkljZ
KilevrIBFb2Dpv56Yy8coUe/OM3NUWf7QV1fN/8237TQaQRwdvhAxJbnEOm0cryT
eiRoUoNdbqVXiK1UFKe/X7e3D7MZM/xzTeFpqoEe3RFc+uxzDbXVNxHiWlxocuVt
xRX476hgS2UeG/6Zdh1UG9k9z/jHgdXdyY5VLwpK9RdlxOFk4+QV0It+bS1OFUs2
8iTe2OQrEs1uBo9xwQyP
=MsYr
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
