Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab2GRKAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 06:00:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59009 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab2GRKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 06:00:15 -0400
Date: Wed, 18 Jul 2012 11:00:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "AnilKumar, Chimata" <anilkumar@ti.com>
Cc: "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] regulator: tps65217: fix build error if REGULATOR is not
 enabled
Message-ID: <20120718100013.GC22739@opensource.wolfsonmicro.com>
References: <1342593663-23938-1-git-send-email-anilkumar@ti.com>
 <20120718094449.GA22739@opensource.wolfsonmicro.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9F8BD7@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Content-Disposition: inline
In-Reply-To: <331ABD5ECB02734CA317220B2BBEABC13E9F8BD7@DBDE01.ent.ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 18, 2012 at 09:55:57AM +0000, AnilKumar, Chimata wrote:

> Regulators platform data is added to platform device in MFD driver, which we
> need for regulator driver, of_regulator_match() is used to check the regulator
> consumers if we pass DT data. If we do not enable CONFIG_REGULATOR then
> of_regulator_match() is not exported, so we see this error.

Why are you doing that in the MFD driver?

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBokmAAoJEBus8iNuMP3de4kP/3qZEdviooJ+BBKA/C/Op2EW
4iqwHdkVQP5oouXXUBZQST6DEcRqEZvyJFN5zzvlEmW8Z5RSPTOioPd739NJzN1s
nMsLGHe52b/ursfKzm+HV72WqXGkENX2rnEgxr9L5j8BCbGreJeEU8on8CoWAi8l
gbksT690zaiTs/nSCf5BnmDVQCaOrvMN+5KxcoPE2ppRcr0YDzFVqFqjuoLInKHH
6RnQIBalyb8H/gH9+ADbrDyHk8EeVVUJOmKnka39tZ+3Dku4ET6tMjaZKmpIRv2b
5AAnHqUzxq9ywdPE+xvZpCnn/RUM0jtpnJTLsqaLoaXS5DWCSiEzSAfJWhbfEyov
1F6pCHlT9UJqYHck3/fHizeD5CTo+2htg1D2SikZaLiM6Jbzoz/h5g1x4NEEvrRz
Cu/j05X/dBlxkNugLKjKURO0qXUglWE0PU9fTIfi9DzLSmc496KrxNXxOeO8f7K5
ZYX8LQJyactZxzzffrYbCYifEugYf55sTgo2VdkwvtbOaW1nGZaP8pWJgGuPqHHO
1A+sXwiWnf/JYpmEsZtGjO+Nx7phSKsKhiXvUQnv5aQe4IJguD57+UNcfy4Ciy++
DShbIbvJUGZsWj+GPCUhI7ccrVI/qttu7PH+WDNZrMguJEkTNTUHzezdUhkaZ/Bw
9lnHjcV9U+N7duiCKn6g
=FWg0
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
