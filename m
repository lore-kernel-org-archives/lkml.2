Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab2GBQDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:03:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56535 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515Ab2GBQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:03:43 -0400
Date: Mon, 2 Jul 2012 17:03:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH v2] regulator: fixed: support deferred probe for DT GPIOs
Message-ID: <20120702160340.GG25093@opensource.wolfsonmicro.com>
References: <1340987595-11288-1-git-send-email-swarren@wwwdotorg.org>
 <20120701182300.GE28922@opensource.wolfsonmicro.com>
 <4FF1C0D6.3010108@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tvOENZuN7d6HfOWU"
Content-Disposition: inline
In-Reply-To: <4FF1C0D6.3010108@wwwdotorg.org>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tvOENZuN7d6HfOWU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 09:40:06AM -0600, Stephen Warren wrote:
> On 07/01/2012 12:23 PM, Mark Brown wrote:

> > ...this just seems rubbish, why aren't we just fixing the device
> > tree code and why are we doing this at the device tree level rather
> > than as a general gpiolib thing?

> It is being fixed in the DT code:

> https://lkml.org/lkml/2012/6/18/468

Is that patch actually being applied (especially with Grant's free time
issues)?  I've still got the patch sitting in my inbox since it wasn't
clear what was going on.

> However, it seemed best to make the regulator code work both before
> and after that patch.

I'd be kind of inclined to just leave it broken to be honest rather than
having a huge comment and dodgy code.

> This issue can't be fixed only in gpio_request(); of_get_named_gpio()
> needs the GPIO driver to be probed/registered to even be able to parse
> the GPIO ID out of the DT; it makes a call into the GPIO driver as

Oh, ick.  :/

--tvOENZuN7d6HfOWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP8cZRAAoJEBus8iNuMP3ddt0QAIEIRmJoIvjMRFVkLLxy4LAm
dug5bC26Y3woFv65AZjQ1gMaqFotfeuEyP81jav/ot9p/odbVXhuDyKyAk5H2+1n
EY5pGsTNOgP48xJvbhx9PpniyLvpFNf1hnzrStaX9T7DaIXHPTlkB8+7wceKmBtZ
gMEqA69KRwh87TV+rkyEYWLyO78Uis6hfIRm2pVED6o/hxFiceEuHxzJsP9QAWgc
L28Z60Js5gkfaHQYI4pyeNI/GBcwoxPLPtgKAVMMg+A1OliaN+zr6VHpreo7H9V7
uo0DIe9jyRPceaUZJbccbKkafW8P0qGEK8vVzJxTscr77cGfVdK05tYaKKoLG1/X
oDfxf76p83eUFUp83hLuxKjAscYYi/FKYtmRxUZiWFWAhXarT+XWiCDZyBQJNCFK
1uFk5PDH40TWzePWECzyGEdKE2HXuy+66mCeag4tT60+th29eSewF5beNhdMXwSS
vrOSlX8A1SWf59ls4uWgyWOj/D7kuWwEctOa9rMFFsSMUcSBXlAYsBZDAnNR2Bpp
17rl+19JLG59FdzUmf5JW4dY95d9aPVkiU33HGIEuZO2Prk0LplhFJ1kbF81Xp1f
oiaP4PoBbmXkQE8j5LCCE1OmaFeNjdHblUCvk4MGFZD5k70XaFDGQ2F+nKumMHS4
PcwQ0Rm53/p2b5vvapxf
=ayjY
-----END PGP SIGNATURE-----

--tvOENZuN7d6HfOWU--
