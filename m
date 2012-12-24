Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2LXQS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 11:18:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43789 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2LXQS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 11:18:56 -0500
Date: Mon, 24 Dec 2012 16:18:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: irq: enable wake support by default
Message-ID: <20121224161853.GS30837@opensource.wolfsonmicro.com>
References: <1355926348-16100-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cjNiBkmi8s9yAE0W"
Content-Disposition: inline
In-Reply-To: <1355926348-16100-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cjNiBkmi8s9yAE0W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 07:42:28PM +0530, Laxman Dewangan wrote:
> regmap-irq framework is used vastly by mfd drivers and some of
> devices like TPS65910, TPS80036 do not support the wake base
> register to enable wake.

Applied, thanks.

--cjNiBkmi8s9yAE0W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ2IBnAAoJELSic+t+oim9bEoP/3qjKwAAfVRqfSVKvZTEL6RZ
ExXhkfEgyQ0x6QAYext6fNFpy5O/UyY13FswUlBy5wyrl6i4g3qUWiI5v+1u4m7j
gaJpisWVBs5qYojfc7Sw6V33t5qZya55/XB7B0b3yK83UFVgLcCImhMoDg0aNQuE
nzEwC/y7jF1Ru8V2SOgO98k3NLleeNlVokFpqaQFZUizWxYrh3mxtDdDPN9QEbEw
E5LDsXoMffFcA/3qB1ohTARiTuzJdcKL0rrXPKYUUr3es9woki03TY3SIxb8/9G9
EjObS+HVRjID2e3WFc6miwB/kHTZD8hEFOTlnSMBwimWzzhLsxFGErRfubyeMcbD
nuxFgbKoYV1FGtfxQaeTtcoqlsbiq/McogdyLsDnwB7SqmJSuKLI0k5A3BP1dKYM
CJ4XjZyKCGSWoTu/Po8ml0r+MwpBfS3qJbHG7SyehA4AOLqMxn3Zqc2cdZGJ3K/Z
UeKXyEUj8F2oq93jG7RL+C0zKfi1iUkEtIVWKVn74hWSUAKJPmTIgD93s1teNsW7
FoBnJQqJvlkSNzagiU69lZkks09GPW3WtS1Jxz38rHjGCJaqz9tv1YP7stFKj4uz
/4A1DgN1MDohzMbcrElD7TRrJtXMx8iLx94rBvnNE05XTI4acOJKDto8B3qUWU94
WAk7WNcgj1SP5Lt1K4g2
=H29C
-----END PGP SIGNATURE-----

--cjNiBkmi8s9yAE0W--
