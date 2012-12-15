Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2LOOxv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 09:53:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38468 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756600Ab2LOOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 09:53:49 -0500
Date: Sat, 15 Dec 2012 23:53:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paolo Pisati <paolo.pisati@canonical.com>
Cc: linux-omap <linux-omap@vger.kernel.org>, Paul Walmsley <paul@pwsan.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Robert Nelson <robertcnelson@gmail.com>, Felipe Balbi <balbi@ti.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: core: if voltage scaling fails, restore
 original voltage values
Message-ID: <20121215145344.GF22033@opensource.wolfsonmicro.com>
References: <1355389980-5532-1-git-send-email-paolo.pisati@canonical.com>
 <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xkXJwpr35CY/Lc3I"
Content-Disposition: inline
In-Reply-To: <1355389980-5532-2-git-send-email-paolo.pisati@canonical.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xkXJwpr35CY/Lc3I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 13, 2012 at 10:13:00AM +0100, Paolo Pisati wrote:
> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> Tested-by: Robert Nelson <robertcnelson@gmail.com>

Applied, thanks.

--xkXJwpr35CY/Lc3I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQzI7gAAoJELSic+t+oim9p7EQAIOVAi4irUMtMIVyVCBMCWgj
O55CojOoetm2RIiGMJh4HvbPnF84EFAqN+v0aNiXNTlFVoDdTlji14UgUO1+tp8T
CwoJViodSq8f9pxP/YuJKeM07yaSaJ1b8RBUGZIQUldwket3EQdMdwwd0XnIE0TK
z0SxU4afLjzOx1R1KZkcUiBR6HEWll+R7eMjBSDL8fqrYnh6pqtG8r314KGuUgU7
41893tQ8ETpYR1PMUyK1ghMb7WTz6Z2Op8mn7tshEH3cgpYmmULVUInjAjS7Hyqh
YSm6ZViGxmZ1TK0tNxcZynRRYKSs7t6iKfJC2Wf6DeE2SNOgX+cEN1HtaVxUNqbw
iWaRsXNjZ/mZx6dsIgz95JwByeMfDkZp7JcX4UnFLkObKGPj//bPKzvcXZ1j+hws
+qYcKfX1Vw+CIe9SasI1IREdQrmEWHc2okquikAq8Mg6Lyeaxd7IlX4++lDJZPwv
haKghjPp5V4y9p4aPXWUxKQ2QfuwcW7pJQhYHAz96HwUmME/cIhrQeEoMFGs/1sC
gVKKue8KPQ3hNvfHU1ASzgFhDTAQLqBIBFIPhzC1m5/suFGsBnPzlifkOI6Mn967
zvCpi15y4DEOxoBpDyak5P64JBYbzOzGoDB4FyxzRZd4KxQASFHfr+1GLL96+SUF
GnvNuhQqfl86Z9xDrAAq
=g8E9
-----END PGP SIGNATURE-----

--xkXJwpr35CY/Lc3I--
