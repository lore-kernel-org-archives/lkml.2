Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2GJLHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:07:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55526 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751711Ab2GJLHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:07:42 -0400
Date: Tue, 10 Jul 2012 12:07:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Defer failed gpio requests by default
Message-ID: <20120710110739.GD3918@opensource.wolfsonmicro.com>
References: <1341832976-8025-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdZ=6yP58DvY287h9tL1pL_oQk8JfjvYJhc80==yvzz=TA@mail.gmail.com>
 <CACxGe6uJUTtcmq2voo0yGQZ-OxiOK-0OEJ343qZZMDTMQc6veg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AbQceqfdZEv+FvjW"
Content-Disposition: inline
In-Reply-To: <CACxGe6uJUTtcmq2voo0yGQZ-OxiOK-0OEJ343qZZMDTMQc6veg@mail.gmail.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AbQceqfdZEv+FvjW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 10:54:41PM +0100, Grant Likely wrote:

> I'm fine with this patch, but the patch that adds the twizzling of the
> dpm_list when probing needs some tweaking, and this patch must be
> applied after that one.  I'll go and reply to that patch now (and cc
> you if you're not already).

Given how many subsystems are already doing the -EPROBE_DEFER stuff it
seems like we're already at the point where the core logic needs to be
bugfixes I'm not sure it's worth holding off, any system that's hitting
this is already buggy anyway so at worst we're just shifting the bug
around.

--AbQceqfdZEv+FvjW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/AypAAoJEBus8iNuMP3d3AsP/2BvpFbcs1UQoeKACh7OG6W0
izAobZQ2uw4r+OmflyWQGM+eF7TO/S2gSURdF5HXO2LFSkBV9dJjbqx0nYsOUe1j
q3n+WawVwmROFkuL8f5nW9/egO+GyZ2PT8pBtq2eiMBVSgQf8ZbrXcPe08CJ9xwe
OkN6OKvwl1j3itV2F/CYGhquRMQe1rpmGLEpYgmigx4Aq8xK7UQc7zvIohgRewmc
0VTLLoZ4sfFbWSnpwDviqMAE9aEQXO9nXjfh19HRnXF5sAPudJCx84Qj3WtHYrHV
LR9molCJpZFs/pM2v+A1NSQRfwL31yeCijxzdM+pbjrDlRGQXOSjUK8zzwOx/FZf
8U62PDDdm3dzImJD8kK7BN5HHZHScjfxD8srBczp2XS/gzVi86Ih6ywopCqzm/mo
ZM3Rn8ULNTdaKaJcp7Xr7Hr4g6CXaji49XQrZ5P/durKyFmsZvUY5oYaReD/DcDC
FTeNDy8hleP6yrp3YeD5Mjo2I/MmTFviIuYHAHY+EiE9+tQhQgZil5vnTGhnbxkr
Ct8ZIZnDskwagsrnRrWD31IT+fn9rOsQXh/tKHuREXpCyifrTnHWcm3xtMY5sJjy
4mSmuX5D9CWk4Dd0wv8hXgcFJKvB5zjmpTbM6K4kqF9tSCWVQ3npy8zbX0npdlfz
EmMmNEuxPtxfqtqXwy8b
=CCtL
-----END PGP SIGNATURE-----

--AbQceqfdZEv+FvjW--
