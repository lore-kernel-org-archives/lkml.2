Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2BUM7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:59:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39715 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753717Ab2BUM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:59:32 -0500
Date: Tue, 21 Feb 2012 12:59:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, jedu@slimlogic.co.uk, lrg@slimlogic.co.uk,
        gg@slimlogic.co.u, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2] mfd: tps65910: use regmap for device register access.
Message-ID: <20120221125929.GA1494@opensource.wolfsonmicro.com>
References: <1329828694-2955-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <1329828694-2955-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 21, 2012 at 06:21:34PM +0530, Laxman Dewangan wrote:
> Using regmap apis for accessing the device registers and
> using RBTREE caching mechanims for caching registers.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQ5UqAAoJEBus8iNuMP3dmngQAIisS8h1hDbG4Fi15z9zmwwb
21v8wXdLhK/kho7cS5ExckyYf0s17SwoNyGSHUFtR0R5XBEnVAMkNtdlaNvhOg2y
3V9+UW/I5eyGTfFjgPDrIIJU9QRm03lirGFOcuhn7fwSKdwG0bju0u1gAvlIBl3Q
PLsbhfUgdM3ZYHNERT2gt3Aa8Nkwcm5E+uLbk8bpOdUhqS4GObZ5xUNGnWwnMMPA
bUT8lMH1K2PxPwQIJXq22U5FdH1eRJgRRiSfCkP4R5w8d7SCAnR3UgejyxodsyWU
sxAaI3g6/oyF1rU0YJUYq4hnhIfQhvAeHKUcszCFkk5IY02hwCj+ed2dc6KgrPE+
C8nKO6ogY2dtM+Z+veA373pHHrryufz4V12pyuh/1836ssEpWQyFCWaa4Fbi4Eha
D4AYhV/mcgAtCOy2N9Iel9CNlw/qN6ZB9kgkHRpXl+Qx9yi2u78tSlpWsTVPDigQ
NIAt4h2buarsT2N0UACLe+xD2RK/oDzvcBNyWLnV5QXeIaqdc31YLrhvsoSvZTop
xnG4TOLcxBqmEaeYiV0QUfTBovqlWhzrxKDkyaxrrgx9Xh6mE6eiNamrjtMJ0hEy
HQEHYHWVST/v0ipriUmYCMY93D06+IE5J74bV/RfT2whCcGhCpqXXNXgQUk2hldj
RkyYZdDQi5ebq6RMhbhM
=ojTO
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
