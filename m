Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2FKDV3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:21:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46438 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FKDV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:21:28 -0400
Date: Mon, 11 Jun 2012 11:21:16 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20120611032115.GB4218@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: [GIT PULL] regmap updates for 3.5
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-3.5

for you to fetch changes up to 752a6a5f84bfed18d0709383913d9d9d21b61c77:

  regmap: Export regmap_reinit_cache() (2012-06-08 05:57:21 +0800)

----------------------------------------------------------------
regmap: Fixes for 3.5

Nothing too exciting - a cleanup for debugfs in error handling and a fix
for the padding (which has only just acquired real use) and exporting a
function that's supposed to be usable by drivers.

----------------------------------------------------------------
Fabio Estevam (1):
      regmap: Fix the size calculation for map->format.buf_size

Mark Brown (1):
      regmap: Export regmap_reinit_cache()

Stephen Warren (1):
      regmap: clean up debugfs if regmap_init fails

 drivers/base/regmap/regmap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1WQkAAoJEBus8iNuMP3dADIQAIiLU0JUc4d2hYODsdo83O8T
GEsoqXKz3Xlpi4EiWKX5dEBj0RdUmWsxZOJ7rucsu4f7pBCo346CteTQaLk7cFa/
AcyvD0df5ufzROpbiJfUhpxyercQFNekbrX0xaPIMb5N5ZAU8nkTyqcHC5erQM4o
j5CzacTYVhFqppRpH/fVbRWP4bGxRphtHe1t1FZ08oJbdTvpE4b6PT/C+jg2i+kS
IO5/IYIJmANK+uznUtbtkj5ywEIghfGFuv38aU3cqeuQSmMMWjrHYDlxFGjq/Bie
J5bOmKbklcATChUeeDA+yx0pKuq17z+kKcesbtjnWNkFNTSnQJGlhPvVq6qMSbAF
ITl0qjXlrPyktH3YqhOOojUCCvEj8F/PSnVQKKyK5QG+tnun1bE4beeZB0fEr0s1
dOIz8PBeeCsRCLX2ZQF9sLcQZYWYspQm7qxUNFwaT2wWt/UX5svmpAiXjMU+MOp3
hxi59od5MSyxHMI/F4Gab1RUh+zIOnBvxXYA2IikEw8kkdiywTxUe0ccj0VaM8Vb
ivUEE1MfZtVpaEe5E6IU8lvrPSk0MpKcs6SkCBbG7HfcGg20TnyhYpfw4+nEJkF5
SvZefwCMRkdGMOqO0xWMxn6HN50d4ZVPAqxkcc2M7E8wCJwAdcWc6riJwnxstmE6
E6hdyv5JXsnQdAD6YPy7
=xv5X
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
