Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab2EUJzq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:55:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56587 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755168Ab2EUJzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:55:44 -0400
Date: Mon, 21 May 2012 10:55:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Samuel Oritz <sameo@linux.intel.com>, Liam Girdwood <trg@ti.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>
Subject: Re: [PATCH 2/3] regulator: MAX77686: Add Maxim 77686 regulator driver
Message-ID: <20120521095540.GA1999@opensource.wolfsonmicro.com>
References: <1337333539-18371-1-git-send-email-jonghwa3.lee@samsung.com>
 <1337333539-18371-3-git-send-email-jonghwa3.lee@samsung.com>
 <20120520155616.GB9337@opensource.wolfsonmicro.com>
 <4FB9EFBB.20306@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <4FB9EFBB.20306@samsung.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 21, 2012 at 04:33:15PM +0900, jonghwa3.lee@samsung.com wrote:
> On 2012=EB=85=84 05=EC=9B=94 21=EC=9D=BC 00:56, Mark Brown wrote:
> > On Fri, May 18, 2012 at 06:32:18PM +0900, Jonghwa Lee wrote:

> >> +	}, {
> >> +		.name	=3D "EN32KHz PMIC",
> >> +		.id	=3D MAX77686_P32KH,
> >> +		.ops	=3D &max77686_fixedvolt_ops,
> >> +		.type	=3D REGULATOR_VOLTAGE,
> >> +		.owner	=3D THIS_MODULE,
> >> +	},

> > These should be managed via the clock API now we have one.

> I already updated all your comments except only this one. Could you
> explain more details?

We now have a generic clock framework in drivers/clk so we should be
using that to provide drivers for clocks rather than putting them into
the regulator API which was always a bodge.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuhEPAAoJEBus8iNuMP3dgLwP/j9TMdT3+9EvKzbU7tudvn76
K+Z7cJwuC4o1ATE+UEY1ib/8CFaTfWGMeHGlFMnB84yb41C1bcTkmKqKEkNlVNy9
tpehxa5ay0JeynA54h71nv0edV5LwKNFIUxcjjXRFyAcFBSosb1FyLxMzjPrdCy1
HK5LhjD06R0DFQPrlLRwpzTR0gXgFYkyS2lZcqNsbK70HRWSnJ6CwmyoXLFo7CBR
WgVH7BILb9Xt/L0tBpyly+pyyCu/9tMxbwJQNpIXHvLzj1casfB5oSo6Rr+Z8lEh
dcFyWiyJlBlYY+AHU9+SGgn3wFoTaV8Viu3NGIMgQ6JO/GAr3OwF/B6neF1c9Dek
jmixT01A9aW1ZsYAwLWXHx2phU8chlVlwmPe1Sq0qi/CZz+3ao/Ro510HhUWK0Sm
zXqy9TaHs5T5KaAjMPpBobfMgHuz/AvPF7Scx6xhkrhwPxI6xNC3vDMs1Vqs1Zc2
D0ejRAn2C3YH8CY109M3XNx4wZwn4wlDSrySLj/FTx0wx7xkWAGE3r4FdXJHY47y
dSc4WN6S5wDTX2mhB4go7lYJBBfztyUzk8/AOjY1pxSMeDxj5oG3O2PQS0aPK8YM
ngPc8lJ9Jdtyvk1LG2RJHouPfziVjBGwsk5TZrlDh+gkOZ3e5IwsLzHFUv/o/Vsq
dpThPaFXf9v4mBQkSk3N
=bYzj
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
