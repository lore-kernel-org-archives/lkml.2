Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab2DFIlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 04:41:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37230 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026Ab2DFIlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 04:41:44 -0400
Date: Fri, 6 Apr 2012 09:41:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Question about the regulator driver
Message-ID: <20120406084140.GB3172@opensource.wolfsonmicro.com>
References: <B567DBAB974C0544994013492B949F8E38135B639C@EXMAIL03.scwf.nsc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <B567DBAB974C0544994013492B949F8E38135B639C@EXMAIL03.scwf.nsc.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 05, 2012 at 05:36:02PM -0700, Kim, Milo wrote:

> But charging termination voltage and charging current can be
> configurable in the charger operation.
> In that case, is it common to add regulator_ops for the charger ?
> Or is it better that charging parameters are set only in the power
> supply driver ?

I'd just do it as part of the power supply driver, these limits are
internal to the charger driver and so there's no real value in exporting
them.

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfqwPAAoJEBus8iNuMP3dKnkP/i6DsTsPBDW7WlIyyZa00+md
haDAMPBPDhUb72y9mI4+Yj87N2ysjTle2Ui9tSevQAq+RTB5oibmpywd6EQ7SI/i
5b/aRmayWKaSlQXpM6RLB9Fw/9kOoEOIsKL30QrU64WBFBkpus8w6eesxlSM4yiP
Renp1IMBGX5+7UCQOpu2bC8BmWN/ZSzv72jWB0KNg8nD7QMV5au/zargos7IpSHq
+FI5CzqM2eWnzX6iMED2uzfvzMtIbh5DKYPHFeameYq3gHQ62PwLUb50JnEfpSid
5IcaoFSVZs346Mn4nHSU4Wyl2du42U2nn61GK3YO/URyyQkuTI9FDGtJpwlwGu7c
B6F/OMv3PHcA6tmscYbHW4UqcXeFd/faOSMLXgJJr5YeRj5uSNTjKVFKnadATzGi
4YdKXEDZorjfqK8ZMKaPal5eA1VhjDjGWZv4fhEmsxh+5Bwy2HVWYzMMDqw3mDkk
rkx1v4CjKIaZg3Ud9BdiZ3QWrPyCBjLKYx2LxTPky57kSvcc6PlQ4ShCZtbUHzyO
/G0rZpHEQGxvEw+ihW2cQgOif3ElZpV9mtZVNnJwcd0cH0l0Bx8yBQRw6cZFAY7K
VM08OKos3Wj+ThFX/+oakpJxpt0Ea79f9iDyo4pp+KsPhn1nlE01dj96Q3DiQ/XG
z+4UzK9Sjqf7J8XAgOJd
=0+2D
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
