Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab2LKJsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 04:48:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2LKJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 04:48:27 -0500
Date: Tue, 11 Dec 2012 10:48:12 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: Re: [PATCH v3 1/4] leds: leds-pwm: Convert to use devm_get_pwm
Message-ID: <20121211094812.GA22222@avionic-0098.adnet.avionic-design.de>
References: <1355133637-2784-1-git-send-email-peter.ujfalusi@ti.com>
 <3193669.Hv54bBklsP@barack>
 <20121211083632.GC27084@avionic-0098.adnet.avionic-design.de>
 <1406670.ryvqfkiNXS@barack>
 <20121211093100.GA8437@avionic-0098.adnet.avionic-design.de>
 <50C6FF69.3030001@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <50C6FF69.3030001@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:A3KfJJz+ocSijxvDKiSRbWv+RL1AQq9zRpkq+vTZjV6
 BAQqret4m203dx9DodyC4jdr+/0NeFVVy98SjBdJYbAJyf3i3I
 8e9z+gjxAsn/VQQxqgEW+rVpBSVVg6ZB2snjGMdxyXnfWwlCzE
 auxOrNpNdlqfZHEumR9PycjnN/3baMuLAhcygQjGXdjVJtIcSM
 bak0P+QIzHbXW2HX2c5coRVth+ijYzbW+p5YR4fK7lKRxVUIoi
 EJLkBzXDhFkP2QFSRe0Qnc4RKdf7wiIkgKXWpN/5E326TfQg/U
 5Y9sDHbzxFTo88lX3qZd+UOUyW2b6Ceb17gBovurzEjBzaHlPh
 NB0t3EPr+H9HNy9TyuSwEib3h0VEJv5mXgatxBdyZz560sP3po
 ieBExzRMawVkjzWr0CYLfnbnNa/b93Lx/k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 11, 2012 at 10:39:53AM +0100, Peter Ujfalusi wrote:
> On 12/11/2012 10:31 AM, Thierry Reding wrote:
> > On Tue, Dec 11, 2012 at 09:57:51AM +0100, Peter Ujfalusi wrote:
> > Okay, if there are no intree users that may be broken, then it should be
> > fine to remove it. In that case you might want to remove the pwm_id
> > field as well instead of deprecating it in this patch.
>=20
> The reason I marked the pwm_id as deprecated is to signal to out of tree =
users
> (if any) that they should stop using it since it is going to go away in t=
he
> next cycle.
> If we remove it right away the sdp4030 board file will not going to compi=
le in
> subsystem trees, only in linux-next.

Okay, go ahead then. As long as the field will be removed eventually
that's fine with me.

Thierry

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxwFcAAoJEN0jrNd/PrOhJUUP/0efndKIXn3fk1TL8UxRlCG9
ISfxJ53VOLaCuVxK92Cwg9dYlmGVk3CGLdr4919Z+QVI0JzuNSjS5hiYAX4SRSyA
Y3cg+Jk+SCOy35EDpi7JJzcD2of54Tgo01O818fKnS9yS3vt5VZqzIZZhEfQm5Kk
OB8sJOV5KIphjxA/0knsqqRpELHyWmPPFYoW1OCxZO1/MkNPBkx+VnVNN/u3SyHQ
J+nEyWF03jzC2fY4Vi0CKKuYOtghSvKTA99hsQzACy10PcdTUpv0VPKXgexZ2YCO
vWlBEyNPWqiLKLag4cBSPfGh3b759g/Naw9npgO+hGe4BRIjQ/jGFYSv0mph7sdw
9KUuWA+iTGZajQhI1npqRnHnGPp/ir3rJs2cmQNEuZoXzYWK3pfxwaFLHQOSqDDU
PTmS7gqwfuXxTBvdXSLfmjC+8aKZyowGzRajzL1Chwejj1I9kgK9jgg1oAOHDbfU
XMlV7W+G0hiiaHfKgC4N0p1jRYqj3WAjzvwHKYEEztTZ7WWvUAg+49yZiGCKxR1S
KWQ7v17Adcg37veKo8QFn9PaJqBbeE5z1w7fdF4Cvier8meljhujRL0wv3spzZdJ
RTA4A38Q7qpiHaxrZbqVKIlWzcJVM8eRnNZ78BwXqPMfNqdYgOpmsO9ZnzRNGoFh
UqMQjI6UWKvQcc2vJatZ
=lTqb
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
