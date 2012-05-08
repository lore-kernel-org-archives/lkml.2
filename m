Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab2EHQsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:48:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51308 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541Ab2EHQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:48:49 -0400
Date: Tue, 8 May 2012 17:48:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 0/6 v3] Update TPS65910 to boot using devicetree
Message-ID: <20120508164845.GE15893@opensource.wolfsonmicro.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="03sphU6jKm9HdgU1"
Content-Disposition: inline
In-Reply-To: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--03sphU6jKm9HdgU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 11:42:37AM -0700, Rhyland Klein wrote:

>   mfd: tps65910-irq: Add devicetree init support

Actually, it's not really relevant to this patch series but looking at
the code for the interrupt controller here it looks like it could be
done in terms of regmap-irq.

--03sphU6jKm9HdgU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqU5KAAoJEBus8iNuMP3dmfAQAIXWFmrMLTLeARZmP90SCOhM
SdlhKVW3SK9smFOKh37GYMsooZRjSwXFECizKqf4t48I8tY+WLDmT0ljQDhWKA9P
YMpY498RRQLuKwrSPkN7/EQNQal3NNyZTVZnKwXzDtk15Ir3RXd8AIz41S4e7poF
YoHN24ajswOcDzzRntNCU3mp/054lvtm1yt9FQPksNPe9kNMws1ckd7qn76cXO7/
T15ftmHQ0/NZMmtDvaWZ6iVLQuIWxbzjHJDNUpRhinxUKcl9JtuX/7o1NFuzPk+9
RUTkthQxyyKKL6G2gwPTRNaC7YdlQ8F7YWs/MplZyIHD55YyxSrVfYaJau7B3qXQ
1yb8qjTWj2SinBScVdAfCOVklxVCDWeiCxQ7AHE32jLhU/Xnf1tQHo9cpGE7M/kp
IGjHDcAp64i3m4jz/RqNLXkHRlvuM9Dy6iDaw+tRSFxzj8G+FJXJJWf45ukcWzN5
EWj5/kZuoIDor89Fv7UQDK6StZTUwpia0fJJ4vRN7B2gd0ap9hw0uNKXZSNoPjmY
QF8q9F1xR6FhKsD10MxO67FYyIN3SvcLqim6jLwWjJ7RY10/+5rkELPNh3e+s1Gv
su+PsYBxuwdhMH1oG9qi3mHB3VR0nUfcilQrlYYXvvOFOoO9VL0HJq8zF+2be3hM
b4GyeIOo91dL60Ja+hlJ
=aKiT
-----END PGP SIGNATURE-----

--03sphU6jKm9HdgU1--
