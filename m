Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236Ab2CMXUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:20:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48511 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752785Ab2CMXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:20:11 -0400
Date: Tue, 13 Mar 2012 23:20:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max8925: Use DIV_ROUND_UP macro
Message-ID: <20120313232005.GV3177@opensource.wolfsonmicro.com>
References: <1331626168.3932.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FfX2iGK5t5ehHnsE"
Content-Disposition: inline
In-Reply-To: <1331626168.3932.4.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FfX2iGK5t5ehHnsE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 13, 2012 at 04:09:28PM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP macro for better readability.

Applied, thanks.

--FfX2iGK5t5ehHnsE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPX9YUAAoJEBus8iNuMP3d4zIQAJHZ1rGDVHq6/LFls3ZsO0VK
r6Mclp2iGsne6fw71Argpi9QtTr0dUDHecfm5xgwhv1eF6p5kiGMxOv/HVnOUBGq
MUYcwMMxRxDwAeqsRQ4jaSj3HhQ0wybXaSptxD+KYwypniHKznBSkBrOUrveYuIa
UQw0feTm4BN22O3AVXCk4ojGDWbHqC9Buw9j42Ck60zSkm0/M1I6uD4tbPhrdUr8
cuwfYdLDTzDO6VpFbcGVjtz6wnlBKxKeTFK0AXjtLn0NiNXvkSnHvSaqWtu/WmkA
T0BHiJCkf1/bQdkqNF6KQ6Gvtx+qPDdorOXDZSrDks5JLKENKGpGMCGHGPtjPqwH
jtmPXNQzK2cIKbwbPylRJDitFXSGvN21ormkdq3jjYVVDY8cyLE4pvcQA82XOZ0U
w2FewkQiLrX6YbE9fEXCnCF3Q5YEw3KaM/0ZEhoNP1PMf9IO0HjdaXLk6D+J7Yiz
bL8llAki85IjFJ90avyftsOpHvbhOytuyj0rnkyjYXk9lUCxdCkYQYh+XaAHA8mx
z8XcJk46Fiy1XgMsCxenAlHhNLDm73yJfVLIq0QBIWjxG4ah2YLIMe7We4Xyew/0
3JYVgxUmZjDHz5mX0G5skoOuaJ8pMmO8lUQU+yY65Lt1P4RswjRL8lXb1VwwrJyc
nWH2cA4ow0SkE6M5OqjN
=b4gI
-----END PGP SIGNATURE-----

--FfX2iGK5t5ehHnsE--
