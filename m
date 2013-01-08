Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3AHLOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 06:14:34 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55928 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755777Ab3AHLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 06:14:33 -0500
Date: Tue, 8 Jan 2013 11:14:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] regulator: max8997: Use uV in voltage_map_desc
Message-ID: <20130108111431.GP4544@opensource.wolfsonmicro.com>
References: <1356685743.27172.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kOdvwer/5gjFgNo6"
Content-Disposition: inline
In-Reply-To: <1356685743.27172.2.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kOdvwer/5gjFgNo6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 28, 2012 at 05:09:03PM +0800, Axel Lin wrote:
> Current code does integer division (min_vol = min_uV / 1000) before pass
> min_vol to max8997_get_voltage_proper_val().
> So it is possible min_vol is truncated to a smaller value.

Applied, thanks.

--kOdvwer/5gjFgNo6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ6/+IAAoJELSic+t+oim9wf0P+QGUY3pHUsZlR/eekjmTZrQs
00KugE16iIMMOUmSLVOooCQa0xTfD0tK0Wq2xSemVXK/VrPPQ1weVtK3w2nHi+H5
kxr6nqDdyX1UKaeQzsIjYa2s1/QiCwtSAULORhD1skSuBosZVMSRkTx0AdaIKVDz
dAe1x3S7oGa+sS+l6OV/2baS66ZDaIzrqTeSEe3wZG1/VyTfQPw2Dqmk3rt0KcCB
lzllnkgS0G+41KTlD/eHre91EcWe2uTLyADYAJ0p/5ffN/w17h07uLBYVUXMGCev
xb60n+YHw9Y8PmW+A5yekY0IYzTogEOk1lQFkyjgL2BXiX+go20zzWrLS/bQ+sFc
kHDghI8VlFcon62NVEXPxTRDGfTtNujm+cPiS5Od/M+WQfRB6ldLvF7UJSoPZkq+
eEBAj+cn0CjN1cucttOj9qzHKZEejtuPFvQxp6av6gaUdi5Ga3ePHNinUfyQiV63
QrqZvTpL1IAv55xB0RYkaqhhSf33AZFiGKFbpcxVglRPAYkVOrgXSfxMGs5gKwRn
f07skcmaTuSXsMFqQfVNq9aG3V8ktpOhCPlqpz/b5IuGqvER3V1z5rlDDw2rPuMS
AAMASk57hdN6cAJCoEBqIPO9uqHo2C0FrrD9e+11da/0NLjhiH4jt+pOUh205EgW
Zxvlp2Ljqpy9Hr7OxATv
=1YoT
-----END PGP SIGNATURE-----

--kOdvwer/5gjFgNo6--
