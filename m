Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2GFSJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:09:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38852 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751222Ab2GFSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:09:32 -0400
Date: Fri, 6 Jul 2012 19:09:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v3] mfd: max77686: Add device tree support.
Message-ID: <20120706180927.GG5437@opensource.wolfsonmicro.com>
References: <20120705124141.GB4111@opensource.wolfsonmicro.com>
 <1341574375-17397-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <1341574375-17397-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 06, 2012 at 05:02:55PM +0530, Yadwinder Singh Brar wrote:

> +	regulator_name {
> +		regulator-compatible = LDOn/BUCKn

Trivial thing but this should really have "" as it's a string.  But
people will probably figure that out.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9ymzAAoJEBus8iNuMP3dQOwP/jUrJWQyNv7C2U68yx6U4Lab
Dtc9O8e6Fhg+YhqWAw43kqndal8BdLT0XSvCq/Xb2cjFH96G4T2aN6L4RHn3WPZO
yAb1rUE4KVvGxE98hw+6CzFrx6axJFl3MU8Wdis8M7UhY1XxXmUECfNPQ3s3K/v5
VTQqbePZ/zqx/99hIaU457XBfVoo2iTlqfTTuXtLBKimWr+Ti5tPcw/5L0aSPDvn
KqBhMHae2RBBSCfH/8ugCzwtIOn7oJESAodeol8e+TPJ79VqVZdkkgd4SpEQp3Hq
su8iUSMMcFrRP25SQtshN9rBw0fIbU9q6Ri7A3ON9K6Bpba5tCBP8yGA84PKV2fz
9dfr4Lyu1yizEW/ztJlyGl/Ka8wG7vW6ZIHpcP8Za+pgT66GD7jlRv1DPaD56OXV
kYaxLAjv3tmVoFh9SoMu3x28BRNFaNVI6+GaqnjjkffSYdy+MkB9d1qVsSY+Cryt
V+da87fD3l8WuapBoLZlgOeUvuII0GeWKDc0EmomSrijuEn/JmTrgv3LT3S/gXmS
IG2BRiSIGGMAomg2QWN72N9FDMWcZOHdXe6Bus54ghdzsyqrRlfi3IKQKiXOP0rC
hpIzH1H+lhnMbLsPkedHT+hTqD6Z2tzj15g+PanV/A9xiN7eWb8yVmCY4ugNkInF
r7JGKXPDcez3qsaTNqy3
=6qIb
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
