Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab2EIL7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 07:59:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36737 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757790Ab2EIL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 07:59:54 -0400
Date: Wed, 9 May 2012 12:59:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: fix possible memory corruption in
 regmap_bulk_read()
Message-ID: <20120509115951.GO3955@opensource.wolfsonmicro.com>
References: <1336564239-32004-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aTCJOP0qgkSGqHWA"
Content-Disposition: inline
In-Reply-To: <1336564239-32004-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aTCJOP0qgkSGqHWA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 05:20:39PM +0530, Laxman Dewangan wrote:
> The function regmap_bulk_read() calls the regmap_read() for
> each register if set of register has volatile and cache is
> enabled. In this case, last few register read makes the memory

Looks like a good fix but can you please regenerate this against Linus'
tree as the issue is also present there?

--aTCJOP0qgkSGqHWA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqlvcAAoJEBus8iNuMP3dALEP/i/nk4wnvKP4DaxNgCdhrdff
RPvCVRpXNLd3JD3GDMoqg8KtIIGKXsZQEwPQaE2zwNYtOBu5H+q7k5gj+0/9OyT8
uII7SbbGcr1mF8y7m35wCHJVAurBQSZr0Xc4L2uPA+UE4cWPD5EUmzEcHGBZFExt
ThmnRYyCWLlqq2EgtLgMpWHc4NEtBLKky9FsoYpAm4BQsjjXa4iC1QhhoVSRLTU6
n0RufLBjaCAINYkjcVsVMeoGmAVsEnS3iu41OjPa6nyYenL6nwitGERywFSiFGja
lphif8cElBGdr+ktFDgYDiwn2EO8s5x4LLn+RzCtpHGwy47G0PZHQPTKq/mH9ZZC
aqnKnNtwpLKWlcGlmDswuF0vixQY1btInLjv8vEtNJefQDeL0V89TicdkzSTqrGH
O/alPYY63KuoFB5QdHqHvhW+0Z3eZteIFon9lQBw1hRWMIxCeZk/OSsEAZ40023v
qQzaRAj5NzIzHWCQfF5jRRorlX9s6sGT/IoyiFbEH6ImAbd2gx3mR5kgyM31G2Fp
SlqQEU4twu0151fFSxkvoCT/uzave3lffwBpr8WctI8lZGp7opqoLrhluT7DdqmQ
ytgtjR688+vFOw+ypHP4BvI8IZLqNPOQhKpe1yDTPYy6pGp8UVXjJ8xtP1GXycUf
IMAC28PRuYNIQo7MXoN6
=m4Ci
-----END PGP SIGNATURE-----

--aTCJOP0qgkSGqHWA--
