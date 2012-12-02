Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab2LBCeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:34:31 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47170 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab2LBCea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:34:30 -0500
Date: Sun, 2 Dec 2012 11:34:24 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: arizona: Defer patch initialistation until
 after first device boot
Message-ID: <20121202023423.GG17981@opensource.wolfsonmicro.com>
References: <1354381913-26146-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H4SyuGOnfnj3aJqJ"
Content-Disposition: inline
In-Reply-To: <1354381913-26146-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H4SyuGOnfnj3aJqJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 02, 2012 at 02:11:51AM +0900, Mark Brown wrote:
> Make sure that we don't race with the initial device boot by only doing
> the initialisation after we've waited for the boot to complete.

This is broken, will send a fixed version soon.

--H4SyuGOnfnj3aJqJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQur4gAAoJELSic+t+oim9/8IP/1ssdMIIE3Sqd35M5d3OgZED
gbMMMCRnqF9DvA3nmm3uxSn60ibpdAub9uW16UvKdx+tcTBbDFJ9scn0obiWbM46
X7+oxCmo1LFs6r2bPV275NXoPjPUtBXEP1G9LwHcBWfBkTd7vBAAQXRVpuLcz36d
JGu2nbRFJa2xH9aQ6fMMWpCCwzyEcnM8fXpQjf2mA7T0+MIHc4zjuo5F10mXye//
487n5+coNaXopvMw0PdG6NKpXYkDXf4b5uc5wsxXCTtKZXvxfptV7IABL/Pdt3uv
tDUKghDszjuC/BMAlwcShKS5hzy9dMaYbPiNP/Q0v0OVV31VhJW0byV0HhA06XRI
9p87Ayl8jRVvCZcHK3fUacWGbQyj4fGoKhK2oKevSp1CgjgKb7JQ60H3SslbFaBD
33MVs/VorR37cjwSH2lr+MyL4/5CxPSvYae+0E7EBi80eLqnu35mtl4rH+Hcb9/r
Litfb+c0X9PXM8zOtM4jG3bO72BXhB7OGC2eSBeneUbrXEaFzgJgzJDpLS+cEycp
5FBFc/+/i09U1YY0gMU3c3yRRTI7vhmT0pYyzGNhxgdCD/VADtMoPX07sRmOl1P8
C27NzwDl1aHaAlnz/6C39UVXNy7VqNNGjcwfEJsBjfGgHqqnz6XWieyMIgIw5mix
qTGBCKRBcYqJ0AKCgbKp
=yItD
-----END PGP SIGNATURE-----

--H4SyuGOnfnj3aJqJ--
