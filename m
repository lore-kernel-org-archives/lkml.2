Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2JXFno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:43:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:58178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2JXFnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:43:43 -0400
Date: Wed, 24 Oct 2012 07:43:34 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH V4] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121024054333.GB9787@avionic-0098.mockup.avionic-design.de>
References: <1350904001-7621-1-git-send-email-shiraz.hashim@st.com>
 <CAKohpon7e0+PhikmHkgcY30gEH0v+nYJzctA-0wN7w+oDRO7Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <CAKohpon7e0+PhikmHkgcY30gEH0v+nYJzctA-0wN7w+oDRO7Vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:/YPfCbw1kM9w40vTkWSybHcYOx0Jg1nAjCLRFT73dxC
 rTTNbhryrYHWw16Ln5qPYQVkcZJgW32gU/wdjn6N9zMfyporkh
 Tr4DTrGOO2ASES0NM9HdQeMe6U8HBCR36DSVEqsYdvh/0kM6pk
 GVxT7DNgXx6RxPuxRz19ihxkwLqbMQcm1SUE+UOHmgCqPxnzRV
 UraJSCzbICzXYreSd75UeykjTLwGOZWcvdPp0r3uFuknJfmf78
 aN/VD4Q2QcQvLwE9k2jyzLZaVzwOEK6sYeiCFsM3EpJv76il28
 gweU84H8QIEsyPISRpRk3Hqf9xDc3XxEtZIkcJUdWtthHjPgx1
 CKyxtIHntxLYtAgjSZgk56M5ejgq3L0Nkwo0Ok9t82z+QyuEva
 Z3PHZLTMCRTqQzUuAbPPuCp2zz+U1OiyMo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 07:25:45PM +0530, Viresh Kumar wrote:
> On 22 October 2012 16:36, Shiraz Hashim <shiraz.hashim@st.com> wrote:
> > Add support for PWM chips present on SPEAr platforms. These PWM
> > chips support 4 channel output with programmable duty cycle and
> > frequency.
> >
> > More details on these PWM chips can be obtained from relevant
> > chapter of reference manual, present at following[1] location.
> >
> > 1. http://www.st.com/internet/mcu/product/251211.jsp
> >
> > Cc: Thierry Reding <thierry.reding@avionic-design.de>
> > Signed-off-by: Shiraz Hashim <shiraz.hashim@st.com>
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > Reviewed-by: Vipin Kumar <vipin.kumar@st.com>
>=20
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>=20
> > diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
> > +static int spear_pwm_probe(struct platform_device *pdev)
> > +{
>=20
> > +       ret =3D pwmchip_add(&pc->chip);
> > +       if (ret < 0) {
> > +               dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> > +               return ret;
> > +       }
>=20
> Sorry couldn't think of this complex situation earlier :(
>=20
> Can it happen that we get a request for a pwm here and its config or enab=
le
> gets called...?
>=20
> If yes, then we must call clk_prepare() before doing pwmchip_add?? Otherw=
ise
> you will see a crash :)
>=20
> @Thierry: Can this happen?

Yeah, it's very unlikely to happen, but it could. See my reply to the
patch.

Thierry

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQh4AFAAoJEN0jrNd/PrOhxIQP/1ZPpF1zdo4XGsiYZPozsWxC
n3/q6KU7LGFZGfSTegiKkra0NQ8JZ0CLQqLBT9Na5eB1SBmNjA54dnLBZ8so0Sg+
RHCfWk8jBju5h/tWRXMp2BA4hWDVG7ys3inHVKJ5gWU9WLIBSsSNrBf3Z5xfI4vP
jEp4M37zdFqH1Los6bRG2mBIisH+u+Ive0f/kU6ZCnS2iJs3Q2g0bxDV70K+xHb+
D0E9pWAP46L8bOzZEiCzhjbbetAjnIHOwobDTDnWmPwsU+68+oGnCTS/GQ9nf4oq
/pBDNvKpNxm5/YfFRZOWTgUQjOgv6jIQyb+Jx21LTCl1RS+g4HhDaE8lcXBNU/PV
hb0LJz1V7lbywDE0Hm0/J5DiNcIfdU/unkwPz4coNvMOeiGecOea+9FN5lta7xIk
POhOR9JcKByMEKTr81WbjQgSRsnmp0DDiQbXgYUTaZTkhy8Lr0Fc7mW3MOfp9x01
CXUigukTKm1Aph7f6ioGpFvyYtEVIqo4ldoI/4ljqvxEDfMDDdPldCoytME1//0I
SYnNFw2uODzZ2zWZqS0S2jemWwQKK7aaO9wRk01IWEEIRKhFTDRIkxMN6WVFbKGP
GzbWmE+lnMCycupe3eIqnpspy5bmoSY8Bv+xKvEoN2rCDp19+nBg/j3s/enmz7wW
6ubIzFKJIBKznoWq++Oi
=d70J
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
