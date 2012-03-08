Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab2CHLr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:47:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55223 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510Ab2CHLrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:47:25 -0500
Date: Thu, 8 Mar 2012 11:47:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH v6] sound/soc/codecs: add LAPIS Semiconductor ML26124
Message-ID: <20120308114704.GH3638@opensource.wolfsonmicro.com>
References: <20120229235147.GM8295@opensource.wolfsonmicro.com>
 <CANKRQngOkGTPM9AWEaHoaNQCyN65B_ESB24ctcT_DiEen050fg@mail.gmail.com>
 <20120302125819.GE3230@opensource.wolfsonmicro.com>
 <CANKRQngoDf_U8U7txG0AT1TKmSeq2FfqwjWD7EEiLROWzn+f5Q@mail.gmail.com>
 <20120306100012.GC19635@opensource.wolfsonmicro.com>
 <CANKRQniUnEPawXZHcPH9kG0hDiaZ-eJ_vOQrCefB0ntCu98D6g@mail.gmail.com>
 <20120306121222.GK19635@opensource.wolfsonmicro.com>
 <CANKRQnjFB8G5iRKZLQok+qnQrPXf7vcRGto_OyL+1=VNBTnetw@mail.gmail.com>
 <20120307114811.GF3107@opensource.wolfsonmicro.com>
 <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/8E7gjuj425jZz9t"
Content-Disposition: inline
In-Reply-To: <CANKRQnh2JqhZBYLP=U_isgthh2pFT89_qBeypda1ciUJzoRXYw@mail.gmail.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/8E7gjuj425jZz9t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 08, 2012 at 11:24:36AM +0900, Tomoya MORINAGA wrote:

> If so, do you mean that I should just add explanation (like as I
> explained before)
> why the function() is necessary to above prototype of ml26124_update_bits() ?

Probably also make the interface clearer about the fact that it operates
on multiple registers too.

--/8E7gjuj425jZz9t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWJw/AAoJEBus8iNuMP3dcr8QAIDRwdcF+a2ufcQuEs+Znh9e
YIq9UK2AjuNKOv7UMXU8qLdDbNVX+nbQ63hGoYGAgBcdBEK2CrfTKug2Zlzki+Bb
meiox6CvTQGwBonPnkgFERb6G2NKL8BcxJlgCfI4lfmzGIZve+rqfEJD7U0LssT5
AybI97a7nPLQfodZbkscSga1LU9uf1ksIYeGLUHiwdpwdtkJxtY/6DStBsNOXmz5
aWpfIl2aIcZG4qfPVXUMnRr/sCGDZos0dgdBcBK7aYvMrvrGRCrc4gFtQOm81TRp
/d45Zm6H08U5EpxcNJSSSgjJ31lpmNyJAS3HjLwaTg2cuF+SHCuqNnAafsw1Nwiw
RqlXYFr5Rl0f3ANQG2t17MkeoL70P2BCYqGm7lzb0Ott/wKkrTvLGt99ax2pm27C
GPvczdQnneLGhQZIHfdMOgLaL0+6gZPyh5ta/lXj7xlY58aNaJNcDY5ELCWWhZag
k1BJOrBfdoZ+3zFCdFxtqVxwguc7cvbIZqSA6GaE9ZMHGq51IH7l2SROx3EiGbTc
zO1lMkHkrUY9ybAKi8gNFtKwRz/1nwh6PrjU6QECTYcYsTZgrbiHmbfaT6vUKJpO
reasi4phDvAXw8zkCzGBnP4iwCepcrnTWE6dXJI/YM/U4pxeZYv7kl/06fRGRPf1
KIiXrjEG1nr7RDxukqjE
=0MFD
-----END PGP SIGNATURE-----

--/8E7gjuj425jZz9t--
