Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2KZOLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:11:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43392 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996Ab2KZOLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:11:10 -0500
Date: Mon, 26 Nov 2012 14:11:08 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        myungjoo.ham@samsung.com, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, t.figa@samsung.com,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Rajendra Nayak <rnayak@ti.com>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/3] regulator: add device tree support for max8997
Message-ID: <20121126141108.GK9411@opensource.wolfsonmicro.com>
References: <1353657795-1725-1-git-send-email-thomas.abraham@linaro.org>
 <1353657795-1725-4-git-send-email-thomas.abraham@linaro.org>
 <20121124175954.GI4719@opensource.wolfsonmicro.com>
 <CAJuYYwThsFutYnYg2scmfqUAGxBM2pWmRmoTww+OyZgUuA-7vg@mail.gmail.com>
 <20121126095141.GC9411@opensource.wolfsonmicro.com>
 <CAJuYYwTt+1-zU3092GmrK2GHR=5QDGT-diVcm_0pe3=oqhuQdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwbb4r/vLufKlfJs"
Content-Disposition: inline
In-Reply-To: <CAJuYYwTt+1-zU3092GmrK2GHR=5QDGT-diVcm_0pe3=oqhuQdA@mail.gmail.com>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rwbb4r/vLufKlfJs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 07:16:04PM +0530, Thomas Abraham wrote:

> and this patch applied cleanly. Could you please let me know if there
> is anything I need to be doing differently for this.

Hrm, try applying it on the relevant topic branch.  Your comments about
rebasing on top of MFD changes did suggest that there's something in the
MFD tree so I didn't check terribly closely.

--rwbb4r/vLufKlfJs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQs3h2AAoJELSic+t+oim9AtgP/10VI9DIlzQbgxCP+Z9lhDAA
d/yaGwkRUiuwFPZiz/skVJ1kE2FBPiTi/KoMfK5pSjC12cpF/D9HmBF+YdhsUo60
ykIbJyP5RfB3vuLzXITjPPAxIZ0IUr2AjXXY4ILezVXRxeYyPv3t1uQC0vZ9vJW9
L528wCgD6ZkwUKjE6ISkKWHhdRjRyhNVBCI4ct9SSqKHWIeAQ4sVAWsLu8U75RZm
ZtkManT/UcSL7XzDh/G1tg1jsNvTkbtitGHEw26GqBMVW62FcEsJ4WcgOnE8MqID
zqFdrUoQKGZMbDJjnQAhZw+uXW5WYgj0zAEPnSmkLkOuiqfJB+5UiHrNahyr2gYx
+avRMM/PfF+HWMSS/VKCYd28/0S34ICUDdLLyWc0WqwlnyAkLgOn6NI9ODPjiAG3
8RlZiNLxQq9og9S8uO/9+lhSr8qvv2X6xWNZtsCWCle+dqT8XQyfsGi//xka80eB
nWacTF+hNPx2fNuxv2Lecu5CerIq2ZiSw5iGYFvUG1cxG/uVl6voWDmSraYobF4T
bEzONtpyoStNzf1v1YrEr7XNnkzszCToGPcGmER0vr2qUEfBwHq03FQL67xeM3WI
y8go8saV6RdjxAxxFTk6hhZAnm1WBO4DTCyq3EbRAmnQIROxoxEG6utgas+yGY/A
rYPnSUhjLYXgKjwO04cs
=bmIr
-----END PGP SIGNATURE-----

--rwbb4r/vLufKlfJs--
