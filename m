Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2AYMuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:50:24 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48044 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab2AYMuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:50:23 -0500
Date: Wed, 25 Jan 2012 12:50:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>, "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2] regulator: tps65910: Sleep control through external
 inputs
Message-ID: <20120125125020.GI3687@opensource.wolfsonmicro.com>
References: <1327489068-9460-1-git-send-email-ldewangan@nvidia.com>
 <20120125124250.GH3687@opensource.wolfsonmicro.com>
 <4F1FF9EF.9000004@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AptwxgnoZDC4KQWS"
Content-Disposition: inline
In-Reply-To: <4F1FF9EF.9000004@nvidia.com>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AptwxgnoZDC4KQWS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2012 at 06:17:43PM +0530, Laxman Dewangan wrote:
> On Wednesday 25 January 2012 06:12 PM, Mark Brown wrote:

> >This really isn't what the set_mode() API is for - especially the fact
> >that it supports turning the regulator off which really isn't what
> >set_mode() is supposed to do.  A generic driver using this API isn't
> >going to play too well.

> Then what should be the method? Is it through the macro similar to
> patch V1 where LOW_POWER mode option come from platform data? The
> idea  is to set the regulator in OFF or low power mode based on
> external control.

Like I said we've got the various suspend callbacks for setting the
behaviour in suspend mode.

--AptwxgnoZDC4KQWS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPH/pwAAoJEBus8iNuMP3dIewQAILgQll5a7NUoiobDIiXvWFy
mL7YPabxYtTgclVOkeFLE298KvUgZtOa7l15aeovOcUkUlP9fh1Lw/fb3D/P8w/X
OMcxkMFb36w4gB6ebnYSSCF82tlD557OoBXFotqtk+4N/eTV/YyvYnGoesC732NB
PmuZM0mNUfNH2+b+H/hr7+0DeiN9MnXHRbuCYIJ4zwPUL1rFhF42ziUXlgXXC5kX
842hGYs1xkCdAqscwSXcEfM6fWqBkCmEoGSGOXjc9tFuh7mP/0bRmV3pphHvajKX
wxYxr6JX3gnCaM0BuUJLXlQgb2sKv6OsSVMZA+QUURxda8qYVoTXKJB/gDoXH48D
Y4IdxUMxQqHB+XqCwrIWVVAP4PAOsQ6Chd99amK4jNUxZVs67UwF835SqPJdjv0g
nS+ABwWKdx4rxmXvbEWWXCpP16RAzQxQh4AiW/37zzCt/fOdziLWGSQEub/ybc1u
frXfDLkst+Yi3gXQJgc0fJlN8acMZZA/bVmQsKdzCssTQMVx9sm5eLS+hAmDNtYZ
6xMcaeY8me6nKfO1y5mQTX4ttwpdZ3DxI13pFBYRGn1RLrpR3ikh3BaoBtO3Tq7i
Is8E3X/FRcUZDgAXDa2Fqt0YSDtbdAuCYuOgz+4ZQFjVweXd/pwqeFcO9nmo7bII
GwNwC2R9QZn7WDlLSVlA
=zBv4
-----END PGP SIGNATURE-----

--AptwxgnoZDC4KQWS--
