Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2B2XaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:30:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54371 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754248Ab2B2XaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:30:03 -0500
Date: Wed, 29 Feb 2012 23:30:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: delete unused module.h from drivers/base/regmap
 files
Message-ID: <20120229233000.GE8295@opensource.wolfsonmicro.com>
References: <1330475282-15284-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <1330475282-15284-1-git-send-email-paul.gortmaker@windriver.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 28, 2012 at 07:28:02PM -0500, Paul Gortmaker wrote:
> Remove unused module.h and/or replace with export.h
> as required.

Applied, thanks.

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTrTuAAoJEBus8iNuMP3dhiEP/2oZxDilaEtVYcvq8PDnw7Nj
/mB2L3m/0lJcYr2xjrRSETu5dnpOigDY6tIFMfT+BLOZAaBabxtoQfRaUmn9un1l
/Gb7Ep32oraSfTpq3+KunXMi8mDxYiMxPJ4xynBkUh5wW4h8hr1VHstMOmpNYmvU
sLxH3TBgSVLOI3YyRMbFYxNu7OAuUHfBowunn+pEl93rRIpw1JgLbdYFcnyJW9eO
0UuUso7grDOVlpxwBJG/1BRPEh3+WSnFzwFSDOMkhpmXyFc516K2QZiXFclDq6jC
YWRde6Z0QoYyrJB3YfGPf0awbkLNSenRtu1PIM4UbrCx3lfP54Kjv61mAeFS4l1i
MHmnpIfaW+32Mbjqvr/+Ib1D2i9OcZB6jD9XfYsa1CeaebIQcAA6Lj3aNki3GDxS
aePT8egEdxMDpFfwUtU22Z+13ZLVYiAv7BjeNgUNi0LL+MIWhiyoaEZ8duQ7g0io
sSQk+aMWxQCwPUMJZ6j5JJfKpo9QRgk0izqhN8Pz4HmzCl5RLJt25BYM3rFVSKtP
zoAnifZ8bT2iWtsSKeIrD6aAJBS+ZDAkhmSdvvsbvwlSZhRVu1JF8eR/OUrEKfSE
Np1UiTH2AIRph8O5a2BEpkRaivxa/SxoNorZUVbNnLQtvP3snZ7g0ihV60HtFID2
asWk4UVgOOd4dMzlZBwM
=twnz
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
