Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2BIMuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:50:08 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40322 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751738Ab2BIMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:50:06 -0500
Date: Thu, 9 Feb 2012 12:50:03 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v3] ASoC: da7210: Add support for PLL and SRM
Message-ID: <20120209125003.GH3058@opensource.wolfsonmicro.com>
References: <1328095529.15257.7.camel@matrix>
 <20120201115035.GC5648@opensource.wolfsonmicro.com>
 <1328621149.26721.18.camel@matrix>
 <20120207191943.GB15929@opensource.wolfsonmicro.com>
 <1328791340.22077.3.camel@matrix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Content-Disposition: inline
In-Reply-To: <1328791340.22077.3.camel@matrix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 06:12:20PM +0530, Ashish Chavan wrote:

> BTW I am also planning to add SPI support to this driver. Just want to
> know if it should be done via reg-map APIs? If yes, then do I need to
> convert existing I2C stuff too to use reg-map?

Yes, please.  The idea is that all of the I2C and SPI drivers will get
converted over.

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM8CgAAoJEBus8iNuMP3dgG8P/AgnmyDoMXMTkyuudtEMQKU7
CCQ9U2iKnpx/DV3KiqMFCmP7dfxVtJMulym3if1oyDPupXthwrwKvdVoeExSsNDl
HayyWqWYBWscM22Rsbb5K6nuJYDdSNVyltexpt6L8wg6zxZboYWeA4z6dcPSyp44
p7IcsyeKxNQ3Ccru8chObbaAs1djl1ka+EXfEkmClJ8tg7hLEsE32b/NaeMaJPco
CNQJJ8BJNfQRxYHsG7CnX0iwXXVLUSkBqKf+F4OosRRPyJ6JqIxKQVGU8SuotyJH
m/F3ab4E4IlEo1RtP6uBxrZ/bXWL/sbolLWYDBmnp4KGJLBJ1L5ms1kvB3PNqRRh
FqSTQLIsg4KNUlhyQ9yAl1SA5TeU2zPkliuR8S5wlHV72YcehkN3ZtvmcXZf5BSw
FeCyMvsxR1/0KhA62iFkTAvFnTfRsw2t8OQMwH/0CtI39jeLAl1qs9MDrN+lH9sd
ZInc10e93iREZ+DMr6wLwd1gHigHak9ngAwXPC3TwL3mVG5r+uTOWSP70qN4EQG9
vNr1R3Uo3tFPHvFp+VHDY053Ly8jDNN39TB7O5l8Qbx0oFw+W1FuLiku5oij6VAl
sbxNdlfg2Hw9kgLpgJVkNRzEqcDgoor9sFbWBQ87VlVc/odoa6eNoyrGvJuM5UVP
wIXa2i54dYnSiEsaSqvt
=Pz40
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
