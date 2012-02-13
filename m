Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab2BMQ4Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 11:56:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47878 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab2BMQ4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 11:56:23 -0500
Date: Mon, 13 Feb 2012 08:56:18 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: gpmc-smsc911x: add required smsc911x
 regulators
Message-ID: <20120213165617.GE3494@opensource.wolfsonmicro.com>
References: <1329151422-2146-1-git-send-email-mporter@ti.com>
 <20120213165209.GA31482@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uCPdOCrL+PnN2Vxy"
Content-Disposition: inline
In-Reply-To: <20120213165209.GA31482@n2100.arm.linux.org.uk>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uCPdOCrL+PnN2Vxy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 04:52:09PM +0000, Russell King - ARM Linux wrote:

> I think OMAP (or even the reg-fixed-voltage folk) needs to create an enum
> similar to what I did for 8250 to control the allocation of platform
> device IDs for this, otherwise we're going to keep on running over this
> problem.

> Added Mark for his comment.

Hrm, seems slightly icky but the enum will work if we can decide how to
add elements to the enum since it'll be easy to bloat a lot it if it's
central.  It's tempting to suggest just using a random number to assign
the IDs randomly rather than have a central registry but obviously
there's no guarantees there.

--uCPdOCrL+PnN2Vxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPOUCSAAoJEBus8iNuMP3d1BEP/jtzpCV4W0xprw/IUvPMhzz2
qdwckeGHx5TGzGMlpemvA0EG5h6ZIt+xtVIAkTfvEmOqL48wT973aK7J3kaWKdwH
Cd0tb1Yxl/4BF+cgniyaXtEP2M3fIDmTN1gtL76N3rRLdT9Tupf9l36PqNEAmy1N
1md27+VsDD+1y2b6m0hT8dmukDXvWARld0rwCI6rwjjcjgku8908avQAR0GCFZJa
U763nDF+XRHfSIpzpuUlYLsTDSS2JFlbGg35fgUGr+vWnY/38iEoeRRMyPAN8U6Q
xGTYuuWwUMmCLefrva6ld4tJXTe9kyEKxs7Plv/KDs6g6oaiQ2os8EoPG/GjPvkC
6eEMeniAVvFmRwH3+1wLSy/lAOBWW2sFnq2hL/fIV8X+HUu+x1GH38Sfi8e4+M9W
4VIkEckrygUj2gwgBLuOtvkoG4Qk1j3CoAoJgFxqHL36CxkwlUSN1D+vBFSzhgjW
9JrQFEiWvyY5fP/Tc4x8G7o9bmBugbDcoRGAY+VWL4WbppBPdOKvGpHEll8ljkdf
Awc/FNo4mh6PEd9k6JANvjUA3BQo5rWmUsriaz316rnSTf6mPcXx8NJfZZOF/f0E
Yx6gf45sNLhB1IWAm/oWNJvQlZz85OHJV7eHKuAaz8nJs37WgswBxqM6FkLEsnjB
4yNR7szTEbSEumCzPNlG
=r0tG
-----END PGP SIGNATURE-----

--uCPdOCrL+PnN2Vxy--
