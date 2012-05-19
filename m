Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab2ESQlk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 12:41:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53164 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582Ab2ESQli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 12:41:38 -0400
Date: Sat, 19 May 2012 17:41:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: use correct device for device supply
 lookup
Message-ID: <20120519164134.GT4039@opensource.wolfsonmicro.com>
References: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Lh1tzOZp3jg2TtWy"
Content-Disposition: inline
In-Reply-To: <1337436846-30025-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Lh1tzOZp3jg2TtWy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 07:44:06PM +0530, Laxman Dewangan wrote:
> When registering the regulator driver, use the rdev->dev for
> getting the regulator device of given supply instead of parent
> device.

You're providing no motivation for this and it's difficult to see how it
improves things.  The class device is dynamically numbered so it's not
suitable for specifying supplies on a non-DT system and for a DT system
it's not obvious to me that we would want to involve the class device in
anything, it requires an additional layer of indirection but that's
about it.

--Lh1tzOZp3jg2TtWy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt80zAAoJEBus8iNuMP3d8noQAJSbx22d9YuPc5evxWuw1kJ+
6sscvkZTpdX6xmxbXNHBDG0Q08C8gO64/F+z2RbfShSGNLdKvqp431UYl82SNTf1
PXeB8rC8sXD74ldnT8xD7Z+FFs5J22tdJMHHVntXqxhAxOz0YnwTk8N2KfGfTCBZ
ea16ve5hJLDMtHhqpZ1R8JgkNvQwL48z09tFB7nUFCRhXI0NDmxmFyPbwc+xRNIV
Y9aFmDycNcEhtc7V4qncR+1AsMr0wIuV79mJiUUm+Oanin17xQtnUCGxoJNjPtLp
q2/xuLutYcGnR4n2ufZ+P4yFyTyEgsFMvmiXCYC9DjgGd2DLmCuWYRb0M2XDsGuy
q6wNc7ihJMxqWbgHCz6ofQ2aAcqVeWksxvf6UzkIp+Mq/oXUPjeoaOlddd4YcvIi
/pvL9hz43A60DQ1SWZn127XEbanAnlbg5BsS+9ZoCazxB6e5mRe+0EzHRP2KHY6l
4zScs6fsi3X3wry1McaSBtuuby4MwEeVwOq7i0u5d2ZiQz51X5V0rVji+ohrZMpw
OnQsx3sdEq0CyutFnQHOHObIKjmKpyeJUMR/cMZcH41c3Y649cYRoWCDBRbPSydF
PXTDqHSGYc0AVZOGqnl1IczMBk28om62iL1n00QFyg+EExH3npnuxk+3/hfO0Tf+
4uo5cpMewj3LxZWZz03y
=Awbe
-----END PGP SIGNATURE-----

--Lh1tzOZp3jg2TtWy--
