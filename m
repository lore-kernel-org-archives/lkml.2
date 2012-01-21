Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2AUP55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 10:57:57 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38817 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2AUP5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 10:57:55 -0500
Date: Sat, 21 Jan 2012 18:58:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Igor M. Liplianin" <liplianin@me.by>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] [media] ds3000: off by one in ds3000_read_snr()
Message-ID: <20120121155848.GR3356@mwanda>
References: <20120117073021.GB11358@elgon.mountain>
 <4F16FC26.80306@bfs.de>
 <20120119093327.GI3356@mwanda>
 <4F17EFE1.3060804@bfs.de>
 <20120119122202.GJ3294@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xSu31lw3TgkWXnjh"
Content-Disposition: inline
In-Reply-To: <20120119122202.GJ3294@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F1AE07A.00AA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xSu31lw3TgkWXnjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 19, 2012 at 03:22:02PM +0300, Dan Carpenter wrote:
> It's a good point.  I will redo the patch.

Sorry, I've decided to bail on this.  The original code is buggy but
I don't know what's going on well enough to fix it with any
confidence.

regards,
dan carpenter


--xSu31lw3TgkWXnjh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGuC3AAoJEOnZkXI/YHqRs24QALB8tg1uafSQZlErsvpJRqgP
9O7zFTdLafnCGQWk82SYRfDl2y2n7DZmrx7RiWUtKPk+d/jJb7onqpo97FEDYR49
LYnz3HLWuZhVNqo+Mna8D0dLPtUXZS589lzLBkRgvCRCd1bZ9Wh/Ib13aHcKq2y9
PcIbO9sydIe5kfx+1m9muHXurPPokLBlMmCw3fRc1u7X/wwYJw9xz85wqz4FOXvF
30fbGQMuWy5a8vaCWAgfgbwj35kUqaRl0XNkBS/8dLuWzqyeBHZPFPf7j1PIFGeK
kaMrZJH0WKQVllCCXO0zhEe301237AgSqfVg/HPxNiAgL9vrihWiBOphUFd6VAYB
SVW2fDhpSc9M3iJmm9r0rjSy+1MS5oIn8IIO6OepLKDwJFXEhDgv4lWnna8cgV2d
RBvtSgalYmLkV4NLJMDufQ+FnfzvvSrtvSacYc2tjnA91CNxdW5Y4hA+/YJHkYRY
KnGwW1+hDRRpTmM+ph60m1aXMxK34R6z1cayjwIhmNsM49PnvGfrTEu1YCfmDZBu
nFoXxuN5K/0lVuDnMjiEvZkzfWSC12jv/PI8O/XBbRSmCAxfsxxtRyNKvDh3rX3r
lDBHHGUHoqdM82F6WzOpl5WNA1tNwV4ApeHMfDfT7zHGyPdv+Ub5aBfZEBLhLGEQ
z6/zJuPy8WOHl7pVPitj
=2qph
-----END PGP SIGNATURE-----

--xSu31lw3TgkWXnjh--
