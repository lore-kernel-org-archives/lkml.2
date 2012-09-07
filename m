Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab2IGNWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:22:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53745 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab2IGNWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:22:17 -0400
Date: Fri, 7 Sep 2012 15:22:10 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Message-ID: <20120907132209.GG29340@avionic-0098.mockup.avionic-design.de>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
 <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qxfKREH7IwbezJ+T"
Content-Disposition: inline
In-Reply-To: <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:QHleC8KlyZ4Fy453SZpoxtKTehg5vF6aH8ymFV+KT3f
 Ou77hxLjVXDVm2i6W0o9309q0xiZJ5Dw0ejRHXFCGJuHO9O5dp
 srtuWzxkGYFYVxRh8vBaX1NK0RGlcFHVFacbmD5dDYE4snCcs1
 zIgFXk+Fkf+o2k5o7qEWQVZ71UDUG+6udcr3S9Efxhn4osKM0E
 dscf6YS6pIEUuEX4VXlDTTnmQF5/bxVQ17kraQjSmMsxfeCPjU
 +D3rIKM4uIg5q5ZWpzFQSeBP28eUkt/mcyXC6/orHORdQ4/xff
 1w2eqpb7nRgOZ5cFqXPHC/agAGyu5xoS1+xoiQs8FG7hv7NO2R
 WO9ha8hitS1jvISEAHzOzK33sflMS49tF4SDCY9qyyG60tzqJ/
 Cx3P9LPifQL0ReCieibik7bARQxW2M3xVSDPtuNhUkWl0PYGQ8
 j2Gxe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qxfKREH7IwbezJ+T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 01:28:44PM +0200, Arun MURTHY wrote:
> > On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding <thierry.reding@avionic-
> > design.de> wrote:
> >=20
> > > This commit moves the driver to drivers/pwm and converts it to the new
> > > PWM framework.
> > >
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > ---
> > > Note: I'll take this through the PWM tree, but I'd like to have it
> > > acknowledged by a few people who know the hardware and can actually
> > > test whether this still works.
> >=20
> > Pls include Arun on these patches, he'll know best if it'll work or not.
> >=20
> > I have one generic question: will this alter the layout of sysfs so we =
need to
> > change userspace? I had such issues before when moving drivers to new
> > busses...
> >=20
>=20
> Since this pwm framework is still a set of exported functions in a header=
 file,
> the file architecture doesn't really matter.=20
> Using this driver, either leds-pwm and backlight-pwm is used to register =
and
> this is where actual registration happens(sysfs entry is created).

Hi Arun,

Have you been able to verify, then, that the driver still works after
this patch? Can I add your Acked-by as well?

Thierry

--qxfKREH7IwbezJ+T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQSfUBAAoJEN0jrNd/PrOhOxQP/iuycFLQZdDR+qPYtByOOvHz
S1R6MfAGSLiGur0upxRlPJrFeXEcNakLAdLvXI+Dgvn7khq59fYvbFrXJAmrWy9C
mq28DdZEIuxraruhtgbrblc7oXHgE4Ds+Q/xNz5oApwGxry5saTIp9a/tigxXQyw
C5pvt2mBs7ceucXDk8qySCtSFwMWcQTw5yPOn+k5wPweIIt4mtD9y2MFpZejK/uQ
55lOMxH/WUJVZNm2/Pf+boMIb/wg+lOW9BZysjJ9X2jiYruuNxkGArqndC2f2S87
NDnVFhDlAe9PwaYOaI8NItTyz/k8LJBoFz9Su3zc7fjcGaZacE+8FMuFG4x/R/kw
XoC41zTnPg2wmiInQx1zX7oF0+iq7/O7bhbpSAXocStYdObKAor0UcnPvRjCmwVt
BnXAp2uuPcyfWww95iM8LIO3rJzkVX6rWaye5mKzkGjLrmOBpx4mKht9QeBHKh88
uwZjmkR/Q1ZlS2KQ73I1ZMtasdF8zvb8Tuiz1TcOLwtQTsyw0u+wxIyTmZjThVQS
cuwJVuFBkzB+9R6g5NyhWzDSMhkH0S5zOT4Dib9gSUGUlgQ4l0XmIo5CRWJy/U6f
DIQPgy7Uo8bitHkZ2zgfjpr+eO7OATmTiR179o8/ofNT8zr5BZKqjNGAuPTbNyjO
BBlyVPC/lvtwFVx1MPj5
=uKIf
-----END PGP SIGNATURE-----

--qxfKREH7IwbezJ+T--
