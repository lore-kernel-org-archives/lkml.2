Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2FEQWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:22:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56220 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753262Ab2FEQWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:22:17 -0400
Date: Tue, 5 Jun 2012 17:22:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Supporting non-device tree consumers with device tree regulator
 drivers
Message-ID: <20120605162214.GA14958@opensource.wolfsonmicro.com>
References: <4FCE30D6.7060102@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <4FCE30D6.7060102@codeaurora.org>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 05, 2012 at 09:16:22AM -0700, David Collins wrote:

>  Therefore, we are left with a situation currently where some regulator
> consumer drivers are being probed via device tree and some are being
> probed via board file devices within a single platform.  If the regulator
> driver supporting the consumer drivers is converted to use device tree and
> probed via device tree, then the non-device tree consumer drivers will not
> be able to make use of the regulator devices.

This isn't something anyone else seems to be running into - most of the
world is converting entire boards to device tree in one fell swoop and
sticking with normal style until that works.

> Would it be possible to add a new binding that is handled inside of
> of_get_regulator_init_data() or of_get_regulation_constraints() that
> provides a means to directly specify regulator_init_data.consumer_supplies
> entries?  Is there some other mechanism that could be used instead to
> handle the mapping?

> One potentially binding could be:
> regulator-consumer-supplies = "supply_name1", "device_name1",
> "supply_name2", "device_name2", ...

Well, we certainly shouldn't be putting this in the device tree as that
rather defeats the point...  Some sort of auxdata style thing would be
possible I guess but I'm not sure it's worth bothering.

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzjIqAAoJEBus8iNuMP3dphcP/iDwIfk3Dx9OSqi2+fC8lwAe
MNo05DbLBwzdZLe8gakVYVdmArIEYLnq+yk/ZF+nFHOYy6Wt0gpOtrt1iRcYmyKq
USo1Spter6TknXXOftjyw99tXX6nxvLD2/pbgDlVqfZYKMCqHEk3VPvGceS4qA0S
xOdM4aQkHIHZlS6BDbTR0LW9V0exU72Ikx2wedfp2ChwyAxf59pDFoBpK+foRg0L
00j6pfjDFHXLH7uxpY/gu01U+fK5OIs9x3ddae8G0J93s/YWHgtLzOwCwQUOFWcZ
1xZuXc+e180/WPF50aXBTUgeJ9WHNIGFmNTz5HiMIOGZhcvJW1GJvoGqKCmJNNvX
chlGsqV2jJX4oGSJiP0kgFZCCnhvds0NrpTYr77gvnkCUHhTXzhqpr9wNvwKOfqx
lVT/fXzEm4+YJ9X+zHyEMj5N8N72dX1p5rd2R+fRW77avf21XfG0mGIjd5YEtqGk
goPSo9EvEReuvzC3Aq2kn37IqpJGp9z7OUlvU1iES0Y45QjUahh0+u0Dw087uZlM
fm/VoqewsGrZlQ4z48U+HB8Q5oVq6GCOhBJIkmO3vTln6KPjH+be1wGRIIKPBWb/
K9G4cIlh6KqXZFmB8nw3TO9om+pOSWUlTIAxG8WVuVo/GI8uNQgnUbtlSlQtJIWg
BUzYy5wtuay99h5ePRMQ
=4tzb
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
