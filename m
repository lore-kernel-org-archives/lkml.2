Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab2DBLeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 07:34:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41006 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab2DBLeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:34:16 -0400
Date: Mon, 2 Apr 2012 12:34:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rabin Vincent <rabin@rab.in>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120402113413.GA7560@opensource.wolfsonmicro.com>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com>
 <CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com>
 <CACRpkda2zh=zR+A9bwhRXYHtQdFeUpiqG4d5g1i82mPCs1mXaQ@mail.gmail.com>
 <20120402101427.GA3172@opensource.wolfsonmicro.com>
 <20120402104357.GB24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20120402104357.GB24211@n2100.arm.linux.org.uk>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 11:43:57AM +0100, Russell King - ARM Linux wrote:
> On Mon, Apr 02, 2012 at 11:14:28AM +0100, Mark Brown wrote:

> > I was waiting for some pronouncement from Russell - looking at the git
> > logs it seems the patch tracker is the normal way to merge things.

> Well, this stuff was invented by Linus, so its Linus' decision about
> how to deal with the power control.

Linus already acked the patch, the question was more about how to get it
merged.  Since most of the AMBA changes seem to go via your tree I've
just submitted it to the patch system as 7366/1.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeY57AAoJEBus8iNuMP3dGg8P/Rg4W9/NSJqDzVr/fHBrhbIt
B1ltzE0sWDzSCEV9IfKM68m263gOPZM+ZdnA3M+Il2bWTDsU/J20Tw/WZd1v+Rmx
XjClRF7PWE7HIyxdUFNIlhfR5AXjdHlFViBbtzjl2G03JeJEQCt0HlMmXrBI+myG
fG0UwWTnzsajaHltIqLmCcrNPAGvbqCqdJT1Xejam6vaYnC3+T2CCkxVQ6YI5mnB
mhhCuP44dEtMcAm5Nvk63o3Z98EbjvyAETWgNpxiSr0WWRCeJh6tjQ6l7zMYRLXu
Rb9AZIRgR/ZajZ1c1/Jwv5o6C13kb32prluMpGv3Vc5JzA25dpM2lDYCVfU57pny
4B9NWrZy1VdArE0lR8Xa2KE7QmXQtnIhuXla7BOQ0of3GXZA4n3FsH9ljLBTXr7o
9cOxGE8DYkKXKmSIqvfi8UrjuFT/u7j/ZuKzj9UZiH8Oqmi9VzSiqYzWSRk4TzjV
kcXKKZXWPouozuBlCd88HYU75w3a2QsKuWPyLrxoAAP5fW1wAKPIQujPatdXT9D3
itbxt2mIe4qg0XcDmfn7p2SDDkjFwbrwy/ocWtdfAHDMFizCDMoyMIW0hf4MehlE
NiJvk9vzgDyI8Fc3/valOyWOxuSuyICAhjP/zHwQEcLHggnKzxPDWiOEsY5J9/o1
2sUiAZ3jh3ykINwUq8Hr
=zNu1
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
