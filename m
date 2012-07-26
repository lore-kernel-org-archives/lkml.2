Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2GZLWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:22:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45443 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab2GZLWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:22:39 -0400
Date: Thu, 26 Jul 2012 12:22:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: lrg@ti.com, balbi@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] drivers: regulator: add error checks for exported
 APIs
Message-ID: <20120726112237.GV3099@opensource.wolfsonmicro.com>
References: <1343298603-25442-1-git-send-email-kishon@ti.com>
 <20120726111030.GU3099@opensource.wolfsonmicro.com>
 <CAAe_U6LhrBnsU9nC0yXqyNmEjmDfrvYP5BYhAOhJiGxLZbk_Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aZ/0/p6gSDXwzas7"
Content-Disposition: inline
In-Reply-To: <CAAe_U6LhrBnsU9nC0yXqyNmEjmDfrvYP5BYhAOhJiGxLZbk_Qw@mail.gmail.com>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aZ/0/p6gSDXwzas7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 26, 2012 at 04:49:21PM +0530, ABRAHAM, KISHON VIJAY wrote:
> On Thu, Jul 26, 2012 at 4:40 PM, Mark Brown

> > Also NULL is a valid regulator (though we don't use it right now).

> I see a lot of dereferencing *regulator*. How is it supposed to work
> when *regulator* is NULL?

Like I say we don't use this now but the spec in the API is that
anything except an error pointer is valid.

--aZ/0/p6gSDXwzas7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQESg0AAoJEBus8iNuMP3dXugP/1TwWoHak6NzaC/EP2LsUZJT
y0Q97UgstW5qz3zosvYp+F5175Aj2rwW3p4MOFirIucwaKj6NlP6M54Q2sDqVYy9
UMR3kIp0F7UlPBEhr0qyMComGCByVdsm+xAm/Xt/LoWk8O4oZLp0UI6/kKEP4Sg+
HPMpXdRww3Z0HlI+cwRZXN8eCWeUNF/nxWTfqCn5OuQkhhD5zKj1ISXEac1mQYJ2
A/sRywPUdZP74cWeUx5SMtZI5c112qTYaigZIb+HZ7+X/ii46KEUPzzdV/PF23Nd
hMgp7Rt09b4UeC5UMVCHiykXQyei483KRWVEXMPQZM4s5qOmfZaL1HAOmta91Ytj
5dK/NZvPPTG3jgHaYTGo7HRJ5b4LS42XCj97GVUlNsTj7Oi51Jb9QPyLPiNzJTGu
3WB8kSvjryFfgfY9w7LFKyP+ZwccX89P4tsdjUSZ1sZSNKi4K/BOxS7A7ZtMHURJ
K/1GzLOkyaZaut9NkRIcuUWxjmZlU18/YEw+iB4fp0Rqp4UU2eORoMPe39t/nbw0
5evAvUOL6zgBOtwijJnb6GlTaca9EJugf9nWz0QCFV0sfwoVbJ/MwCZYbyB2ji7V
E3b/V0004p3SN5ypb7tC1367X8RyH+27tOwhWJm5BGCsQGgRj5YsDQXGJIHXvWlb
/dbXYdbQLvzV+yWJqO69
=qmXn
-----END PGP SIGNATURE-----

--aZ/0/p6gSDXwzas7--
