Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2GZHSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 03:18:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58878 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2GZHSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 03:18:12 -0400
Date: Thu, 26 Jul 2012 09:18:03 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Philip, Avinash" <avinashphilip@ti.com>
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com, vaibhav.bedia@ti.com,
        gururaja.hebbar@ti.com
Subject: Re: [PATCH v2 1/2] pwm: pwm-tiecap: PWM driver support for ECAP APWM
Message-ID: <20120726071803.GA28165@avionic-0098.mockup.avionic-design.de>
References: <1343215699-4575-1-git-send-email-avinashphilip@ti.com>
 <1343215699-4575-2-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <1343215699-4575-2-git-send-email-avinashphilip@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Dl+cmnADP6nHKorMK+e+HTWjohVf26dww2GChI+3pXf
 Tb/0iercLtUB/IUSHArjRt1NHdHuImtBXNuk7uTVb+KfRKEzPJ
 +cDVjYmWw7bm152CJQR2P0M3xizoWdve/Q4g5+GgjFmOYyZxDc
 yuvT8uuvOJ+C3xMGtZUGt0ZrH6YVdJCIgwCm5of6TKNMBFCa2N
 VNIfV1taKUWl5iyybiodLX/kiglE+nl51WKQpnx9ZYwhUWqT1s
 8xTQPtwbCIfZLAG7nm4r/UVTzDHERcx7sAEZuHxvZIMT/VBMTH
 q7JjPBROqppLs0DfyYQKgDA7POJUCogF3meEDmFZFTHspqjzrN
 Nz0i3RHOv/jCNBO9M4UTwuZQU3FUGR0k86WJHugLssbuqjLpc1
 g1LfrZ885ou/80aLGFENLQ4ALuGZtSsUuXwudt7OQlglDPr8ce
 xpvl/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 25, 2012 at 04:58:18PM +0530, Philip, Avinash wrote:
> ECAP hardware on AM33XX SOC supports auxiliary PWM (APWM) feature. This
> commit adds PWM driver support for ECAP hardware on AM33XX SOC.
>=20
> In the ECAP hardware, each PWM pin can also be configured to be in
> capture mode. Current implementation only supports PWM mode of
> operation. Also, hardware supports sync between multiple PWM pins but
> the driver supports simple independent PWM functionality.
>=20
> Reviewed-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
> Signed-off-by: Philip, Avinash <avinashphilip@ti.com>

Applied, with a minor cosmetic fixup. Thanks.

Thierry

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQEO8rAAoJEN0jrNd/PrOhhG4QAKanegk2HrICvcQy6X7f/Im8
FwQyayNYhhIr2JkhiidSdp03wXkRB9HmYmHWw+soPzbDfH5pCq0wv3zsP+Iqlv2p
ceuu1j1h1sMYAMBJtNTYI3E/naoPgvCDMyWRBQ68QDDmXG75q7J+ngUR0l0DG4zp
tleruiKcKyReOfJYLWYs3NKcA79s0V+YRsPqw8wp8VqAc5h3bH5mGAEJLHHTWQHs
FvnNth2fnovMxKSesyVV20a7MVfhGOSrVXlQPtz8N9r0MUJCApz1//iRz2Y8Oxg/
AsnN7oQbyJ/4Mf1L4syz9jOycGO7wRJwiq07J/ccT3We6M01NKjNpLTqJ5IJBbE9
LOAOGPV0ARpmopI3NNmYXJsKdZlG9JlQZkNe+AFlbXv1oYVf3RDQBrB+F54WAFQx
hjz3EdXBuc2NSPoUKMQhLtQn+/zhqbPV37pJwhFu2sn2IBRD+Nb71CHNBpFvHneN
egVli4O6igYv2GPguqCteADFMbchhIG6PL0nU3Rg8xkTbjxjr1wUkA4w+j4bRozo
zTGZkwTef1mOAYPqQ74yW+oikpuYWpniTSorS4fyDMOsK69EYIoowZAmZGFo/YKV
L/KlGpANfrLTJjI+yd9h67A5rqgEsi/6VZ+7nqN7/YgKKv0YDQHKwN5hxXcCfYBa
Qb/bSqQquo+Hol24PfE6
=iXN9
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
