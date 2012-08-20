Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2HTRyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:54:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45215 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868Ab2HTRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:54:12 -0400
Date: Mon, 20 Aug 2012 18:54:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: dt: tegra: harmony: add regulators
Message-ID: <20120820175410.GI26991@opensource.wolfsonmicro.com>
References: <1345186799-18229-1-git-send-email-ldewangan@nvidia.com>
 <502E9B09.3080800@wwwdotorg.org>
 <502EA1AC.4090205@wwwdotorg.org>
 <50327242.80103@nvidia.com>
 <50327897.5030601@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/D3X8sky0X3AmG5"
Content-Disposition: inline
In-Reply-To: <50327897.5030601@wwwdotorg.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/D3X8sky0X3AmG5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 20, 2012 at 11:49:11AM -0600, Stephen Warren wrote:

> The problem there is that will prevent any regulators from being
> registered at all, until the patch is merged with the regulator tree.
> That will also prevent PCIe working on Harmony. Those both work right
> now, so that's a bisection breakage.

> I suppose the solution here is to merge the regulator tree into the
> Tegra branch before the Harmony regulator patch. Mark, can we do that?

I've no idea what you're talking about here, sorry.  What are "this" and
"the patch"?  Surely you can just add whatever DT changes you need to
add without the thing that uses the bindings?

--W/D3X8sky0X3AmG5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQMnm7AAoJEFJkBDiqVpZ4eh4P/0Fw5WYtYcn5It33G8liZVy+
99Zi8yNZUFMfhJD32O2LU8v5oVRSz+bOF28udxR/V7Auf/lGj3Obh9kVuP09IuH9
NEBPNzUPdOjVVR5PyEvhr38na7QyRIlxA1vk037GZd/Qs/NYgkPIY3uSarcNGSwV
gG0Ss1EWNBCYb5urrSBEJSB8y7FeoRndaZyBW3Y7ZErIRf6lQnXrZYAA1JH8juP2
k/mowBFoG7BLoa8Ah/B7uiEdrFGDJYSKHuX1470eY7f7cTnzD846plBgDXjdd/t5
jwIRm+8bAKnDZ6gDzBPHT9CQ5NIo/glqpDYScqWQhHcce1ngCi5nTPxYhD2VvP/x
/aMDrcneGDzgbnY1ZK9AYgRtK2iUMegH3irgLYghEQmazFJ3Oe2HCgP5zky2E30J
2pxrf78OoT28AUEpO1bp1oyKg8gnUchHrgY3rX6ws/cku0sJ/3L77cZ29EJsLOzn
Scb/A0aq0lpu67Ye3guoS1a4X81+/gpZdTupZjMRQfmS3ZmCzp8L3Vs2K8l/4FD4
amqaHMqerjDPq22Cub2QGqeiP7mfEaod3xHA+pV5bvr3pWeXqFrXnNywWB1J+0jC
bYtPQTWQiWYL+kTERX3hzq/4j/r4WPJ2g4oJN2k26xF17Ouf3XfBunz/v+1KJiBC
S8jFAjyhYjzWR2GCXvzM
=Ihsn
-----END PGP SIGNATURE-----

--W/D3X8sky0X3AmG5--
