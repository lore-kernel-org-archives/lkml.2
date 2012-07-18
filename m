Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2GRKdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:33:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60235 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458Ab2GRKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:33:15 -0400
Date: Wed, 18 Jul 2012 11:33:12 +0100
To: Lee Jones <lee.jones@linaro.org>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@stericsson.com>,
        devicetree-discuss@lists.ozlabs.org,
        Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
        Deepak Saxena <dsaxena@linaro.org>, linux-next@vger.kernel.org,
        Alessandro Rubini <rubini@gnudd.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 i2c-embedded tree
Message-ID: <20120718103311.GG22739@opensource.wolfsonmicro.com>
References: <20120717130650.GB27595@sirena.org.uk>
 <500568D9.10805@linaro.org>
 <20120717133550.GC4477@opensource.wolfsonmicro.com>
 <50057058.2060002@linaro.org>
 <20120717142222.GE4477@opensource.wolfsonmicro.com>
 <50057C1A.80606@linaro.org>
 <20120717152001.GF4477@opensource.wolfsonmicro.com>
 <20120718053341.GA4009@S2100-06.ap.freescale.net>
 <20120718095937.GB22739@opensource.wolfsonmicro.com>
 <50069006.8050301@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oXNgvKVxGWJ0RPMJ"
Content-Disposition: inline
In-Reply-To: <50069006.8050301@linaro.org>
Grom: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oXNgvKVxGWJ0RPMJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2012 at 11:29:26AM +0100, Lee Jones wrote:
> On 18/07/12 10:59, Mark Brown wrote:

> >It's not the using device tree bit that creates concern for me here,
> >it's the fact that the board and silicon aren't being separated.

> What's the difference?

> >+- db8500.dtsi       // silicon
> >\=09
> > +-- snowball.dts    // board

I have glanced at some of this stuff in the past, thanks.  Now think how
that's working for people when they put the configuration for the
silicon in the same DT node as the configuration for the board...

--oXNgvKVxGWJ0RPMJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBpDhAAoJEBus8iNuMP3dFEIP/jEMNzs0CKNauFphjis+a6QJ
TpT4kfXjyIR0U2mnM9iQNRcHf7ivaPOm2pAKR+eDxe2lQmT2MFZ8WzTsEfE1qMhZ
AYVaIN67XOg/c20wJAl0sIaTbx4zT00v7XgkynxLlnA98/kkQ0UfBYyHkPFHpD9b
YWTS7dx4QFIDBvn8wl1ZxbplakjUV4WP0qGZKlg7egCv/me7GwBc0fhWrgLYX8KO
aTol+6tvUIrwriqOE15/xifPeBFNZ4UIuRlnNBi94G/JfYcZ9d0XGj6FBQvZmT0W
bSfAuuGoBw4BY0DpgyxhF5r+d/yQcQv4LuhPQ/k33Rc9WRwda1Mk3VZgnbqP9ofI
2OIEidLi5ViMuXtkvnxrIVIhinbpuRq86S40PlD7Do2tvGbFGFaLFzqIW5JMTB/B
9klM0JZzzBb/vPpyuSjVL4KZlkeLHQ7cpMgGeIaK/+W0oPYDonsJlBknvlRcnuv0
1Ham37TsX+uJ2XM4MENj46Dkyt8ceUxNCPQ5WH8DPZNaDWS8Mwpgq6sOdsbmQg9T
17WTyJcAo/eCbK5QpVoW4X42ZVwwQhq4pmnqn8rLLHH/OR+wGMgwZTQEgOlUA/Z3
YmxL+ZPUCt6JQ08yDFl0HmbhIbuomRr0A7IgmK6w5R+ZJF6dXcIQ4OdePQKr66HU
ye4N0Xg/rtVereMyb5+9
=AqvO
-----END PGP SIGNATURE-----

--oXNgvKVxGWJ0RPMJ--
