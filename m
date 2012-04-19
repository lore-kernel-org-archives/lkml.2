Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab2DSQeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 12:34:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45848 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab2DSQeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 12:34:07 -0400
Date: Thu, 19 Apr 2012 17:34:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rhyland Klein <rklein@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 3/4] mfd: tps65910: Add device-tree support
Message-ID: <20120419163400.GB3084@opensource.wolfsonmicro.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
 <1334710829-22777-4-git-send-email-rklein@nvidia.com>
 <20120418090133.GC3021@opensource.wolfsonmicro.com>
 <1334777758.32315.37.camel@rklein-linux>
 <20120419125041.GH3046@opensource.wolfsonmicro.com>
 <4F9030D5.2050601@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <4F9030D5.2050601@wwwdotorg.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 19, 2012 at 09:35:49AM -0600, Stephen Warren wrote:

> That's not right - the idea is that pdata should override device tree so
> that if there's a platform where the DT is known to contain incorrect
> data, then some early platform code can add pdata to the device to fix
> the problem, and that will be used in preference to the DT data.

> At least, that's the last I heard Grant say on the subject, and that's
> how I've been writing all the Tegra-related drivers, and I've seen
> others do the same for other platforms.

Ugh, this is just leading to horrible code here (and why on earth aren't
we just implementing fixups for DT data?).  Though that said I don't
understand why the code here isn't just checking that there's platform
data rather than setting a flag that says there's platform data, the
driver already needs to use the presence of platform data as a check
anyway.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPkD5xAAoJEBus8iNuMP3dcskP/016oe0W0ouqqMi2OIsR1NEp
RELcbSsTHgnhTu3DNl9dM/gl5kGStII69D5H4cdDXhNpsnCidVpGQ8pIy4D5/0jz
UkPXYCASSRL5ki+sjxxGw55C1MxkCXxp1DyhN6m812A7Ms7cQEQBG93wYeRz8KrP
jX6vSsUKMYIf0xx0Zl4RYFbw/mSfzdc2gL4Zl/mQYgl63lhACmKufh9wTwy5p4Gk
apDk9ttqd58/vMO8jdTCSJnS1dRwrehzlfQAKo2Nq0GG3T8Zx9B7QfEca6kSM/cq
o995VNut6iOaTd6gbvB8hqavICRYBd6xIgxKJcrM4GMJhFbT4VNwye6mdnNZLe1m
7gCcv/nG/GVSq+1rRxl3aumFLfN0feoWyQu5e6kLpNMIM5sl/XJwe2R45LCF3qB0
O55CFSnRlSETGPU/qGVpWc/6Yq82/Oe4H1+a1weJMHE9Aj9ojrJExviQuBf7V6aI
JxDeyBG8/Ynveffo+utOtZ7JArTD/ra+JzUmyylzXMuXuPenhU/5saSuIBd4S8N/
M+y+yY7ZyxYVh6H4WwohkZqbnvspXHeCMTPVQbtmpvYmK6exZDnJMHgMJuTBRJd9
pF3gPKuaExc9SF8vVvIpZAhDdvJ9QEIprbeEUtLTghXx8HMw8JMDK4xUxv2qHkc1
Wte5X+6fCcjqKhYRCaWD
=ukjw
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
