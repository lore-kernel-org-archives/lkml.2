Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab2FUTpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:45:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40021 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755355Ab2FUTpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:45:47 -0400
Date: Thu, 21 Jun 2012 20:45:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by
 regulator-compatible
Message-ID: <20120621194544.GZ4037@opensource.wolfsonmicro.com>
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com>
 <201206211450.35713.arnd@arndb.de>
 <20120621161459.GY4037@opensource.wolfsonmicro.com>
 <201206211717.46142.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hW3Q5Oh0pcvvyJMS"
Content-Disposition: inline
In-Reply-To: <201206211717.46142.arnd@arndb.de>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hW3Q5Oh0pcvvyJMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 21, 2012 at 05:17:45PM +0000, Arnd Bergmann wrote:
> On Thursday 21 June 2012, Mark Brown wrote:

> > I'm not that big a fan of moving all the data into device tree as it
> > means that you need even more parsing code and you need to update the
> > device trees for every board out there every time you want to add
> > support for a new feature which doesn't seem like a win.  Right now with
> > the DT kept in the kernel it's not so bad but if we ever do start
> > distributing it separately it becomes more of an issue.

> Right. It's certainly a trade-off. If a company makes 100 SoCs that
> all have similar-but-different regulators, then it should be clear
> win to have the driver be very abstract and fed with DT data for
> configuragtion.

Well, nobody does that anyway but even if they were it doesn't help
non-DT systems at all, nor does it help when we need to go and add new
properties to every existing device tree using the device.  We've got
far more architectures don't use DT than do...

> > I'm also not sure if the tooling works well for allowing people to
> > include standard DTs for chips and add new properties to nodes for the
> > board specific configuration, though I think I've seen a few things
> > which suggested that was dealt with reasonably well.

> It should never be necessary to add board-specific properties in the
> nodes that describe the SoC specific bits. What I was referring to
> is just moving the data that currently resides in the regulator
> driver into DT.

How would this work given that we also need to put system specific
configuration for the same devices into DT?  As Stephen says it doesn't
seem to match what we're currently doing.

--hW3Q5Oh0pcvvyJMS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP43nNAAoJEBus8iNuMP3d2V8P/0usS0wLEF7W+Tqz2ab9WkaL
n876EnQ22tmu0kN00NlYqAD1H5n/2UQZoaLPuCd0tYp4wli3L1EfDpTYGvz/CVfu
WxkwIjxPBwK2rCbXbB6LYe1iYMY9vL3Nez3xpohyXxb6Aqt/hvifKwBUxdkb85J4
PXpWXdsZk7kdiU+9ipx+D90Iu1Uls0IM4idbDQSVuLB8XcS65FlwpLoMHzQ3Vw47
R40vjq3T2LAnq3d9Gp12F5pkVMN9Q3Naclgci5t+mV23+jwotpyXe0MQxmpxYTz/
9ISDPVrwFniv1Jc2PH6PhuecvMmBWXCJ+8Q0ccDqDE9EWkcc6NJa0phVnCzzyb2D
eJmM2MsO5FhS6BDoUNZVC2k8+dEX1WO4StZ1EHWhkH5uJMaGcHcN3tJSQVELfOM8
fuuOYZVzyZvGSaccH2kohnVkI7LyaM2aAG4F218cRgBvYMuLXvsCBQKlk4szzFWZ
TbyfPbmlw9iwu/lIJIEUBPYBrlfmInAdlPEwzZAtkykLQcyqoqDv55+QAXwT3MeH
Ul6+L9KZIlmFQLaDt9CVE/RF7zj5yfECL3ESyjP10SOQ6T4hnFdEk1zYh8CtX3JK
4nL8aXovWsZTECkgg5ND8PAOSXdWKchhDuN/uq8tIVNxm/behzmD4hJLCRjZ/gAZ
f671QyRqwNE0VPjqRGjp
=xRs7
-----END PGP SIGNATURE-----

--hW3Q5Oh0pcvvyJMS--
