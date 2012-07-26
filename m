Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2GZO23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:28:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50417 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751502Ab2GZO22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:28:28 -0400
Date: Thu, 26 Jul 2012 15:28:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, sameo@linux.intel.com, olalilja@yahoo.se,
        ola.o.lilja@stericsson.com, alsa-devel@alsa-project.org, lrg@ti.com
Subject: Re: [PATCH 20/21] ASoC: codecs: Enable AB8500 CODEC for Device Tree
Message-ID: <20120726142825.GK3099@opensource.wolfsonmicro.com>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
 <1343298534-13611-21-git-send-email-lee.jones@linaro.org>
 <20120726115055.GD3099@opensource.wolfsonmicro.com>
 <50114D71.9060700@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ry3qE+viRNtbc3l7"
Content-Disposition: inline
In-Reply-To: <50114D71.9060700@linaro.org>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ry3qE+viRNtbc3l7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 03:00:17PM +0100, Lee Jones wrote:
> On 26/07/12 12:50, Mark Brown wrote:

> >Yet again no binding documentation....

> RFC. ;)

> I'll write the documentation when/if the properties are accepted.

No, write the documentation.  It's way too much effort to reverse
engineer the bindings from the code.

> >>+		default :
> >>+			codec->ear_cmv = EAR_CMV_UNKNOWN;
> >>+			dev_err(dev, "Unsuitable earpiece voltage found in DT\n");

> >The platform data code picks a default, can't the DT code do the same?

> No, I don't think that it does? The original code returns -EINVAL
> unless a value is specified.

The code doesn't specify values for the enumeration so it ought to
default to EAR_CMV_0_95V if nothing is specified.

> The original author is keen to have a clear error message in case
> users try to specify non-exact values. I'd rather we fail-out than
> use incorrect values which would be a great deal harder for a user
> to debug.

By that argument all the properties should be mandatory but it's only
this one IIRC.

--Ry3qE+viRNtbc3l7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEVP/AAoJEBus8iNuMP3d4OAP/3dSjzRTMkWkanupN3zmIKS+
20DJ+p7U12apePR7+fXAUi3uJn5htRClpwJymyYNPTIcd0Q55647dqxOF7PX8bmt
pOBAeSyMbTBr05fMuOlp3YzOnR32c7/nO80100x8K8oJ8+oC7wS3xnlVrAermTiq
2EwE8PlFRuLVB58ROttdxzmORyxYPgyaon9UH9MPSTW9SmA1FkSAIEp13bojx3V9
TAuA/g8ItWPTW7vjCPytxBmH/wshwoI9SaIM/OZRLIGVDc2De7XYDla1uPa0Joy2
boxyB791GYs05hhGK8xKpkyDPtdbRyQNdYFZuOUIPf4X//bnHyOFEZFCxB2qW5+h
xhFFmlV4x/GpMNTZUyQe4xNTXiscCOw+zexu1r8uTi3KpyHoOzdel1H5pJV3jgFr
GMBAH+Vkz/7FubJ91lh2eOu7s4dL5C1JOR4IFMoym/SJk6f6HJM0W6sD8krFpx6U
aMoL52g+BnTm9/boB9rqQd75cMbbnmLF/QM/D6sDzxE3mV6QQtDV1eCVjE/RIw6+
HwXbKiSbTZgiAHKfJcumcs1ws+N+9NE7B9OZqi2MhvXWzrE1hxF9qU1tpl0dfYy3
ujncSTs07vN6UuIW3ymdAF3YmQNBa9rHoIQ/kD8NR/vwABTnbrAHixOa+/fm0IAZ
u7YBVktNDnjWCm2QFRTn
=0Ho6
-----END PGP SIGNATURE-----

--Ry3qE+viRNtbc3l7--
