Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2K0QqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 11:46:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42033 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab2K0QqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 11:46:12 -0500
Date: Tue, 27 Nov 2012 16:46:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Tomi Valkeinen <tomba@iki.fi>, Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Warren <swarren@nvidia.com>, Mark Zhang <markz@nvidia.com>,
        Rob Herring <rob.herring@calxeda.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
Message-ID: <20121127164607.GG4468@opensource.wolfsonmicro.com>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <6982060.HfOokt4dIn@avalon>
 <50B4D9E9.8070607@ti.com>
 <3136860.Z3VvKjeKpU@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8/pVXlBMPtxfSuJG"
Content-Disposition: inline
In-Reply-To: <3136860.Z3VvKjeKpU@avalon>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8/pVXlBMPtxfSuJG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 27, 2012 at 04:37:32PM +0100, Laurent Pinchart wrote:

> One possibly crazy idea I had was to replace backlight devices as we know=
 them=20
> with LED devices (a LED driver IC shouldn't be supported by different API=
s=20
> depending on whether the LEDs it drives are used as a backlight or not), =
and=20
> have the panel hook up with the associated LED device to expose backlight=
=20
> operations through the CDF. Panels with a backlight controller tied to th=
e=20
> panel controller (control through DSI for instance) would implement the=
=20
> backlight operations directly without instantiating a LED device. This st=
ill=20
> leaves the question of the userspace backlight brightness API open.

I remember looking at that before but never actually got round to it, it
seems like a sensible idea to me.

--8/pVXlBMPtxfSuJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtO5HAAoJELSic+t+oim9h/cP/i717a9Sz8TheSTibWIOtSwa
A45+ZL/V55CNWf1jnydvAIilGimVeumAk95Xcqh7OkLC7VoeCFP8pHoicC83ilHj
KNAhd54iK3IgMskORskeZ2XAb6Nk+DRq3I28mX4hzisI69HqmeDmqiCXLJeO0D/+
YoYzyIj4ES3O7u2Asv+CS1b95biq22m3SwDqbKFTeS8hPpOnw/IzzCqp49R/sn/E
LhJse7m1JoPi9o4W1+RfX0LTXSAYxsd4BMXb9qyqvUNE9FSL+l/mFOnsjEcFL/zQ
U4mC/76QWBCFWdmLyHV71vV/JTXl0wr4S6ptpqeM9S6b/YO2reT919F5flqK74kf
FTI5BS2ENSMXXaeVmpw7JMzvKIaKF3It0/Iy7FgIdBya0WYU/NXcFhlww6VNoFJr
SC76XmGuAaOhdUYkL3LEISS5IXfoaD+OJq/x695ITfP+D5iBA6V4joPbC1kEKoNB
COVPaBOTecjnKoqkPZDCw6TNLrTxCqVwo1BaO+didPejOSxxkahq8x5DrcrHb4PY
YQDBRXr+ayV8uwHumaVogb+Zm4PCBFNw1XRlKs4EXkLDoAITmj1a+jqfx9TS203s
lzXeCcm9i5B93sH4DzVQnEBWPeaF6uRQAkb18/tsDms9ImKr8mI69AgxBzNIAI6L
pmhNMm9aDmAd3OpsIvhK
=Ni3b
-----END PGP SIGNATURE-----

--8/pVXlBMPtxfSuJG--
