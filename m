Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571Ab2BUJkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 04:40:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41363 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567Ab2BUJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 04:40:03 -0500
Date: Tue, 21 Feb 2012 09:40:00 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Simplify debugfs code
Message-ID: <20120221094000.GA3079@opensource.wolfsonmicro.com>
References: <1329772500-20577-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1329807042-19090-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <1329807042-19090-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 20, 2012 at 10:50:42PM -0800, Stephen Boyd wrote:

> Update the code to reflect this. We gain an extra dentry pointer
> per struct regulator and struct regulator_dev but that should be
> ok because most distros have debugfs compiled in anyway.

It'd be helpful if the changelog were a little less oblique about what
the resulting changes were...  either mention what the changes are or
mention what the current state of the code is.  Makes it much easier to
work out if the patch is doing what it's supposed to.  This was also an
issue with the original patch, it wasn't at all clear what the actual
intention was.

Anyway, I'll apply.

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQ2ZCAAoJEBus8iNuMP3dUr4P/ROsHIrlYAsqtocQkAn4AS3k
BEXhHvXhSX0IpiZo6cZW9IGuFNB++BS5h2eLG3io4KSukWgcj8pW7xDL/ggH2B14
4k7e+1LzjKGVeTvFUPDqyZw30IPLBt40eMKYvh0+iIurHBOjRA0710b9UPUQidKN
ngJMwx1vOkgRjFeofqnsXSCkL5DTj8VhuOQPd1wIJ1RoMWTIDKLaAxtC+J05Jx9j
Ul+AJ3Z65Jcj5VaF/Bav1dvVNbeAz4Sg4vl/rD0k47W5AnEoba0Fr1l9Y/3uOqWO
nWbKYaoriUGNK26I4NAw0DN/X7MYzLczULkvoMbfWxQ2ANtYXeuknMXb8tCZk+2W
fQUC3qqoCtPl2/9UewGGVjCalnwjNwRhERHG+Nz9WzrNlOFZqHr8VCBeh5if3Z2w
i4rbd00yce5QqQAFEKnMLVUCbR6J8cPm7KHikoHJcJO9miWFdCkbvEwpldrj5G1Z
44YjyndAJuE+rKreQFbL/iLUT398mX0GMueyWwte1a+QI/X9FaLkIxXXtXfKwicm
JX1gEZn57ik2LPaaJCKcyugpssbduA5fx9yx3dxpWa65ks9lW6oMg2WtoT4RCymT
Fqdr4+offlIYpCF50uI9TXMh7CLiZEjAjWniNFwI1OPsP5ZnHwZa3O1bZUbLUOQH
8AmoQtHWsrsP2pxzWE09
=wh5g
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
