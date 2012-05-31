Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2EaMsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 08:48:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34575 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757091Ab2EaMsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 08:48:01 -0400
Date: Thu, 31 May 2012 13:47:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Chiwoong Byun <woong.byun@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v5] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120531124758.GE2666@opensource.wolfsonmicro.com>
References: <1338258051-3155-1-git-send-email-jonghwa3.lee@samsung.com>
 <20120530172652.GS9947@opensource.wolfsonmicro.com>
 <4FC71161.9010002@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vv4Sf/kQfcwinyKX"
Content-Disposition: inline
In-Reply-To: <4FC71161.9010002@samsung.com>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vv4Sf/kQfcwinyKX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 31, 2012 at 03:36:17PM +0900, jonghwa3.lee@samsung.com wrote:
> On 2012=EB=85=84 05=EC=9B=94 31=EC=9D=BC 02:26, Mark Brown wrote:
> > On Tue, May 29, 2012 at 11:20:51AM +0900, Jonghwa Lee wrote:

> >> +#ifdef CONFIG_COMMON_CLK
> >> +	struct clk clk32khz_ap;
> >> +	struct clk clk32khz_cp;
> >> +	struct clk clk32khz_pmic;
> >> +#endif

> > This should be a clock driver in drivers/clock.

> Isn't it drivers/clk ? Could you explain more about this?

It's using the drivers/clk API, yes - what I'm saying is that you should
make a new MFD child driver drivers/clk/clk-max77686.c (or whatever) to
contain this code.

--vv4Sf/kQfcwinyKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx2h4AAoJEBus8iNuMP3dn+wP/iafJsx7oimx7F2BQl8NhPsV
mTuJh25CPv/WwUBupfcjtgPxf800RaYR5b5sPGehdnaqBVmtJCzpT/17+au5H5Dt
TNMelWet+FHlTtNTmTGCdYEp8uOvEUuaqZeOVGxRGwxElG5s/DcuIjKh5RhKa6VP
Np3um5YW1B7ZsD6tg481ykFZZuEGv3cuD4DzixuKszy/AQv5MJ7EMGPJ9yqu1KrE
yk4quphZ2Jnha2E09s6xh/33VbhWSYXJnkP7L/qsURvQ49Af4/t9MUOsNL1bqgQV
1v5KHS9GZ4b2q7S/v0vnQ7cuwVFln9DsSRyotatBsGPMNNliMPY762IpkBpHl5/5
K2+jJ9PrqSeGWZLcnA3Jr5zFUGv275ryi1R2C/3i2OCWJJ5h6tcWT/Sb6c1qBTLR
MjjuCE5IRZOxLz5YIZnU9BWj6lm4sjS+LUiPkScTKm2BzBFUeDfIsyH9SYC7T7pM
2hw4m9fpuiJ8SSnzvJw6520ifTMFejXWbKw5dwSBiTLbvJNDmJfIrwJGJq7Uc528
jBd8EiwL3sRz+ADTpUp/EDAx7K82ta55mNkP6apuXJVfQ0AaKgnxUEgPejXMLdVz
Qnp/B4+vSKyYd7ZBFSIg1lecv4U2bW9AkGb1CdubNnB3k8AIRz7wgyfEza7Ab0r4
QccV/pRKcCBe5sq+xmtZ
=Ak3K
-----END PGP SIGNATURE-----

--vv4Sf/kQfcwinyKX--
