Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab1GEWjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:39:00 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:58407 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab1GEWi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:38:59 -0400
Date: Wed, 6 Jul 2011 01:38:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2 3/5] ASoC: twl6040: Do not use wrapper for irq request
Message-ID: <20110705223851.GA8023@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1309873775-17927-1-git-send-email-peter.ujfalusi@ti.com>
 <1309873775-17927-4-git-send-email-peter.ujfalusi@ti.com>
 <20110705175919.GA6238@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <20110705175919.GA6238@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 05, 2011 at 10:59:20AM -0700, Mark Brown wrote:
> On Tue, Jul 05, 2011 at 04:49:33PM +0300, Peter Ujfalusi wrote:
> > The twl6040_request_irq/free_irq inline functions are going
> > to be removed, so replace them with direct calls.
> > The irq number is provided by the core driver via resource.
> >=20
> > Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>=20
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOE5J7AAoJEAv8Txj19kN155kH/1Ip8ZnDMvMVl2WSeZH8dd9O
6JAKJsK/hm/ZgkSGWBYU7eJEESvbcLiAWnfOVPtfYRIarDMUhZt9fF+Q5gVkLN0N
kyHqxc682sSW8nK7znz43OF+UV1z4B1tpuStHR07x/K+NtbMvwcxsOJJ+LZUK5bX
cb725iHAp9eTAobVaVTMuT9Lo6A2dswRssQiB3YbhA0JBMmW/5O0CSX3L5Lj7WR6
jApuPWrNf64cRHa/ibJ8HG2H+ZcGUhevvUc1X6kYZOdXRAfj95T6Y/eSoU4VgaFh
+eaeUhUimNdt3imNnI76pMZndCbw+bchlDalcUTkslLITfyeknLn2YDEAlxf/rM=
=nV+y
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
