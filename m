Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933688Ab2GLKfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:35:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45931 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932983Ab2GLKfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:35:24 -0400
Date: Thu, 12 Jul 2012 12:35:09 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 5/5] i2c: tegra: convert normal suspend/resume to *_noirq
Message-ID: <20120712103509.GF27520@pengutronix.de>
References: <1341919244-23327-1-git-send-email-ldewangan@nvidia.com>
 <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3uUfsyyY1Pqa/ej"
Content-Disposition: inline
In-Reply-To: <1341919244-23327-6-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3uUfsyyY1Pqa/ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 10, 2012 at 04:50:44PM +0530, Laxman Dewangan wrote:
> To provide the late suspend and early resume for i2c
> driver, convert the suspend/resume as
> 	suspend-> suspend_noirq
> 	resume -> resume_noirq
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied to next on top of Rafael's patches. Please have a look if I did
the fixup right.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--w3uUfsyyY1Pqa/ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/+qF0ACgkQD27XaX1/VRu2WgCgi9aUaeM1UBu9b86KWLwvDQnb
4WQAoI5dCvRZRh8VbCn7wERKuYrXDCPc
=nqtJ
-----END PGP SIGNATURE-----

--w3uUfsyyY1Pqa/ej--
