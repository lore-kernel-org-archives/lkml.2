Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933694Ab2GDHjy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:39:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62880 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab2GDHjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:39:51 -0400
Date: Wed, 4 Jul 2012 09:39:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: Use of the pwm-names DT property
Message-ID: <20120704073942.GC25386@avionic-0098.mockup.avionic-design.de>
References: <4FF3E862.8050101@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
Content-Disposition: inline
In-Reply-To: <4FF3E862.8050101@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:dVcZ8SjfhrBxbTA6rP/DfZMQxXDKURzfqW2V25rTYRH
 M3ptie22ORVzFG94mJrG9ynHLft72I0+1b06aq4DWDoj6/Flxc
 4eQQlSrAFca1ZYxgVR8wR8g30ftNahGh/MtoBJFB79W0akiL1/
 bDfrWZ1AojhMuMQANXNPbf3NGEctianfZFfWfGZY0aEiOkujrP
 6Komw9ukiY1vyBxQN0EDGitF6jUYS92sTFQcygRr8PucqxRAt+
 ptEMt0bWzF6wdPdAu3QUkkhnJdSxcz2E/ZujSdw8/j7swlazqu
 H/Gw4MEkB9JFnUPL0L6qFYb+pnO+iexbAW7ACai4uAf2nL2jTW
 gOACxmLKnwVfezXQbpLj6yX7IdpSplhhN6HW3t2/xUlg581obS
 /vVpWDsKPt36uFfqHVKsVD34Mb9uY+aLBpndHmDVg9YAQujNgH
 B+TfU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 04, 2012 at 03:53:22PM +0900, Alex Courbot wrote:
> Hi Thierry,
>=20
> Looking at your PWM/DT integration patches for linux-next, I was
> wondering what is the rationale behind using the pwm-names property.
> If I got it correctly, its purpose is to be able to reference
> different PWMs by name, e.g. by having
>=20
> 	pwms =3D <&pwm 0 5000000>, <&pwm 1 5000000>;
> 	pwm-names =3D "backlight", "flash";
>=20
> You could get the first PWM in the driver code by calling
> pwm_get(dev, "backlight") and the second through pwm_get(dev,
> "flash").

Yes, that's the way it is supposed to work.

> While I am ok with this way of doing, why not having the form that
> is already used by the regulator and gpio frameworks, in which the
> consumer is part of the property name?
>=20
> 	vdd-supply =3D <&vdd_reg>;
> 	core-supply =3D <&core_reg>;
>=20
> Both regulators are then accessed using regulator_get(dev, "vdd")
> and regulator_get(dev, "core").
>=20
> Wouldn't it make more sense to follow the same scheme that has been
> popularized by other frameworks? It also has the advantage that you
> do not need to maintain two different properties which must be the
> same size.

In fact the *-names properties are rather common. They are used for the
reg and interrupts properties. The pinctrl subsystem and the upcoming
clock bindings also use the *-names properties. So one could just as
well argue that the regulator and gpio bindings should have been using
regulator-names and gpio-names respectively instead.

Thierry

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP8/M+AAoJEN0jrNd/PrOhXL0QAICAYFCpJuukcyIkTBrFuFkc
a4/Nn7+hwB64ZhMwMt4ug+AxxC+9dqTw0EOm3+7YWe38PskbYEqhGldBKW/r1b0x
Wwmil6de5yizUANRn7V89RYJ/LGr6gfXYEZ8ekjUvEh0oqcmqMK8dqEOHdhdrRg+
PR/knFTA/259KvV3oL9a3MO2skK9gvM2fKAx2RTKL6qmnGs3ZoYUhcbJHTL8BIrv
ivBAxG6TFWkYPKLX3jb2aBiKANUQy8i2QsytD2M7wPxVZb0RXm5pXI7zerNWgmnf
/t9Am20YlJ0S+3MuxeiBW3PsccqYPKluuOe+E4QAi2EaJZqq0h/tOevSHEoGUwEa
MCoNiQu/vXpnB8LdJ2j7fTiniZnJUGRJOyqA5XfL81HBfOuV665Y3yRZt2TUQ7XF
qblngZixUFTeBnDxZ5wP8bOrgC2qpAf1Q0tiKF6vizt0DQpbOep4t5ewr8UdErAx
WLu5W91e9cWgtOkovQmkRBqRYqh0/LbrLdYBRye1Yt18xcvPMUDtzKUPI/kgvwOI
DqI4r1C7OdKyrr7Nbr7uzYQ9QOxCVK+SUzV5NDcHeGGnTKyGxNd0bAXJ9CpfMfwr
PSKjAsMaY64CmKfWwC24ZpCSG3ePuPjNyHC4ACs5Nud10KVBAoO2uWX31F7IZ7KQ
vc/KSuuY4Ecm4FGWsIca
=YzxT
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
