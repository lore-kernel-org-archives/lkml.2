Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2ISLyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:54:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2ISLyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:54:21 -0400
Date: Wed, 19 Sep 2012 13:54:12 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120919115412.GA24731@avionic-0098.mockup.avionic-design.de>
References: <1347956991-16088-1-git-send-email-thierry.reding@avionic-design.de>
 <20120919112315.GA8138@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20120919112315.GA8138@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Szz4sBAiXSfQAmyp1U7PjS+YILOZQZKS5Ys2O+P2AZN
 moNIAZNeHtBxXXw+7xKYIsXfIh5Qzf8qZDqx39F+KVMQZVKdhQ
 myh8h0EJH+JmOOhTDbwvN1zRGFqKDXz6AITMjI/K+fmlbz2duL
 roWkLfIB3rHQKrXP1nRWfOENp1Q9de2NKB1yAqJaROK2XhpQYZ
 2hmwsoRw3hC0QrqUmMRluMzcQiNWQcRcoE+HbLJEu4uQZ+cBuR
 vrEpecmUN6a34HuxQMdDHZ2DZKDRSKqXnKtzuNvXc9ZrHhifvq
 iLXKqtEU0+P3FITW9LmYdHpQiJvRwKCQ0DGlxNNmOfvTqOlsZx
 lf8scPFP6MmmHBWQWt4GKMIuaVJ9cQGk7m5DBofBl2FKVMAOrU
 Er64Qm8xOWsdcFzZtojSStovw09Iyf/KxsHfPis07alqFUDKVu
 cinw+
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 01:23:15PM +0200, Samuel Ortiz wrote:
> Hi Thierry,
>=20
> On Tue, Sep 18, 2012 at 10:29:49AM +0200, Thierry Reding wrote:
> > Hi,
> >=20
> > This mini series replaces the twl_has_*() macros by the equivalent
> > standard IS_ENABLED() macro and moves the PWM driver to the PWM
> > framework.
> >=20
> > I'll take the second patch through the PWM tree but would like to have
> > some Acked-bys from people that know and have the hardware and can
> > verify that I haven't broken anything.
> >=20
> > Thierry
> >=20
> > Thierry Reding (2):
> >   mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
> >   pwm: Move TWL6030 PWM driver to PWM framework
> Both patches applied now, thanks.

Thanks. Are these queued for linux-next and 3.7?

Thierry

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWbJkAAoJEN0jrNd/PrOh0oIP/jAizyt+Vu0COSVn2FGvEZ6p
o7C4H9VBM3ciMIOrzbYAJYOooLtS+L+KLdUt+murEPCS5HLJ9kazsgSOVC/1e0cA
Zjmk1htmvcsUkFyZxwlAkzKg2eIOUdXKLcQ40feuK00uaDzuRrVsNyuNZqld58H0
AuGkSHfm66qLTT2eTANptRm+OKCohbixoDDBzkobxRAlLB+/33jzTUJvk6JYOW8k
/dffipqn7lJf5npfofrQrVRHJPAFKuQptV5kyeL9z1FLpPTgV6YBqLsLsvtZZdUN
lNUnyPH0IIRe0CJFq0VdOdeDBSyb6PqzbbImuH85UPmmq9pyMh2iB1aI7qiX9FOK
uPPJZ1J/vjbzqcg+N/6AyAlUIaO9/qnuLd3g5oCurHcRky6vYrOqEQyqigVlQPrQ
xwJu/yaDthmWB8E4okcI+wq/phtnUBw6rKuvwfZHOYBysrTwjL5P5+Tr8Ya3e82T
cnJllKKnEd81JhSW/0A1mN+SDn5OerNtjUALpE4djezIHkoNQ9s/HSk7/EKuN9tr
3YZXH+iM8YNYvALz7J5K/yfb99v0clWqS8NOwQV0Og2s4pzbxzK2jUA2LWaeqTWP
fkHIU/CSitq8yu29XnDkWn0gtH3bRHRS7C2oYy6BHlfZUMlUX0OZkUwK2+i8MU0o
8W8bnz59yH0emEMrDvD8
=DqXG
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
