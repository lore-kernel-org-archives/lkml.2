Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab2DGI0K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 04:26:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42780 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314Ab2DGI0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 04:26:05 -0400
Date: Sat, 7 Apr 2012 09:26:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] regmap: mmio: convert some error returns to BUG()
Message-ID: <20120407082600.GA3099@opensource.wolfsonmicro.com>
References: <1333747053-6846-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <1333747053-6846-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 06, 2012 at 03:17:32PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Some of the error conditions detected by regmap_mmio_*() are pure internal
> errors, rather than user-/client-triggerable conditions. Convert these to
> BUG().

Applied both, thanks.

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPf/oJAAoJEBus8iNuMP3dpdgP/RKuaQYHwLqc+FIxXc4f4kGC
8FekL7BILnrLm+MMxGfbcgjiCpIvmccjBD63tpwZNZZqEcxpbPyB7/kjTXkjh6Sa
DYG7c9CjVBfWPq8etq4O7+OmurgAMptX1iNOVqGcRJL2aGZ9WmUoS6IE/Xb4ckTE
+LT96kXxqEiWnKcM4JK9C2ef+wgpUzbG0FIR3M1xgBub327oy71Fdlx89CrN979S
RF3/9vFsfQHCcIPJvwAI1qbYbUxiM1IDpT8sudIlXbiqlZOOtX1kKkDbf80OBKCR
z363ok+L8bGMKDojKCJcW4XFleoLFlvU2WMOG8bHvG3y3npa6S0BbZtiYdl1H4Qq
Ryc16xiUXsvCmSsEcxN/cus3JPNpUb5ddv7t0HW5xAw7X0Ljvt5nBryP6Li4tDvz
Pu4RSoGr6OYUi/Waffd5YzfaA5zQ2xCwO3LlTCZOhBtBQ+GU6sCmI6aRsftUZxcK
tGNCvlZWKOKC29HG0kS4e+5lGtkA4obN5b7U1gRZ0c3BlvhDH6vJsUWrlq1CL3b2
DEkiCnzYz4Vw5Roo8OQAFXHOv1wL3yOMQHFdkwu00//9xv/q7aLOWQd0/oH+Sfo+
KWUTI+yWtiTFMJprckKoSVBs7o14E5COxfYmRULPFP7teIoohe9FkPnVYxZZ20H6
wjl3QYXYIAfRwsOT++jD
=qK3f
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
