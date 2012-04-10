Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab2DJIOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:14:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52973 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752827Ab2DJIOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:14:09 -0400
Date: Tue, 10 Apr 2012 09:14:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Eric Andersson <eric.andersson@unixphere.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de,
        zhengguang.guo@bosch-sensortec.com, peter.moeller@cn.bosch.com,
        stefan.nilsson@unixphere.com, christoph.mair@gmail.com
Subject: Re: [PATCHv5 3/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120410081405.GB3149@opensource.wolfsonmicro.com>
References: <1334002577-7786-1-git-send-email-eric.andersson@unixphere.com>
 <1334002577-7786-4-git-send-email-eric.andersson@unixphere.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <1334002577-7786-4-git-send-email-eric.andersson@unixphere.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 09, 2012 at 10:16:17PM +0200, Eric Andersson wrote:
> The bmp18x chip family comes in an I2C respectively SPI variant.
> Hence, the bmp085 driver was split to support both buses.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPg+vGAAoJEBus8iNuMP3dd7MP/iyUNceUvZin0zLl+Rg6lB4Q
XF08Byp5FPd35DTrTLhkIr1KZ5veew/3aQK0ZUUkqb1RrNwbV9OERL+RypTupVgD
8F9djYavmLNWr8HE7zR4vilsF8QaopYiCtAagABbOv0FdRnD8Q7ViSgzYJzskSrR
LYCbVb29bBHjcnFpRuf5bxZpfVPRk/tjR44zTyR5v1ieHse7bk71G+sH9hxuD53y
lSSgQSX59RH/o9ftzW8J6KGn4aZGZ8xCOiBJG5YRgmOZ/n2KdE9rVlkZzc9L76Ei
RR33uKnB7AtBe9hr0vYVtt1JVPpDlFEgcLxhU9OzKdAz8whUZUMIUfsz5F+8cSlC
bofpJWKcbSDtjSr6syW4Afr/9sO0HI9gnoq6TsLpUR+ZVIwitdhAuJsVLSMdSmmM
Ef29fY/PG/Y8nVzhkgbOebDDSMOwdlCjXS81v6KTB9FGW2JCEJj+FL5z21q322k+
yAjmKWL7lOmf5Bm8uFbnnoiBe0OzCQiV0IWWAqO0cH4jHQLDuHVnoXamEaAn0Nlu
WeF724dXDsL6JcMGLvZsztAqtNXLXKCzYMaHQw2ObYlovHa+k1O+loROKHcj9WGN
UoARLarjmdfNEEXm4YQIhho39JVizC6NULQoD7kvch2qApSH0YsgydtmcCtFMLfs
SJnZvCq7XpspJh8tZ3ai
=ymlG
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
