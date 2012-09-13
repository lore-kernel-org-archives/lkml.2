Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab2IMP0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:26:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52748 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2IMP0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:26:04 -0400
Date: Thu, 13 Sep 2012 17:25:58 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pwm: Move AB8500 PWM driver to PWM framework
Message-ID: <20120913152558.GA19478@avionic-0098.mockup.avionic-design.de>
References: <1346581858-7469-1-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdakZMWnk1zzFqa8SXLsDn9EaSxzKnH_yXoCaxCY5saVJQ@mail.gmail.com>
 <F45880696056844FA6A73F415B568C695B0EA11A90@EXDCVYMBSTM006.EQ1STM.local>
 <20120907132209.GG29340@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20120907132209.GG29340@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:5+xUjaTX2+97O2liIZx111iWvuDUiaYWfF7JtBttkHb
 LLAxFaxJ+Fd2kF/62d5Ixt3dw0KtZ8DiwaRVW36ghU5uZ6UcrV
 mrTFAte+RnLnFwqRqZ8/1JocDWvMUrE1LmEN2ACnzJxZtb9fvj
 D9CWW8X1YWDSTtAqTkRWv8KEEg2a+oNO240MnNV718GFTf6+1J
 UOaGJJFJ2C5iElBTyjZYAGvzsdvEKPqXh6gaubUv4Cmwzj32tL
 f3lCD25dT4p+Gz0nwLzb9UDrMUwTgPWgZEksgWfAZHYGYg/zWu
 C5NqpGnNe/ABSj0DvNjgImHuCR/IbmWKsCW0Hs+aaGuo1elJTN
 Titu03dn6XauX2W1O9DwBNRBjdpTHdZ+9241/Gag5gmTa4M/wd
 2NSkEob6t0RnQSgzI6XLcFOJbcFj2QgCoA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 07, 2012 at 03:22:09PM +0200, Thierry Reding wrote:
> On Mon, Sep 03, 2012 at 01:28:44PM +0200, Arun MURTHY wrote:
> > > On Sun, Sep 2, 2012 at 12:30 PM, Thierry Reding <thierry.reding@avion=
ic-
> > > design.de> wrote:
> > >=20
> > > > This commit moves the driver to drivers/pwm and converts it to the =
new
> > > > PWM framework.
> > > >
> > > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > > ---
> > > > Note: I'll take this through the PWM tree, but I'd like to have it
> > > > acknowledged by a few people who know the hardware and can actually
> > > > test whether this still works.
> > >=20
> > > Pls include Arun on these patches, he'll know best if it'll work or n=
ot.
> > >=20
> > > I have one generic question: will this alter the layout of sysfs so w=
e need to
> > > change userspace? I had such issues before when moving drivers to new
> > > busses...
> > >=20
> >=20
> > Since this pwm framework is still a set of exported functions in a head=
er file,
> > the file architecture doesn't really matter.=20
> > Using this driver, either leds-pwm and backlight-pwm is used to registe=
r and
> > this is where actual registration happens(sysfs entry is created).
>=20
> Hi Arun,
>=20
> Have you been able to verify, then, that the driver still works after
> this patch? Can I add your Acked-by as well?

Hi Arun,

any news on this?

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUfsGAAoJEN0jrNd/PrOhkHYP/1UkJRc15uFgMVi61El3o/nf
2286XeCyny6GlZ0EvmA/vLIFvmcvuE5eF+eKVWIiX9/BrcloXf2YIdyOJ8FFgZSl
P3F+Hrcr3Aqbg75hQJ+kX1++AU4VT1CMFM9RyfbdS746Cy5W2aNMlvqoAhajnhQ4
Bw6zJZ9MGB7o9YshG0KGYHS5VwKNDKY31qIShAbYBRNut6NNbeaep98enDTqJ2d2
GftFE1ywVzcVpT1anCEdP+Rgg3vIEEt/LgemmHSFrQfiUtw7XlSeMOkTI4HHgWzZ
L7fHIJ2lZuV/35sM+F30LUR3uHedp7pm837lvQWyDIH20a99qthC9/sv7JB5Rldx
+NalTU48fjGMaxALEielDS+dBJDIrM/X7OeV82EYU9ORTyX2nVxg4z6fYZk+jKqE
bkMoIfvhQuSji6izuwweJOph7wETlLuNGCAn6h9pCAJoiezJ289LHqbYEdDXzdb0
Tow8sbdyXwneRi99DyZ4ibMmy3om79dRJSJiXozI+uzXiGK7TVunOC6wfruSpHBW
06H0u8QbDY09YqG/pSBqorQX3quHCyJIDGHEzSSINPwfkfdK8+5ezV6LP5IPO3C/
hGfy06MGT7qeTyn7MB7P7Ye520yLFDOCrTZ7o7Ojc254X4D/+p43V2PaAfsF6NYT
JxXZ1h7gHMxtma3tsrQV
=5v42
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
