Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2DFIvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:51:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42403 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822Ab2DFIvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:51:19 -0400
Date: Fri, 6 Apr 2012 09:51:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: rc5t583: Simplify RC5T583_REG macro
Message-ID: <20120406085115.GD3172@opensource.wolfsonmicro.com>
References: <1333670496.2777.0.camel@phoenix>
 <4F7E8030.80000@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jCrbxBqMcLqd4mOl"
Content-Disposition: inline
In-Reply-To: <4F7E8030.80000@nvidia.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jCrbxBqMcLqd4mOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 06, 2012 at 11:03:36AM +0530, Laxman Dewangan wrote:

> I thought of doing this on my first patch and then thought that
> table should have all configuration picture rather than deriving
> from few parameters.
> If this is a good way then I will take care for my next PMIC driver
> development.

This way is good - if you look at for example the wm831x driver where
there's a bunch of regulators with the same register layout replicated
in different places in the chip all it does is specify the base for the
block when defining a regulator.

--jCrbxBqMcLqd4mOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfq58AAoJEBus8iNuMP3dgxAP/iUzZYWYBRmur875VNV4Ovla
XkW4bibRycR8mGQFUdSeKG/fZQji5E7N0j+23KhgW038vNkG4++n98XfGmkX7i5O
yiTWllo1sTbcD961IzqIvVXwLlgTky7eI/s59G63S60oMIbb39SQ/rFUAQt4Dy4R
RplzEed68X1XAY8ZkZnzd9+s4SMYrBjua94wwVLvW1w7t03ZH0F00RLOmk0Hh9js
cGtTNxk2v4K6egpSTugZS/hEAih7dLgzhznvecZhZ29O9vLJhaQZqFnLqS/2zbs5
k6kakActcRuRKGEjO0eAX6qq8wyWM2Kd+ARIhkzwnb3N7/PKeO9UGhv3yDn8suL7
5j4VJp54qkk7+UlF0uxwdyxlY86Hh+ZciA3S40YIWCuv0KSKkLrmTpmkuIfxPgOr
X/z4bcGRA0hVuQaWWLYOvyyzhfHUNOT6xE1hsAkuf0bBx8T6LxZOvA8VwbdeTPWz
oX2eEsAKc+AbTXnYcd24lPYk52IVT5h40zNdBFrhYYQUj7V+Rj/GgUPVjOm1TlPB
lsISj5amB4f+BvPqxpsJrajmY2TG1z6CChMGwmbaQjr6G1OKjQSu182MegWZVyaV
9lOYgXM6/QLGJYt2t50MHa0O7od77OWjmjzg9bHOdl0oAIyvDzV92qblS5fRnOu/
YyUbSbvAkQXf7/GpRRwm
=18uG
-----END PGP SIGNATURE-----

--jCrbxBqMcLqd4mOl--
