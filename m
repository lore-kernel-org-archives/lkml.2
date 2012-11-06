Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab2KFLbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:31:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34456 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147Ab2KFLbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:31:41 -0500
Date: Tue, 6 Nov 2012 12:31:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: avoid memory access after freeing it
Message-ID: <20121106113138.GB10080@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
 <20121106111256.GA2512@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <20121106111256.GA2512@opensource.wolfsonmicro.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 06, 2012 at 11:12:56AM +0000, Charles Keepax wrote:

> Here would it not make sense to go slightly further and basically
> revert my original change. This feels sensible as it keeps it at
> only one location where the mutex is unlocked and removes the
> second exit point I added. This would effectively make the code
> look like:

Given the bug that was reported with your original change and the lack
of any fix I'm actually just going to discard it anyway, just didn't get
around to it yet.

A single exit path would be simpler and hence better.

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQmPUNAAoJELSic+t+oim942EP/0vuQnBopa0xoLouqR2GmiSZ
IllWegJGnxXBZxXr13ox+chAMNFwU1old4vDscYhOc8dkxSvjp9ZtwXZTIEDQMeX
gMZDevgHB2dI0fgijRDD+3WACS3TLbYKJs4YI9FQFnq6ipICvmGZohbTf89ce6r6
1QwTaQ0KHMA/Tb/Fl0RD5CJmY/H3F5qW0IFmPyJuorcDOfUo8013H+rnndVR9Ioc
YqWIh2leXXaRkS8GkRBks46/8Fn2xq/W6HnjprAf7zIBDV4OobtGJ4ruuYN9WU15
AMPnmoiCz4Nwy4vcyY3DqTdkuKalO+UtL3vbRdV7aWQPZr0eLxn8bPvk3NIW/sLb
ruZ5ftwPjLYhIeCFNpJ8BY7mLJSh73g01CUoEv8WRVOSsK6v7yPFBHMxoQwr1IUQ
QjiS3BIkMayBaoR2fS66wm3R5mNmaCNfnxYnatGwTuMZZ1JW7W9heAfw1TZsiSyW
7GqFyCKrf6VXH9f76Wq9n1SmWDYcBATzrmT9o0QZqEwNAM/i/Rd5Jt3Fc6yxjfrq
6o4QuvhoT1qWXGFTpUUVJdb7WzwK1nQ24i52XIjfWRAasCV63BZPkgD+c4TJPEkT
8gCfGu0YmByiyUIm1wJuVF6/qYBbYazeJMgFqi1iG3xdyoBSyq73JfTO5ZlbUPVo
FUc7csKPxrD/XC3WeuIC
=5n6A
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
