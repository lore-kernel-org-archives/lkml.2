Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2ITKyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:54:17 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63606 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab2ITKyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:54:16 -0400
Date: Thu, 20 Sep 2012 12:54:09 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Message-ID: <20120920105409.GA4033@avionic-0098.mockup.avionic-design.de>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
 <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
 <20120907132209.GG29340@avionic-0098.mockup.avionic-design.de>
 <20120913152558.GA19478@avionic-0098.mockup.avionic-design.de>
 <F45880696056844FA6A73F415B568C695B44A603C3@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C695B44A603C3@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:6b6pBzalnOPUZqYDZwXhhs5ERf7Ue6tkJB328lNORdA
 x8BYDo2vQSMv4MmwmucRJGPjR9qbANaQ10B3EGqw8lZWRqu1Tq
 HnE/UDW+WTgWhpbN8kalmP7LSd+Kpl0UqExoW2r3HXv7OcaWmO
 LQ3PS/UAP5UmRXpkRcabKpTSMnfZEgLukVrheWQjz9k1+FZqkf
 A49Xslf5LZQAVgKPChCpxJzFe/O+lqv9JsxKBhCy9tjDlvujk0
 XFEcT40WuSzjk0+gyFYa7mMr1Y/Uu9JWeB2lJSKC6BRuGfKNST
 lVZZtULo9KnlzBsBKkabBbgrmiaiPWJhLrysjHk0LUCDrLgDX/
 HNXOl++CEIW5BIJdzv2r2DZYyn9XEx8inN24xexr0Ec2tTbGvl
 77OkSl+/QzG/8UQg6OC2zal7x+7D2VD5s5iVmMMMxRBsIsLJbD
 BUkAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2012 at 07:01:16AM +0200, Arun MURTHY wrote:
> > On Fri, Sep 07, 2012 at 03:22:09PM +0200, Thierry Reding wrote:
> > > On Mon, Sep 03, 2012 at 01:28:44PM +0200, Arun MURTHY wrote:
> > > > > On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding
> > > > > <thierry.reding@avionic- design.de> wrote:
> > > > >
> > > > > > This commit moves the driver to drivers/pwm and converts it to
> > > > > > the new PWM framework.
> > > > > >
> > > > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > > > ---
> > > > > > Note: I'll take this through the PWM tree, but I'd like to have
> > > > > > it acknowledged by a few people who know the hardware and can
> > > > > > actually test whether this still works.
> > > > >
> > > > > Pls include Arun on these patches, he'll know best if it'll work =
or not.
> > > > >
> > > > > I have one generic question: will this alter the layout of sysfs
> > > > > so we need to change userspace? I had such issues before when
> > > > > moving drivers to new busses...
> > > > >
> > > >
> > > > Since this pwm framework is still a set of exported functions in a
> > > > header file, the file architecture doesn't really matter.
> > > > Using this driver, either leds-pwm and backlight-pwm is used to
> > > > register and this is where actual registration happens(sysfs entry =
is
> > created).
> > >
> > > Hi Arun,
> > >
> > > Have you been able to verify, then, that the driver still works after
> > > this patch? Can I add your Acked-by as well?
> >=20
> > Hi Arun,
> >=20
> > any news on this?
> >=20
> > Thierry
>=20
> Hi Thierry,
> 	Works with certain changes in platform data which I can manage
> to push it later.
>=20
> Acked-by: Arun Murthy<arun.murthy@stericsson.com>

Thanks. I've pushed this patch to my for-next branch.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWvXRAAoJEN0jrNd/PrOhOrYQAJ2HVI+QzcOzR1UA96Wa71sJ
VDUJkkVnTSG99xXyL6dZ3+x6KcUlf6QC7FoRxDm3Z6lvWBJtumeLCia2qo3OtDIm
hbA6mZZHxxyEr6NoE3a5YtXODfsjsJ3DuCoAQGGJDTnd3a35xgOF7S6tLfiYQpHP
e/SkM02i9fXooeJQ1WqByIEpHNIxtoGpf+nXOGiUyB8CG6dxQEfNshztbNNceFEm
PQHC5QAOTfz17pumunjmkCSkjYqKs7OdFd1x9kINGzl347JXuOMVj39uen6OrAn+
0rSo8EGtY54ZqLAi1+sT0Q+FozcFrfdxR1nOcGl9slbXMotH44sUcNgPm/ecs0MY
mMO5h7Wg9y44mCtiPixkQ/FV44rHavDINWn8R6Ox2rBcfz1tXNPDi5TGpCMX8fVS
9lAnrFR3IaN4/IZfKY9W3koTf2ZY/kugUt3UX06p4d6J42SI1WMP+wfuV6F3Hpq3
+jzdw4DIo9KcKrn4N2CxpK+j0i4OukXKa+luXDiGalNeSJrBSCRC1GNiEdFTBQ9W
FTvlIUcC/ZQsbHogzboVD4rLYMp5JMuif0FoIqQ1ZcQYu4ApgKF9vNV57cdEJsgT
mzZbdIJI1rx4ET/wyQ1CayeESJx9UXy8AoxjGgjPKsL0j4izFkuVQK3WajnI5ixm
HtLvtu/oKE4yff0HqJgE
=dYIX
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
