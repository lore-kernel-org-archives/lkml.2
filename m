Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2JQNQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:16:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39664 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab2JQNQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:16:44 -0400
Date: Wed, 17 Oct 2012 22:16:38 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Subject: Re: [PATCH v2 1/2] regulator: max77686: Use already set opmode while
 re-enabling regulators.
Message-ID: <20121017131637.GP14199@opensource.wolfsonmicro.com>
References: <1350388459-28975-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Content-Disposition: inline
In-Reply-To: <1350388459-28975-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 16, 2012 at 05:24:18PM +0530, Yadwinder Singh Brar wrote:
> This patch adds basic support to take care of opmode(if any) which can be set by
> set_suspend_[disable/mode] callbacks.

Applied both, thanks.

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfq+uAAoJELSic+t+oim9nZ4P/j9qaQo6q4TzSAzpQggDtHKo
ifyADpGtsjrzaXyBoU5urmut5bApdQXPIKcZPrAff1LOAFyIFku2/GooWThNKM3I
FdQ3Ngg0eBYk6V4Lr1rUva8zf+S+PKTUyXaPMw8s9eu2C1eJLhdvzg/IXPrCXQiA
05dlLoPh4CK2GWnNzTNEaorNHEZctxNiqi75STM00vlTNalNOiy0u8pXF4v/I7lI
KcvkJPRuEQZeF6B/aSNsMqBiB7srTtRC1qI7iLFBvbiNhBYvhCkIxfB3kuS0Dtt5
rv/OO7LpJQ6H8EzczgBMy+RR1I1AotUcyJbwyn1HfJSu41HqXAtQI/lGBaIoUx0+
yF0ulgGCzFfjeOoqejLws4T7W0IcNPRZx8qvY2/pkW+MJTAsv0u9xqEpPGZzK3f4
BKIaA/2oZbrFiJK+hOVy5ZiHeEmbiPq2dH/MuIzHMggquBA7P9SCKJVBrMyQMtTy
Zh0OUGj/RHHgwfiSgzwInT7y7MO+pbp2DIzf/+93tx1veoir5HdqkNupXLNSjIHA
QZkgbitg6BitBMU8K7yA3qCDHYmOSr5UXFjyPn8SS3NWsmHPgTpviQnxd+eyHs1i
YP2UekK8FMCyudtNxYeCNtdSLNjR52vJDy8XxBGsKC41VaBGhfHIUWzS/wQP6NN1
xE8nYVhSoclBR1t2S1O+
=IZ3Q
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
