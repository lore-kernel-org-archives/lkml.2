Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab2CEMbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:31:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42979 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756872Ab2CEMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:31:14 -0500
Date: Mon, 5 Mar 2012 12:31:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT] regulator: Fix mask parameter in
 da9052_reg_update calls
Message-ID: <20120305123111.GI3224@opensource.wolfsonmicro.com>
References: <1330682841.4191.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WHz+neNWvhIGAO8A"
Content-Disposition: inline
In-Reply-To: <1330682841.4191.1.camel@phoenix>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WHz+neNWvhIGAO8A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 02, 2012 at 06:07:21PM +0800, Axel Lin wrote:
> If the mask parameter is 0, info->activate_bit bit won't be set by
> calling da9052_reg_update.

Applied, thanks.

--WHz+neNWvhIGAO8A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVLIIAAoJEBus8iNuMP3d1GsP/0J4aifegEenRB2jgA3YRzhX
4NrVoY1/hvDg8oF45vV22ZtN0alcMLWeC6sCzc18d9PwcQqygBOtBPIZeLPPud7P
d2iVwPlObnweaRCLUFrcG2LJN4gUm32k3C5vW1BgPE1pHAFSPhZVZaTR4CqcLGNJ
d2jQxsV8SFyviGL4LZv2x5IVuPzmHtgPhXhMmDtRZ9LCtHniP5RHDfMA0tkEvWYq
wYCVc8YQXU0qMvhL2iAiz6X89Io8aZJ98A3aEH5C4/OyKxKrS2jg61m1rJ3hjzSy
+Sw/lcDO1U6oL/hqbkSwKBCxf2SrzlI0ZMeqyIe6JBg+1z33I1blDUD7Gkf2WAFG
/0SKoFdVkDVVya68hAsypiT3hifXLHkK+RIJbG50Pem6XvmedutGUHrxqTrioNhq
276nItc6DPf/x/wgyakqEbx4Slz+wy4Odjq6ZRYW/UjTqPQ8Dk03+Y0Qh341hYBk
/o7ddYB6pbruOjUcU+1zvQp9jTkdCmAngRY0HFuz3c7pH0H8mIlFmSW533yzLtvP
+X8NNIbEkOcOxV9H/9wBVX1YY+EjiUz3KWVq5cgwTbT8pCQbC2QhCzO6bTdUG7cX
AaKKuPaMTJCR+qsLKc0VG6Jjy296xJSYGJo1t1WeU07+NnxhT6GYjduvOGQAPX3M
UdCO+jBI0yHaCtdXafoh
=PkQY
-----END PGP SIGNATURE-----

--WHz+neNWvhIGAO8A--
