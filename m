Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906Ab2COMqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 08:46:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34292 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760121Ab2COMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 08:46:33 -0400
Date: Thu, 15 Mar 2012 12:46:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Simon Horman <horms@verge.net.au>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: notify sysfs when voltage is set
Message-ID: <20120315124631.GJ3138@opensource.wolfsonmicro.com>
References: <1331813073-714-1-git-send-email-horms@verge.net.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MFZs98Tklfu0WsCO"
Content-Disposition: inline
In-Reply-To: <1331813073-714-1-git-send-email-horms@verge.net.au>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MFZs98Tklfu0WsCO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 09:04:33PM +0900, Simon Horman wrote:

> This allows libudev to be used to monitor voltage changes and thus allows
> user-space code to avoid polling the sysfs entry for changes.

I notice that we don't generate similar events for cpufreq...  what are
the performance implications from firing off udev (which isn't free)
every time we scale the CPU frequency?  It feels like this might be
disruptive, especially with a governor like ondemand which responds to
system load.

--MFZs98Tklfu0WsCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYeShAAoJEBus8iNuMP3dvasP/i0PqANwn4eiUz88yCQZc46m
tSmcH7j4U+3KYJNK5fpl/GS5Imz/nnG0NdLsyNZ2ATlB+Y1bcvIweTGHMAkQWBYw
LLobuOD8Kvbf7E1ZTed8dtqmSfKpGmEMdRjiyANvMzyM1Oy5Qp4UcRIhrwQknTZn
25Frv3/4WV6Vneu3PXoDI0WeYMMnxZKOZR8wgA4mZHfaMsWSzKuufZk568emmDO9
TyiHSLYXJlGHR559/xTW1e989x8MVGR3A210N2jwzeDeHk/Y72ajFNhPHX279vpS
MV1rZofMy0GD1rRCnHNltx+IJH1AnjbtDYL3xqhjO/ElFvZTpJCELC7QxzWBSYvr
2G1L/UXpdBKF/90dBvXlgVrurTMfZ3Cl+xH4Knb6lqo3EqjlWiQdPTDItPdiy+nh
A47fJ4KcC5u8YnQfqqNUzlozw77nz6BIaw2X7CU8ERX/yVodJw2I6h/57e7p8giY
iN4Uplb1ijteONY6arSWvk71kShgOTy7tiyZN/iE6VnkvRPc9kpuqc60vgJFkxh6
f//aVOJ5FpEv7dkbtbhSGf1Z+rX26Gm152VuU6TT0sY+2ddVhDqwi+3IbpCQYkvT
6k2M6JrO+NHSKh27/VPcI/HHG7GhEi7XjD4VlI+TjaAOY3Y+O77ZQ+cRalZZ/Zus
bHMpZ5lGKppfnKEmhpm6
=rkmv
-----END PGP SIGNATURE-----

--MFZs98Tklfu0WsCO--
