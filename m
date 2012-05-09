Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2EIJJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:09:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49401 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758707Ab2EIJJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 05:09:30 -0400
Date: Wed, 9 May 2012 10:09:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] MFD/regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Message-ID: <20120509090927.GD3955@opensource.wolfsonmicro.com>
References: <20120508193938.31629.64303.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
In-Reply-To: <20120508193938.31629.64303.stgit@notabene.brown>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 05:43:59AM +1000, NeilBrown wrote:
> This is a resend, rebased on linux-next (next-20120508) which
> simplifies the second patch slightly.

Applied both after fixing up the changelog for the first patch slightly.

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqjN1AAoJEBus8iNuMP3dAzwP/38QpCg46rX+9eokLCHBuPNT
eNgCvskV2AXbOs2+A5EeyX0C0Ge6rOayvvSD7GV+gybjB1ZjGqRjpFRE62CVIsEZ
HHVa0TcS1pE1imiNq1JEY8OqpsII9ewG0osfS8X+aBwjz6GKceYxxQZ9faCZj+V7
M99Vac+j5qB8VMDh3MYMaYqCNp9mbIkiisHScARW89PfrJqBw0kMNVEGacq9x/gA
FImPlOhHfUJNGoClBIUynKM0NWeRaaogTvj8We6eDiNksygvf/ZwUaem7ITsn8ST
45Vp82e7AAs0rkedVyn0y9WQ9WDERcfe+Qf/e+I8Ucaqnw9UDx8+1CW7vTNHfjm6
ir02XQztkjV0Unc2YCWUpzY61OAcLPisWbQzK82eXzhXIb164Uq+yapNFNAUQL3r
tQPQKOzgvZ7M2sQaNR5btw6zlqR9cnxWfYhSh3o2qebpizr2Yty8/r+eI4Tv8OnH
SO8INuGKW5AUaZXd+lNA7mQNUs/EFZwbEkTqjPJ30r5SPk7vamVcW3WJ8h9IRqvB
cmKNrdnvaIP/nLWRrk85IJua7zbZV+HlszYjkHKq5hNDXeeEbiTXf9qZMuN42pa4
31W4u1Ponb4bSEkb2N04wRl/3ycwxkyfcWdzqpcrRY92ajpETYplTp69oPr3grmE
VF8nDzbEKCZkVcgAHpOD
=VDIg
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
