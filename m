Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2EIOyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:54:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33658 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab2EIOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:54:20 -0400
Date: Wed, 9 May 2012 15:54:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: fix possible memory corruption in
 regmap_bulk_read()
Message-ID: <20120509145416.GX3955@opensource.wolfsonmicro.com>
References: <1336565592-17577-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6yuPXOSZRpyw7iEV"
Content-Disposition: inline
In-Reply-To: <1336565592-17577-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6yuPXOSZRpyw7iEV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 09, 2012 at 05:43:12PM +0530, Laxman Dewangan wrote:
> The function regmap_bulk_read() calls the regmap_read() for
> each register if set of register has volatile and cache is
> enabled. In this case, last few register read makes the memory

Applied, thanks.  I'll make sure the original gets merged up into 3.5
too.

--6yuPXOSZRpyw7iEV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqoURAAoJEBus8iNuMP3dCAsQAJlwvvSsZqkRuKhC2gMrYc5H
h8VVOBP1c7am5hns/zLVvCX9VNihh/tPavWyd+cRfswgCDKbb4iUU/rkVSvkeqR0
ZuLJ0rBFGfdH8txW0MPTS5ery1jUe8lOa5koqTVlXPvhiHgpJb/U4YZIA2LMlVTF
a8diw/ERcvqBip4zbvHv6P+PyLpQyf0XBmAe8yaSbuxJw/uaapEAYb05Ul1iL9c/
GNCJiDj6AushO7HsqxeB8UWMAZqWN6jmk5+VkNLOHHttOXZTW53anPDLJ7hWCTxl
YjbjL8R5RzgsiOV1bfEgTJ2FJdFhCXBNHCPFFh7ZJq7XFVuOkIe2NmY+tiLo9LyS
F3pskSYI21KAahMVtUUr0M5QvXgAm3rFCda3QxTNbq+9vAo+3f1qjK+i0luKMRrA
gjLudvNSsL8MLcSC43quigAgg6YUmELz9iUzxc9pp9w7AKwpgnpzmHxwSZVnBspj
Z3ZpFABffkmMrd8p0NFByaq2BJkWHdaLVguMfi7hrwQkx+1i6C5lTKGbWgu3ZpIX
0U9osAnmJGXz2uLNbIKqpJAq8wa9vA3D46yDiVODacUTEYvjbWOaWIWfwc2b+QiQ
LuUONT+Jr4Z+cCniJl9Kn4igBKCyBSc3GerC/XVQwNcG5snxNkv7n/IHeHXvrPnx
HTdRW8mw297m+0kof3EC
=lCLS
-----END PGP SIGNATURE-----

--6yuPXOSZRpyw7iEV--
