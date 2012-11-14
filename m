Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2KNCpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 21:45:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45256 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932452Ab2KNCpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 21:45:38 -0500
Date: Wed, 14 Nov 2012 11:45:31 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] mfd: add TI TPS80031 mfd core driver
Message-ID: <20121114024529.GN4415@opensource.wolfsonmicro.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-2-git-send-email-ldewangan@nvidia.com>
 <20121113074623.GL18224@opensource.wolfsonmicro.com>
 <50A287F2.4070008@nvidia.com>
 <20121114012217.GE4415@opensource.wolfsonmicro.com>
 <50A30381.3000609@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Content-Disposition: inline
In-Reply-To: <50A30381.3000609@nvidia.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 09:35:45PM -0500, Laxman Dewangan wrote:

> Yes, this is not a good idea, We will need support for wakeup
> without wakeup registers.
> Probably we need to add one more parameter, wake enable to control
> without wake_base.

This does not seem sensible.  Why would this be optional if it is
useful?  In any case, what you're doing in the driver here is clearly
not the way forward.

> >>There is 2 sets of registers which need to be configure, MASK and
> >>LINE enable.
> >So what does the second one do?

> The MASK register used for updating status register when interrupt
> occurs and LINE register used to pass the status to actual interrupt
> line.

So this sounds like the LINE register is actually the mask register
which is the opposite way around...  please describe this stuff in the
comments anyway.

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQowXCAAoJELSic+t+oim9fToP/2m7XB/c3SdyaFwAHw/b6f7c
49yvmtqc7txLRQMHmbt4MA8wEavc+PFVtWHboc/9im2kuC6SaW4wr+wUQyxcd/z8
58lhT//DEmdpb2pY0bj+iZfDau3nUlqjLzSRUVHAv1sqCD+/rK9JxlW98A4EOht+
ayRS4V7OyHs77qyAFEt+wTiC1CafWyw3Y/hZ7JAH37VlZqKmKDwu0LZAIRAIjS/6
eR1J+ljqQ4lUNuWby+tJBEfkjJEUmhxwKg3cwuHaAsh9suj9mkQnYiNGWHFh0VBS
mZUz+laEyWk8njIHtNeMbsC6otMVSlyZDdScMr9ZTzddko42dDIpaZZ25E2agGMH
CMavr1jgFvusEqK8MoMC4DJnKk2Zv/5fX2f0CsUxMb8yDP1QyOguTQrQSKIR8GpH
Q528yrrpdo9X+BXGXtXdVsNXHwlPYalk70Ri/srs3RHgTUdp1rWI3YTCkkhAzS7f
Go1KVxKa2m1FGcHgVZjOhv0+i9bYy8uBerOC+M/mPlvAodZ58Qpl46YR3SZYY3s5
KeRJelKTvkpNvDDbc77CC5ZyOa56i9dHcu+Vx5vSD4wu+ljUZleIb60TY+9xyM96
BPAr9VX0nVqnJinLvkmJVMmbwALQssepZ4CzK/Oc4q42ej+avQfEmpqGqkNseEk1
D0pNfMdGGvAnjFvoOlJa
=0J3t
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
