Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab2FMJpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:45:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41190 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664Ab2FMJpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:45:12 -0400
Date: Wed, 13 Jun 2012 10:45:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: Re: [PATCH 1/5] regulator: Remove s5m8767a buck initialization
Message-ID: <20120613094509.GG4545@opensource.wolfsonmicro.com>
References: <041f01cd493e$32e99020$98bcb060$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Content-Disposition: inline
In-Reply-To: <041f01cd493e$32e99020$98bcb060$@com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 05:26:15PM +0900, Sangbeom Kim wrote:
> As s5m8767a is revisioned, remove unnecessary buck 2,3,4 initialization routine.

Applied, thanks.

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2GEeAAoJEBus8iNuMP3dDYUP/35PJpalr72bKuEbw/Eiv5eu
2Ze2zyX42477ax7a3YN18crNZ5aZmNdXOiottl3WjdroMmO/IByByi3LkVrgwI/m
VsWcb2FS21yF+aVBVZY//qZ7zcLa9HFWq85eT8rO29MrChWFQMwRynBkx8jHMueP
vAB6lKNEN1Jb6WIJc7iUvb9OVqs/nfc78rRaLpSjZb/KhvaUwUXss2tMqAiuZYP5
4HAy1Z19DytjlnZ6YJUPokQHiDPAU7lmApQUseR13skuCWu2n64jEIK7KbOShyUW
NcYOreacFLQ/FLYimKZWESLcz9xNKeBn/LDN643waZh3ohCAl10Q11oyTTEYvQjT
ApdObsWBas0ujSji1KrQCyKWvoThs2l/pydF0z1Bc6BdQhsyZbPVNyfBmGbrzt9I
NHm64ozp0IO/rOVxZFMI3eW41711Mr5MTm9s4tgCgkNbR7pfaDcRzQLKhXviMsZo
pRst+naOITFzaUDx0a7v+bv08YLZ2bC5gRIeyRWgluiJNa5x4Xk1GhysVbChASO+
IM8Xs8JCQ59K1/LcBqWE91cPUJ2IfRAcwm8RhP1iwZQu4e3Z2cKly+9E0lLgAs6O
iVXpjNlmkwHL/NqMw/F8XHbgE7wwYm5kaRpVqjrJaCWSLIlR6RhM5olKVZqPoSpl
mGCRWPCCeLOCGXwI9qhj
=CtpW
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
