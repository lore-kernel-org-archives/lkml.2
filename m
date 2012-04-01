Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab2DAPe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:34:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512Ab2DAPex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:34:53 -0400
Date: Sun, 1 Apr 2012 16:34:50 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
Message-ID: <20120401153450.GC8971@opensource.wolfsonmicro.com>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4F787392.5040308@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qjNfmADvan18RZcF"
Content-Disposition: inline
In-Reply-To: <4F787392.5040308@codeaurora.org>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qjNfmADvan18RZcF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 01, 2012 at 08:26:10AM -0700, Stephen Boyd wrote:
> On 4/1/2012 4:32 AM, Mark Brown wrote:

> >  Documentation/driver-model/devres.txt |    3 +++
> >  drivers/clk/clkdev.c                  |   25 +++++++++++++++++++++++++
> >  include/linux/clk.h                   |   20 ++++++++++++++++++++
> >  3 files changed, 48 insertions(+), 0 deletions(-)

> But why is this part of clkdev.c? devm_clk_get() should work regardless
> of the implementation of clk_get() so can we put it into some other file
> that is compiled if HAVE_CLK=y so everyone benefits from this and not
> just users who select CLKDEV_LOOKUP?

Mostly just because clk_get() is part of clkdev.c and I didn't feel like
creating a new file, though also because I really hope that we're going
to be moving away from open coding clock framework things so that we can
start to push clock API usage into non-SoC code.  Things like adding new
clocks are going to be a part of that.

To put it another way, why would a platform want to avoid clkdev?

--qjNfmADvan18RZcF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeHWUAAoJEBus8iNuMP3dpO4P/i4XeS8cZkiKUYXT7/WszGgd
0aJaTlm3XXVQwCuzxXxXb1lBtLSBZhd6a2x3PrgmdevwCFgURH60jGFjtujiofHZ
ZoY0m3ieWzG8q4EmvHgwxDOLNVKq6yMCjigHC40FWrUvNTijA5ZdcpyZlQGDZLt5
K/Ou/kkbeBKp05KZswE3yKG/VkeJx3yFdL4JE489T4wAFdmi8VJjhPqDsjolGB4r
sr8oXrd4nt9pABVa18PnlMDDJpul+54j/6dbH9Sa8xuVsEtO9T2262cUitquGC+e
eW2C8Suq9fygthqJ0twulg5BRS0MVulFuc0s3jVN2/Wwj65n2B4XE/MYJplGS/Xw
L/ibkXTYbUjlt8ixiI62L4aqllgH8ZpxtNlOG62Gx3VbsGGc2TolmfRbmATJkaeG
xyOVf2m8HQR1040hhxn4NQrK2fkwPXia2Y5Olvi49AK6Y7A/UrvHeQmXINyJtDSb
lb7ChEbhByZgl/hGNS5jn5H5I0uukUhvLbU+lvpqFnwCVFvE8BNw5lrfQU75098r
mTXbiEn8HYCoJsV33eMir0zATWDl4+CLqbZnX4yMWlsTBZa9ZU9iJmFWpf4nk/sW
UDc6WyPF0WVl4rTRUz1BIuG3636PAPgrFUX4vIkVbaP2N4edDNwQQNPPO5nBVJk9
MPxsObs/HLIAl3B2PtGJ
=8RQR
-----END PGP SIGNATURE-----

--qjNfmADvan18RZcF--
