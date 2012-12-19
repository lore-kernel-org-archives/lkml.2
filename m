Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2LSN6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:58:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53841 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2LSN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:58:06 -0500
Date: Wed, 19 Dec 2012 13:58:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: balbi@ti.com, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Luciano Coelho <coelho@ti.com>, svenkatr@ti.com,
        linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org,
        lrg@ti.com, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, r.sricharan@ti.com
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219135802.GT4985@opensource.wolfsonmicro.com>
References: <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
 <20121219103206.GQ4985@opensource.wolfsonmicro.com>
 <1355913954.5273.21.camel@cumari.coelho.fi>
 <50D19D54.2000307@ti.com>
 <20121219130128.GC17993@arwen.pp.htv.fi>
 <50D1C652.3050607@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFvuq/4WPi1dbS7Q"
Content-Disposition: inline
In-Reply-To: <50D1C652.3050607@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dFvuq/4WPi1dbS7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 02:51:14PM +0100, Benoit Cousson wrote:

> Regarding the 32k clock, I noticed as well that the OMAP4460 panda
> u-boot is the only one to enable it at boot time, and thus this is the
> only board that can probe the wilink chip properly as of today.

Well, there was nothing in the code that was disabled which would have
turned on the 32kHz clock and no references to it in the standard
kernel...

--dFvuq/4WPi1dbS7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0cfiAAoJELSic+t+oim9B3MP/A1ey/HOYt0Erqx2f5J7bwY4
maAPoTM8bUeya9KtKMujyNGXTzNyUTt/2twk+OmJAs2uH93f2EdDR29zpzAnyROM
+Qy4k3U7cAUfdmo/LksD5dOC0vzljlM9QJ0SbMONavaDbery7++SfPfDNFKE0bLX
Tc3esryu4i5Zr34YnO3+70MZLpm/UNRuRw8jkE1uE/qhwRMD0O96jIF0kWI5PpFA
Id5ukjuG2QL0Nyjdgl7/8a/AO0iNFo9ZMlby6WzwHkU1JhtwSTFDk0pDMpjlR3XB
r9JgTUxNLd9GYOMrc8z43P52mELLMgfRPAM4zqPCdulb/0TKnvv9vrsKwnm+XJA1
+opee9uAKGkPpEm4kPAJuuB34c6Gb9lAEH537D2noZfYJcSNVF2FzrRLA839wPw9
UM/4aw0cjP2+zN/qL8u1jtqLf7nfo0zyMVR4fOJr1O6EH1Fr8ajRvUPe/XJSfJS+
oe+ju+6GL/j+iPsCjlIiAgEgL6c4mQ4A9g2FyqIwyI5c9bhJzAwMjuRa+fG4XFSG
m3AL5tCfHH54ykw+RvN3QKFiz0+QrLthPX/GPiqpa6zVzhRhFKH0AbRtL50ns+sa
eYsJWqjMh7SGQBw5WpsVwY/5MD3RdhFFYJoV928Oxf186yNzBkoKCGqgkWJYng5k
KlWQNvsBFybS8LEKd3Nl
=maff
-----END PGP SIGNATURE-----

--dFvuq/4WPi1dbS7Q--
