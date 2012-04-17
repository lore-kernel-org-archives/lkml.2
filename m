Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2DQQuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:50:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754173Ab2DQQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:50:09 -0400
Date: Tue, 17 Apr 2012 17:50:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776
 codec ALSA driver
Message-ID: <20120417165005.GR6652@opensource.wolfsonmicro.com>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <1334611118-10301-4-git-send-email-linux@rainbow-software.org>
 <20120417150234.GB22575@sirena.org.uk>
 <201204171813.44044.linux@rainbow-software.org>
 <20120417161820.GP6652@opensource.wolfsonmicro.com>
 <s5hlilupbe5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q8a9NmTVi5AMeZ2v"
Content-Disposition: inline
In-Reply-To: <s5hlilupbe5.wl%tiwai@suse.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q8a9NmTVi5AMeZ2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 06:32:18PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > What makes you cleaim that "ASoC was not designed to be used with sound
> > cards"?  Implementing sound cards is the sole purpose of ASoC...

> You don't need to overreact, he surely means only about the existing
> ice1724 sound driver for his device :)

Possibly...  it's really not clear.

> Restructuring ice1712 and ice1724 drivers to use ASoC would require
> quite a lot of works, and no one really wants it, I guess.  Many
> boards are old and can't be tested easily.  And, we still need to
> match the ASoC components with the controls of the current driver.

> This was already discussed a bit, and Clemens suggested like this
> way.

This isn't just adding something into a specific driver which fails at
abstraction, it's adding generic code.  If it were adding something to
the ice17xx driver then that'd be one thing but look at the subject line
and location of the file...  this stuff should be buried inside the
driver if it's too painful to make the driver sane.

--Q8a9NmTVi5AMeZ2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjZ80AAoJEBus8iNuMP3djzwQAIrloKi77nhuyOOVB/CQ+rLx
urDiVVePbP5Je3YEmE74wtHRhLINwd4x7MsJOdr4kNmMWtw6P0kw7a2tqDP11iyo
PttMS2zCO0FSKOeQa2pNNfdfKWiY6h9Pa0UdJ6/pcCEzcRHZZdTLhY7iv0K1NA4p
bFxTnhEsQDojAkEmfrZ3I6fuNRKg550VZ2+GKwSI/+EdPEfsJi9s6lDyYbcIwEwq
5PDowOV1k+HmHTb8QykXR5y2O0F6/kXd9fbXbWcxUSit2dcM1q3p3nRZMmHDuvev
NurMzgvpOtcSTiXtGGnFDqVAB91CM5pY1I4VZyzHuL2E0wRgo5q+j6XDr7BSbTFC
VWFWX15IghlCTv/y0zljipbYsdoNEub7gKzgdh02hJzNkuccruhlBOxwkE1OWAKI
rmAEQJCsI/ny61PPs8Etvy7gffieEVbnETSzhV2lUHO0jvt997NSlVNqLNBmaqOX
7JFVXCy492VMHAErhsghybjPN8CwYC3YB6QkZyla8gcBpKgYdec/Wc67JuR5vTRV
Kpyli9uRX0XD3EN5FtoCxuZiHyoQeiCk/Tg+MKq4ZKgijsrBPTjww1SQYjqXexOy
E+ZaH3r6bxxyMWy9cghme5r9DBMtEucX4KZsunIjvAtMUgMBLVI6gVuQjV9n7Vn/
3S/jls1nMkbQkiZdLMjI
=DWAl
-----END PGP SIGNATURE-----

--Q8a9NmTVi5AMeZ2v--
