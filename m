Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2FMMLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 08:11:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46800 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968Ab2FMMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 08:11:44 -0400
Date: Wed, 13 Jun 2012 13:11:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, alsa-devel@alsa-project.org,
        lars@metafoo.de, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v5] sound/soc/lapis: add platform driver for
 ML7213
Message-ID: <20120613121140.GL4545@opensource.wolfsonmicro.com>
References: <20120527221956.GB25019@opensource.wolfsonmicro.com>
 <CANKRQnhwkhGUHi6WQhw-sRJuKari3SLcipCJXVp27OZ29=Vxkw@mail.gmail.com>
 <20120530121449.GI9947@opensource.wolfsonmicro.com>
 <CANKRQni4uqQJ99ycOScHmn-g1kz2_XH7ePL+n1taG5jAbDSubw@mail.gmail.com>
 <20120531104538.GA2666@opensource.wolfsonmicro.com>
 <CANKRQnjdiV+e=N+n_ZP04jmCAhxKjgZ+wab+anbgO+VJPNo=PQ@mail.gmail.com>
 <20120601083018.GH24139@opensource.wolfsonmicro.com>
 <CANKRQnjeYtBucmGoDUg7oTK82rvnkakWRB0Siezyz-kbhyPC+g@mail.gmail.com>
 <20120611085404.GB11439@opensource.wolfsonmicro.com>
 <CANKRQngP3e3U+VZDgA7fQfxBti9vri-AEAR8iTmhLYiqXP_kiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5VuzLDXibKSJvVYD"
Content-Disposition: inline
In-Reply-To: <CANKRQngP3e3U+VZDgA7fQfxBti9vri-AEAR8iTmhLYiqXP_kiw@mail.gmail.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5VuzLDXibKSJvVYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 07:41:57PM +0900, Tomoya MORINAGA wrote:
> On Mon, Jun 11, 2012 at 5:54 PM, Mark Brown

> > There are some drivers that predate the availibility of the dmaengine
> > framework.

> In case, you develop a new ASoC framework,  all previous ASoC drivers
> should be adopted to the framework by yourself, don't you ?
> Because a new developer must be confused by this.

This is exactly what Lars-Peter did, he updated all the drivers that
used cyclic mode to use the framework.  Drivers using non-cyclic mode
weren't updated as there is some additional work needed in the
framework.

That said, you don't always want to do this - depending on the change
involved it's sometimes simpler and easier to move things over piecemeal
unless there's an actual issue being created by the lack of the new
firmware.

--5VuzLDXibKSJvVYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2IN1AAoJEBus8iNuMP3dpW0P/2FLeH2rXM/kE5wWCqg7cnjv
fNuZ1C9c6cgSkdJZaod12mdXt/yzZLr1udUKnI1hURGavb8pIQRMZGqD9t3CJEyN
Smc75DWaBu33bYdyW3PMhZRtHatW7RyhjtJx0NCfPw/fESR8BnfttwEIDefUCr/U
+Hgav+Zn4ZxdbkAx/5zEkLnqoNc4XRhkSEq4uLrZHYnWGxHM1dEOFSrjKf3KjWNb
B57jKp7tP58lWF3o7gkHlwBl4+Nfcmqa5ziF95iGxWibzvzZQOr4SIpuhMFK25mQ
rj0xfDQMBTjMCriD8TCatgV/5sFYBHzoGK0JpJwpatl/HyjSXJ90ahiH5gCu/VNT
5acsGxGoSI+FdlCRBCzP/UTMMWDM5GHaDhXb/8o/xbRXhicw7aa4QDdi5H+2S2ax
fdAqbyjWPXP9/k2zsF+Uqrod3RpgIHYuCW5O7TaCBevk5Vz9c8AQKFnvrQV6REk7
iEamBUAwfW6TNyGQ+XEkOPTR+gHM3T9KIrY9OAYyEEE+f8DL5x54ZcKR7IoTaBwI
efZQfRZDqITicOZKddj7r/nd3G0ROEWKAtyfl120SvEh2aLoBnG1imiluLoozhVY
y73E2DUcDB2ZiI0/xHagwBxsPI6xl05AP3jcV8EB9yOTzM5sXKwf8iEkxSGBE5eR
QV4htJ6k51wTWvyRYY9R
=/BpO
-----END PGP SIGNATURE-----

--5VuzLDXibKSJvVYD--
