Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab2COKuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:50:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50172 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969Ab2COKuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:50:50 -0400
Date: Thu, 15 Mar 2012 10:50:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/lapis: add machine driver for ML7213
 Carrier Board
Message-ID: <20120315105048.GF3138@opensource.wolfsonmicro.com>
References: <CANKRQngTNWMGswq3weD1s8O4irVEz+DCr1vzi2gnWaQcoq5SEw@mail.gmail.com>
 <1331275091-31700-1-git-send-email-tomoya.rohm@gmail.com>
 <20120314144524.GT3133@opensource.wolfsonmicro.com>
 <CANKRQni-8w+2p6=ZisQ+GXhGpNmYhesKfTHfOjWGGrQrhvTFGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <CANKRQni-8w+2p6=ZisQ+GXhGpNmYhesKfTHfOjWGGrQrhvTFGA@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AH+kv8CCoFf6qPuz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 01:50:48PM +0900, Tomoya MORINAGA wrote:

> OK.
> codec is slave, i2s controller is master.
> So, I'll use SND_SOC_DAIFMT_CBS_CFM.

That means "Codec bit clock master frame clock slave".  Are you sure
that's what you want?

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYcl+AAoJEBus8iNuMP3dYWYP/R0XF2NYB0ME/pbTIyd1h48K
ExVRJUv8T2Q6wGde5AvEnq8OCedT/Qw+i5irMGD/uPClKByKJ6xbfehtiYLQcVmC
RmB9elMiy38mopJSvkcG0fTx8mJEX9fSYFH5eP4UaqG4w7bsOe2GRQsxcvqnoLgW
yA17ViKthIHnXAWN/pUti0DGdAxtTnntUHHfCEP6RB1Hy7OaXaPrMORuIFxJs5fH
y+PVjRJWPGWmR/FWGigGpYzaNKcAvd6l3EW3Bb4Uo7eU8Lp5W/TSslbV74IJBrYw
zfAZpFtFMuTiEKBiwc7OyDotwnST81X/mJSD9UWLxcReX+JTm4ywWS0rDBHEtoxu
Iz9nq3rPzzk2ivRWMirXbhcKiuYQe6+pJYp6HcaLg99QGNxVQhDZin1eDsOkoUaX
G1oWyj5bytXLpxdFY4S4pEs9BtgdvtFrXYVI7iU9BSyErmesOeynmyDN4E0gz7yH
pEKYgeO8uvWCHU9coUl9uhIsatdxkN4b/JCLFmu+5YqkHJHr5jxoamRPu3sre1d9
k/e3nOQeT2EZYZCFzp5gHakqUp9p6XZx+eAC1NIrLa7StlXU32r0cb/oSXUpTuOa
FOP0wjZpCb07YXVt4JGvWxlRVmUlhXlOgvRpzBh2L1YwkhlLuwDW/CfJumwG6cC1
MyvpD/b+0rtfIYUrWVom
=bKfV
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
