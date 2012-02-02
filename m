Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2BBNwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:52:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39078 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab2BBNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:52:50 -0500
Date: Thu, 2 Feb 2012 13:52:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Kill s5m8767_get_reg_id function
Message-ID: <20120202135245.GR7428@opensource.wolfsonmicro.com>
References: <1327994011.9257.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Evp0T6PXIQ26qRMT"
Content-Disposition: inline
In-Reply-To: <1327994011.9257.3.camel@phoenix>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Evp0T6PXIQ26qRMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 31, 2012 at 03:13:31PM +0800, Axel Lin wrote:
> Calling s5m8767_get_reg_id() is exactly the same as calling rdev_get_id().
> It is pointless to add s5m8767_get_reg_id() function.
> Use rdev_get_id() directly and remove s5m8767_get_reg_id() function.

Applied, thanks.

--Evp0T6PXIQ26qRMT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKpUjAAoJEBus8iNuMP3dwk0P/RmFa56GsYC6RrNF60h2I3o3
ls4Eirznn3b8E3vgpP5DeoezfpNvbumL3Mb0dm8fCAW9MEtrRzxQ1NFS1RIvfmLf
0FjC1oEmn3dPilo1Ys8lp6BzgEIw+rfcozlZZQQ5OOTIgJpvqpPxQOvFg+uklxOp
SfXG1n08INin94v0khPrM5uKUd95u1rhqLW+NQmpGgmfw2WSjSGSv9GmZztLS+by
LzDkFj+IjLmqLxcilEyhXI+hgVm9tcSfpS0sFgouZc3ktuu8cBKN7UmI/OvoNDzp
QD83F/R29GRgqlfqjwloDrnuHj01gF7f1x5u5DD795GbldGC1bh6Zau8L92JPfxW
QjcdLNkVKlvEEk1xueVMuu4upBQbDKtvZqGn5ndvQHalgzJwYjyxKbp0dH9LtPvm
iaw1apNOyHbFfVmGcMf6DNVECaKdb2YR2ptsrh/Uw6akWN7FT52M1E6zSJVkIYWm
x8x0dObH8p8qbN7Yepv2eN1Ru0pYf6Vd8wcvhZCNtDU29gV1sc0URwpnT3DB6MDf
JC9qLZchFdcB8ebRYkThW2485EIdcLmFpWZ0XnOmAXgazxO43aMuflwmP5N9PIY0
jk0DlX0lO4CWUAKPUr/OUhAvZ/ftamW5sSd6NhsfYzQRwNGWDh6fa0VdWYY0FTIm
Kn+NikDezhstlueJkvSj
=kIp6
-----END PGP SIGNATURE-----

--Evp0T6PXIQ26qRMT--
