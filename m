Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408Ab2COKtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:49:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50162 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759503Ab2COKtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:49:36 -0400
Date: Thu, 15 Mar 2012 10:49:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC/RFT 1/2] regulator: Fix da9052 ldo regulator names
Message-ID: <20120315104930.GE3138@opensource.wolfsonmicro.com>
References: <1331077370.20711.2.camel@phoenix>
 <20120314140909.GN3133@opensource.wolfsonmicro.com>
 <CAF+7xWnNjJbdG2G8RBG_n5KdzCLXNe0RpJ2F99gFoP+R+AMYDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline
In-Reply-To: <CAF+7xWnNjJbdG2G8RBG_n5KdzCLXNe0RpJ2F99gFoP+R+AMYDA@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 07:42:53AM +0800, Axel Lin wrote:

> commit 4adf9beda5 regulator: Fix mask parameter in da9052_reg_update calls
> commit 7b95765 regulator: Set n_voltages for da9052 regulators
> commit 93651218 regulator: da9052: Ensure the selected voltage falls
> within the specified range

> I'm not sure if I should re-generate these 2 patches against
> topic/drivers branch because
> you will have conflict when merge them to for-next branch then.

Those are bug fixes which are going to Linus, I guess I can merge them
over though as there's a direct conflict.  Can you please resend the
patches as they were, I deleted them when they didn't apply?

--cPi+lWm09sJ+d57q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPYckzAAoJEBus8iNuMP3deggP/01wrzlaM6YpoWHkVvgws6hm
og6ohmPUUDVh3zoK1FI+ObI9etmJjaQUv6TcOoHkPg1PpEFeOGLLTO+zmg+mCedT
o7WkA1K0djQ3NgDVRzwvtAwW8z8U9k6eBgf+4vtKSqB6Ony9n6KP74Zl9hF32htg
EXRmGSMy1fb1sA5qoep16ogcBh2usfpQwjtLmwEqc3/4vzhiMv/9PWyxe5W1TrLT
iPgb+WK1uns7AUMd1oDSymtrcZLRl0eIwBsAB7Avh3AKhHMg3drL1+6WWS9yi+a8
+A6C8k0hvvMVExta7RWmjGcr9IaPrO3z35PLoopv2Nmfp8ytv+RSmQvuiKqbq6RJ
/2ybXlS8FBpLVa2c/UX449GuEo8JCsgXXjx/s4l9u7+hdOF4KdgJ/YmT2qSI6g44
3YhLoLBGjvqG5FDTYaNUfZWahnAhjfDhj+eOViBbcrUIbrWcGyqTbKYccv3jF3gD
/dlz+1GEF/8Z0w6z+fxDmYcEUqPsBuxqav+hdyCdeyxGCAoRfeAvztTDEPlMcsk/
iQ7nzc+hrMHAqSJzqYWkkC2ABSP78o1fe65/49juoRRyqoVlBjIliQlRx1KKV/H2
jy1t4y/xl+0PtDE7AjiCO2LE7VMR0rPaKEJv7eGOuhi6OUUj6a78qkLvpQAfP8+b
i5dgkFj0I5Zokl3UHaAu
=7300
-----END PGP SIGNATURE-----

--cPi+lWm09sJ+d57q--
