Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314Ab2BIMDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 07:03:16 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50570 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030Ab2BIMDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 07:03:14 -0500
Date: Thu, 9 Feb 2012 12:03:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>, "lrg@ti.com" <lrg@ti.com>,
        "jedu@slimlogic.co.uk" <jedu@slimlogic.co.uk>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] mfd: tps65910: use regmap for device register
 access.
Message-ID: <20120209120312.GE3058@opensource.wolfsonmicro.com>
References: <1328697985-22504-1-git-send-email-ldewangan@nvidia.com>
 <20120208114120.GF3120@opensource.wolfsonmicro.com>
 <4F32676F.1010305@nvidia.com>
 <20120208130726.GB5943@opensource.wolfsonmicro.com>
 <4F3279D6.4000009@nvidia.com>
 <20120208135816.GE5943@opensource.wolfsonmicro.com>
 <4F335385.5040400@nvidia.com>
 <20120209115502.GD3058@opensource.wolfsonmicro.com>
 <4F33B52A.5020900@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lkTb+7nhmha7W+c3"
Content-Disposition: inline
In-Reply-To: <4F33B52A.5020900@nvidia.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lkTb+7nhmha7W+c3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 05:29:38PM +0530, Laxman Dewangan wrote:

> I am working on mfd/tps65910.c and function is:
> static int tps65910_i2c_write(struct tps65910 *tps65910, u8 reg,
>                                    int bytes, void *src)

> All your feedback will help me to improve my next two mfd/pmic
> drivers which I am planning to upstream...

Yeah, I know that's the i2c_write() function but all the callers I
noticed were calling it with bytes set to 1.

--lkTb+7nhmha7W+c3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM7XRAAoJEBus8iNuMP3dHPUP/2t09FlmWBG2+7cIHMDnnyS7
lSi+NuCeJrGaO3boRROsSxnNyQ6AMwDTKDRLchDLWqx6CsZLq/Bo2IWGVTNFoFLG
pvBBKIPh2YFvtjtkRQnB2BR934HOI0Nrnd9lJbB5lHtHGSQ3+0uLrxHrGknlVZdv
GdtFTfk+nKw+ivf4w2DLqyik9+qBlxaTReK4rIawlJ9KMkZUYOvT4rNoL7ay0Kyf
xOksx7nu+2dsH3KIY/FEHY8MIEy3m6qs6ZzQRnpqOxRx/esTlHI5rEGf/fefCYzJ
0lswBilrv3QvtogvHF6i15tRMQAGBJNayONm2hc9sHv54fBT+YHPbLGptf5A8uTl
uxpn7z9ALw3kBiD6Kn9Vb8ssh73y092V+IHXHRypeRu4KT2EPWIlVeC79Sd1zJfx
VSiKYiNt5Rsfj1Xnvgo1+X6IONMfoeZ5QbULi6W1ssYgB4pQdr8uSjaWCBAn70O2
MtHUWOmGY2oRIEs8ooaTgPJYAitwXwKUSelNKXs6Uz/UTLwXrjDSBi11NTgwKbRe
uzD7XK2TUepukB0P1YT9d2ag3xWCLatPq2736TXJLvErdnXzZ/LdKzNz3Pa4ZeQt
czlRP/NNXZNQM1g7sgo7HYROS07po/j7ucDOckWFyxiRk/iG36GYnpcjFv+RqULz
Ol7AvdWq+5QMfQMqom//
=dBHB
-----END PGP SIGNATURE-----

--lkTb+7nhmha7W+c3--
