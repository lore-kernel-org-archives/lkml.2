Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2DQREg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 13:04:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40922 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754116Ab2DQREf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 13:04:35 -0400
Date: Tue, 17 Apr 2012 18:04:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776
 codec ALSA driver
Message-ID: <20120417170431.GT6652@opensource.wolfsonmicro.com>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <1334611118-10301-4-git-send-email-linux@rainbow-software.org>
 <20120417150234.GB22575@sirena.org.uk>
 <201204171813.44044.linux@rainbow-software.org>
 <20120417161820.GP6652@opensource.wolfsonmicro.com>
 <s5hlilupbe5.wl%tiwai@suse.de>
 <20120417165005.GR6652@opensource.wolfsonmicro.com>
 <s5hbomqpafy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xPLL5cPndR2UZ7Mw"
Content-Disposition: inline
In-Reply-To: <s5hbomqpafy.wl%tiwai@suse.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xPLL5cPndR2UZ7Mw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 06:52:49PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > This isn't just adding something into a specific driver which fails at
> > abstraction, it's adding generic code.  If it were adding something to
> > the ice17xx driver then that'd be one thing but look at the subject line
> > and location of the file...  this stuff should be buried inside the
> > driver if it's too painful to make the driver sane.

> The codes in sound/i2c are mostly oly for ice1712/ice1724 drivers
> after all...  They could be used by others, but I don't think there
> will be any more at this point.

If they're specific to that driver we should make them specific to that
driver and make sure the pain is confined there.  We really don't want
to end up going back to the bad old days of having to do per-CPU/card
drivers for CODECs because nobody had thought to abstract this stuff,
that just makes everyone miserable.

Looking at these commits I'd not expect anyone to figure out that this
isn't how we want or expect people to add generic CODEC drivers.

--xPLL5cPndR2UZ7Mw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjaIuAAoJEBus8iNuMP3d48AP/jGK/OvRzQgA71eqKsvprJ9+
+9O4/49CopQDpwdQgAbWjlAa6pSXN1SB6TDZV4XK3UpA+UO25AbVrPyqSahvwf4V
vFkkMfA2tA1KfvAcgan4sD4s6wtM/eTqJwpVxWucHTwvEoJA7Z/esNdQ5wWFgCSH
J77w705fsw+PgTjIlTgwfgEtAVL1fvETQdjaOfOHFWk8WQ6Bpm0zpGqQSwYFpnsi
2PSknBROMHfC70E6FGvIc8CxL4e2Ztz3+f7oC/eDbNsUfaFHhK4eHRNvhVX9se78
GXHLbukLfulxAexHuph33NcmCYvnrwkqS3tjsebptLHMxfEr6eozCPBQmAXkBPU0
Cy9O4nO2Bw8ImZsVsLgpPAZk2aKXKK1sL/jOpIDttn4UtH1EfOh1ci4j0TqFOauJ
WBwkn2QBmXrA2ZNNLoYibB5wKgX6dKefZyxljQmhmvsCel1RRRLb2JF8ULPBlpLs
gp0pAU0ymzK27LMA/nIFZ8m6qHwj5r3D/itPEVovDvtBrOss620A6ZduYBIAlacB
F5ATM5GO8wcUHBK1Kw0F0Ziwi7PJfHI9sEb60B4ozpiYhSV03SpxccilrGfIHnkY
cCi2rYBCnHIehJ9Eb/PrPEHhzMOyOtTWXXHN9OnvItdselVjUADQrTeCmVUki51G
n0Bp5QdTpM8QGCh1G7Mb
=+2oo
-----END PGP SIGNATURE-----

--xPLL5cPndR2UZ7Mw--
