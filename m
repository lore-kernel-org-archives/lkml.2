Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351Ab2DEKHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:07:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43194 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926Ab2DEKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:07:48 -0400
Date: Thu, 5 Apr 2012 11:07:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: rc5t583: Remove nsteps from struct
 rc5t583_regulator_info
Message-ID: <20120405100745.GH3129@opensource.wolfsonmicro.com>
References: <1333605888.18055.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIIRZ1HQ6FgrlPgb"
Content-Disposition: inline
In-Reply-To: <1333605888.18055.1.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIIRZ1HQ6FgrlPgb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 05, 2012 at 02:04:48PM +0800, Axel Lin wrote:
> The nsteps can be calculated by (_max_mv - _min_mv) * 1000 / _step_uV + 1,
> thus we can remove _nsteps from RC5T583_REG macro, and then remove
> nsteps from struct rc5t583_regulator_info.

Applied, thanks.

--WIIRZ1HQ6FgrlPgb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfW7qAAoJEBus8iNuMP3dLjkP/RWM92dhcJDLl9WAjjpKijKs
9Np5gABJJlPLPvZ6ZuS1UFpmR0uqm97Hr2VkArqVS4YfsOggQZipfWyTXvc2Wu2g
wxhkeqrSGuKwW8uVsZUe0rWAvihFhaYfdAlKtBQRupnfrvLLsF1mOx6Mf/yx4bXk
s5vrJ9cDH6gB9yNSLPHbg32Gdum9L/n+HVyWKdjkmlS9JqFaa2E7OT+nRZpmS8Ly
+L8HBH+fz2JjBg/igNPjCd342uCz4tVn5ZixscTuyWAC9qhQEiaFSWGHyiGrBMnI
6uzu+glAh1OZL4zOeIdRxQj1Zuz4hd7hPL3fLkeZvjCfM1o3A6U3KRLi+6cpF2NU
3qw/fjQRZwqxKlKxFW2pBzqbx445RhJEThwe0aLF64l7O/7GLVUBMZcxA/NKE6wS
jY/rOa3VG+V8G5pUYd/bJhBtDMjY6EMuANi7SfWTLjrqbasZSij8ZDkFSQIegPTV
Yj/wtEkg9ycBDcBdpXN0UUE5L97ZStzqnodzHn3wFs/AJfZSLYoggRIHMGWR/58F
H4Dt35KABSIGqBnqGEfe1KYLQR/mj259EgB15VvlymbY8rj5pZeT7uXOQMblM0tq
hzP1L8Lw36LCnP3ClbqMaROMqA7OfoEjhwgYhfle2bWJcXyyztnefIm4wNL7iFVm
K9I6SpeQUjqBHff2xZdt
=9Ypg
-----END PGP SIGNATURE-----

--WIIRZ1HQ6FgrlPgb--
