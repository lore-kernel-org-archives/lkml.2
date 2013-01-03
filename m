Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3ACJGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:06:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59122 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3ACJF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:05:57 -0500
Date: Thu, 3 Jan 2013 10:05:39 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v2 2/2] backlight: add new lp8788 backlight driver
Message-ID: <20130103090538.GB1845@avionic-0098.adnet.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F69E108D2@DQHE02.ent.ti.com>
 <20130103080803.GB30631@avionic-0098.adnet.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F69E11090@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F69E11090@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:2lsCbdWUmvquwqvvdesv2DbLbP9fEvdOLcAYn6mdEPl
 iJ52dBt8Q2L8CCzIDxPHZssic6wyQ+Ksc3pGxoXqqSdd4YYXNo
 dhEhG2U9o9eZjUgHw2+hdSmZZABOlfbEyohwOdg3BimyyJsWnG
 oWUCp02noHIxVEy3ixtIrhfwwoZS5i8dESyepz71PRYYCr2lKs
 A0xgSYK30LfHoDa3bURryQWtQEjpvhtKtuihrV39/DXeYTzlNW
 9p1Jw8e7w7d6ZFLDRHFXUE4NznZZFu8BgXmycsdbhdwXiP68Zl
 s8q7ln40MvoSU765BYT4XI9JJBzZiHOZJ+0w5R0NtMToOfJA9y
 Eb/VrfGFmTfbtVNxmJ43KTFWwJ0rV4R1hwrO51+nPPEJGErj0S
 e772jWX3/ozGwZnq7FV49bBuAJ7kzUEMxQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 03, 2013 at 08:54:27AM +0000, Kim, Milo wrote:
> Hi Thierry,
>=20
> > > (Platform data)
> > > Configurable data can be defined in the platform side.
> > >  name                  : backlight driver name. (default: "lcd-
> > backlight")
> > >  initial_brightness    : initial value of backlight brightness
> > >  bl_mode               : brightness control by PWM or lp8788 register
> > >  dim_mode              : dimming mode selection
> > >  full_scale            : full scale current setting
> > >  rise_time             : brightness ramp up step time
> > >  fall_time             : brightness ramp down step time
> > >  pwm_pol               : PWM polarity setting when bl_mode is PWM
> > based
> >=20
> > You might want to consider using enum pwm_polarity from linux/pwm.h
> > instead and convert to the driver representation internally.
> >=20
> > I'm saying this because I'm thinking about extending the PWM framework
> > to allow PWM polarity and period to be specified in the PWM lookup
> > table
> > so that they can be treated transparently, independent of whether they
> > are obtained from DT or the lookup table.
> >=20
> > That would allow the polarity and period to be retrieved with accessors
> > like pwm_get_polarity() and pwm_get_period().
>=20
> OK, pwm_pol will be replaced with pwm_get_polarity() in the next patch.

No, you can't do that yet because it will only work if you get the PWM
=66rom DT. I meant that once the pieces in the PWM framework are there we
could encode the polarity in the PWM lookup table and *then* use
pwm_get_polarity() to obtain it instead of via platform data.

For now, I think you should only convert it to enum pwm_polarity so that
at least the data type is the same as the one used in the PWM framework.

Thierry

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ5UniAAoJEN0jrNd/PrOhy5IP/07Ct6TRUh30ctUX3SKpc+W4
4mK8Xlfls6ojKRiXqz+RjHETadWEP9PpCW2rYmDnNK9cGWnFXYQ5UGXHqbDC3+73
LoFHwlq2e4Zk9mVc6n/MWylRfBP5vTrkjmKD7JdbwdS0p7djui/tDRFhIJkn2tC/
3qKcPqYSDMyYiBV9Dlrxa/oKay7yoQPRUoDvfEOKVnuh3CmF0Dqz/RnK9aa6/GKu
bBjruQbJDnwB4q0q1z9CbTnf2VY7Ng1636qEU19SEZ4+99yf51luAKXkxbRgcG0+
tEIfeoCmbdEq2QXnsVqX1BHq9jeHhh1g/s1wlO6tP3QUz2WbRhKW/BSxMV/VmePi
b/WKsJnaPNk63aYloO+ZQxGTFTyWbRxi6Lmx6CJP0wp2QddxzdPwj/STJmwH0ylx
F0sJsXrfoc6yhLVPidiEdkrA/O88ZHxxukoNqdu/hYPlqLk6kSvOxQ+t+lroPQC4
7EXu79MJxTQzftoG1CX7+NaTj1awJ9PuKwAvjeAsgN28DtilTJAzeHI6H1fH3YiM
0hDclDtwrsctecKh0402atVcXXruCDvemaI2FG+tyZBpigVJGtkbA2rf5jHgXEdm
yYDwwU60y+675WXsGuLhUENSTw0wADoz83QHOKgFRpOp5Z4LUIL87abc76lrlrxp
oMs6W3//SV/Cl5iBfmEY
=CMRj
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
