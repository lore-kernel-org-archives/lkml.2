Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2A0Q2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 11:28:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52062 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534Ab2A0Q2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 11:28:39 -0500
Date: Fri, 27 Jan 2012 16:28:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120127162837.GB18572@opensource.wolfsonmicro.com>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2012 at 04:10:21PM +0100, Wolfram Sang wrote:
> For the upcoming 2/6-format, we don't see debugfs output otherwise,
> since the current division results in 0. I'd think 10/14 is broken
> currently, too.

This looks good but could you please rebase on top of topic/core, it
conflicts with the support for padding bytes.  It's not really entirely
incorrect, the bytes values aren't terribly well defined for register
sizes that aren't integer numbers of bytes as they were never intended
to be used then.  The assumption did leak out into debugfs though.

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPItCuAAoJEBus8iNuMP3dbi4P/2a55sT+Mq8DKhCkBvsH9CFN
nJW2T5sVpCgJv+3efhT+86MmQPQHg4PX9g3wZWi5fdIpSJZq4NaMr0w7vdR9gaIF
oZruriWt2cFewm4KyZlzlYKLVBee+XmdQdqQIQs2Wanrlw9kwCpKq92trA6BM9Bu
vx7QryRFUN3w4CqilOkQ+WazfXLewGhSyAhacToIsktYoeEJi3FPPOF7zrnXl0n3
m2IxFTxs3uaLqs7YQgmEME40YwbsJIviy2f9eWapl/zF1KNW5injtcn/UMXvTj3b
7EszPBpx024hP8auXiZ8hj6wmGoe4704TZApeSvul3YMvwqjLlepoRhgGakky9sj
Sgki3SeQNA2gf4zl+vMGoyH17DWueDvQ+YMRHhYFN1NaJQbxDFceHZMazajnXhCv
Uy66lrAOzxmCqTsRZL9RuLd+nCjPVFePaXRbrMMfpEcSPc5RJE1OYoahfDpTvdqj
eCTiMy+pw98eb8dcMN/k/X0bW94EbkbXS8rmvEUvgyoc75r6dSqGeXX2LY7WIDiP
WYRp0oaZlyLIEKHtE/Bz+wdYN6F0/Mi0lou0zKbEJmw91dI9NUApVErW9koJ3w6n
LHLmNgsByB+yc2YlomBafZ+ytyme2nqLZ6AAI7Fcx2G/x4GIRBol+9upM36zg4ux
9dGB09C8VLi+8iwfclIO
=kYeL
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
