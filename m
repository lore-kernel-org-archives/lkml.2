Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2KIIHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:07:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2KIIHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:07:45 -0500
Date: Fri, 9 Nov 2012 09:07:27 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: paul@pwsan.com, tony@atomide.com, linux@arm.linux.org.uk, b-cousson@ti.com,
        hvaibhav@ti.com, anilkumar@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nsekhar@ti.com, gururaja.hebbar@ti.com, vaibhav.bedia@ti.com,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v2 06/10] pwm: pwm-tiehrpwm: Add device-tree binding
 support for EHRPWM driver
Message-ID: <20121109080727.GA26007@avionic-0098.mockup.avionic-design.de>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
 <1352361197-27442-7-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <1352361197-27442-7-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:deVdMr3JKSEX3dsKKmUNdkacgmJSD67r75We97gRfiT
 K+zHqm3CqvN6WiW03A0M0GJagNYdkXPXQftIx11b/7ZC6DGD/9
 ozVqajPX7XPEGnQ3fRQfvSlKs9JUG5/1yA8jeTgLXNmeyRDl2O
 HtCrBpl8fpcdjYHaZrng42rzak/emsTFxrjjkCly7SABLWeGrV
 HUZcHoVwwjGQLBnLbKElyshDnRvOJr30jftpqDVNkNggZycji5
 n7NciW7q8isyMM5PsjgXXu4xu8uKDqrvbNbsIVbUJjFr1k6MMw
 Y8y7mHOOW2ds/owAp4gZ7v/u1I2UyMHqjs8eTn3BfSXfPzq9DB
 UKlDxV61ZFF9W+Oher9amx/z9d9bda2JcQgaD+wFcsU7KkpRog
 6CbJ6zig+iyA7+NiZnyooMDhAj7QrK/FFw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 08, 2012 at 01:23:13PM +0530, Philip, Avinash wrote:
> This patch
> 1. Add support for device-tree binding for EHRWPM driver.
> 2. Set size of pwm-cells set to 3 to support PWM channel number, PWM
>    period & polarity configuration from device tree.
> 3. Add enable/disable clock gating in PWM subsystem common config space.
> 4. When here set .owner member in platform_driver structure to
>    THIS_MODULE.
>=20
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
> Cc:	Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> ---
> Changes since v1:
> 	- Add separate patch for pinctrl support
> 	- Add conditional check for PWM subsystem clock enable.
> 	- Combined with HWMOD changes & DT bindings.
> 	- Remove the custom of xlate support.
>=20
> :000000 100644 0000000... aa2ed0a... A	Documentation/devicetree/bindings/=
pwm/pwm-tiehrpwm.txt
> :100644 100644 d3c1dff... fba7f9b... M	drivers/pwm/pwm-tiehrpwm.c
>  .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   25 ++++++++++
>  drivers/pwm/pwm-tiehrpwm.c                         |   49 ++++++++++++++=
+++++-
>  2 files changed, 72 insertions(+), 2 deletions(-)

The same comments apply as for the pwm-tiecap driver patch.

Thierry

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQnLm/AAoJEN0jrNd/PrOhmOgP/0B/6MWQw+hqwUreKowC5m05
RaRQQABNOrIZTmIgPbKDT1wiqIgv5uK4otqIyfzGTHq2t0PXiALnRRcm1PisHuTi
+JlGGhhmRAROR2bhFNPnyPLkJoUoznO9Cf72j4TCVyMXUGBl+je4abAiQIECJ3bg
7VFn9XfIJ6YFILIdFpZP7yYyAwySdgP4wMMTDp7MoZmNnWm14GyZPQtha3jLdzwh
2JZbJ2VnpCKx9JulwHroCx+PFbdeupGaWEuKFF0Nqh/nEgrd7EXtQgjplpqXStjy
N+k1zWevk5yYbYbeDVVw8vtYhT9C+Ea2GgN+jugaTDh8TKpCZK9ADuvgXRGGB7Dp
dTeR0Ef0mr3yHsYVvHngsimExKrgpq0DcXGJ2iGJn2E+8ppemoBS4I+mQaN+OIkY
uDTvYPdC5hcTynsIORIIj4UuJTb/aZc2/RCCuWrZOON1UrbqCk3faM3X4nWgChr5
EudX+Oc5Vp0lc07qAfzNaUclWFAXEN4EzCv1GmNx3+VtInif8iBvf4+sg0b2R22D
KD/36eCBPzOLLwEB5IJZcA326dCtt/qQLcFxEEGkyCbw3xLyTi8dM0qaoEn1MJz8
w/odpqMlnodJWBhMqPH1rxMJD3qwV4icsXurTtYXe0SudT96kNf9eTDdZqHMzzek
jcvsNEBOXaGm9RW4lRFk
=/1ye
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
