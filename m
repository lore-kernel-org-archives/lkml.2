Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab2BWM3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 07:29:49 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:46810 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab2BWM3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 07:29:48 -0500
Date: Thu, 23 Feb 2012 14:29:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tarun Kanti DebBarma <tarun.kanti@ti.com>
Cc: linux-omap@vger.kernel.org, grant.likely@secretlab.ca, khilman@ti.com,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/6] gpio/omap: remove suspend_wakeup field from struct
 gpio_bank
Message-ID: <20120223122942.GG18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329999031-6914-1-git-send-email-tarun.kanti@ti.com>
 <1329999031-6914-4-git-send-email-tarun.kanti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T+d4WTH4wtHHX3b6"
Content-Disposition: inline
In-Reply-To: <1329999031-6914-4-git-send-email-tarun.kanti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T+d4WTH4wtHHX3b6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2012 at 05:40:28PM +0530, Tarun Kanti DebBarma wrote:
> Since we already have bank->context.wake_en to keep track
> of gpios which are wakeup enabled, there is no need to have
> this field any more.
>=20
> Signed-off-by: Tarun Kanti DebBarma <tarun.kanti@ti.com>

Likewise:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--T+d4WTH4wtHHX3b6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRjE2AAoJEIaOsuA1yqRE0YgQAInmNlAZ6DMufhi5Fmyum87q
hCIUNJv7tErrsL3t34OkdPikqbmc4r4z3ycAhOgQaTTzjkJ96JjgjMhDEZzf/8QD
qBSPFwuTG4LhoVlFYO7YgzjpTN7twMLZjhJZpBkbRECGkBrvzoQ8ZVXbvjfPxnzA
k9+DLbJOraGOW4zgsDlt6ctjbIoRGdnPa8idnxRHFBh/UMfEt9GuLfj5nOi5gNlZ
6SHMzt/G2OhssQ1iX9tDcP58fvGy5B7Rv7aVHm4SYwppZIXoBkUqmXc8Rfoushyc
1PLvuRC92KzICTPdoS8qDiIdDB2hX+zkzXUfaSYpWtEqlCHk2TCuw6z54wUWQi+a
Ld+U2WaPMIguxHDulX4qCypKuKOhb+G/1+sKyMWlMTvDWrsHtt4TX++pWGYZ2dRx
tOhf+cRjQAZXydlWm5Vo0mgeKIwHDhxs8d14uVIQoPBQQj+imXVEbjEFlXMKSX1j
Tad5L/Nx+tOJHgRyRf279QfDU3ut/ljyUp/qUUdB/6QOgspMAXKgPejFQ1D633RK
nUGpnyS4K4uGmgjrPXTTq6mznyTf127hluv3Fq5Zyp+v9FKkR7kvqXBlJQN4YVos
SGTIzADnENNk/UOgHqlTQwegaz8Ddiz1Hi9U0Man4+FiE/loWIYYH8fuHCcreyV7
tj+9+6aGT/P7O/dPoD5p
=Z8jk
-----END PGP SIGNATURE-----

--T+d4WTH4wtHHX3b6--
