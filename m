Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2JVIa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:30:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2JVIaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:30:55 -0400
Date: Mon, 22 Oct 2012 10:30:49 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V3] PWM: Add SPEAr PWM chip driver support
Message-ID: <20121022083049.GA29790@avionic-0098.mockup.avionic-design.de>
References: <1350877903-8578-1-git-send-email-shiraz.hashim@st.com>
 <CAOh2x=mNWNtwcWB3a=mCsfwC8WqXiisW8zeg9amsXy7b2nLCkA@mail.gmail.com>
 <20121022060641.GB3900@localhost.localdomain>
 <CAKohpo=LHjV2tV1R34Q_As4s2Yh071+t-bLyFBDGSZ_u5vKo7Q@mail.gmail.com>
 <20121022075534.GA4931@avionic-0098.mockup.avionic-design.de>
 <CAKohpokDscKxhpKjdkbU+Q95VQPF-bDviyL3LAcbgeaQWk6ERw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <CAKohpokDscKxhpKjdkbU+Q95VQPF-bDviyL3LAcbgeaQWk6ERw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:004AGiuaJDwbuAOR/Vqp8et/TAAJdDh0lm0cq6VxTvx
 F1nibafHPrWPCdXXuKTciLUJh3I5yOKEAYZa2tVHW0nxZSFw6W
 roTQJDV/5ytsUyXJG26sCxCmsdW2+A7DPoUtTCuQ8coAaks2Gu
 LQ/GZbstxWl6duVdBHptt39S3FLOAZhMT1jcpgSJhX9CZr90S+
 88aX3LZqd3Dgta+pW3lhVCrfS8kEcpiC2svgoob8aOlgT6MYHm
 Ar7BfFc3zpjuKY1BOEMyJA/atINdz7RuREa9ly0cF2AIfQptdF
 k000jprNmshpEDaNl2IFgM5idEm3CspxDMgibMrsYGgravDH9g
 Ik94pmywZpxsK0QX2fk0pQ7BPRVrr7jYwOj1Gk6LEw1disTE7v
 4Ay/7VKANwclJLw49/VCdaJovBriFW55OA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 01:55:29PM +0530, Viresh Kumar wrote:
> On 22 October 2012 13:25, Thierry Reding
> <thierry.reding@avionic-design.de> wrote:
> > We could probably do that in the core. I've had some discussions about
> > this with Lars-Peter (Cc'ed) who also had doubts about how this is
> > currently handled.
> >
> > What you're proposing is different, however. If we put that code in the
> > core it will mean that once the module is unloaded, all PWM devices will
> > be disabled. There is currently code in the core that prevents the chip
> > from being removed if one or more PWM devices are busy. But as explained
> > above, with the current core code this return value isn't useful at all.
>=20
> This is what many drivers in pwm framework are doing currently too..
> They disable
> pwm and its clock and then do chip remove.
>=20
> Sorry, i didn't get the conclusion completely :(
> Should we keep code suggested by me in core or spear's driver?

I think for now we can keep it in the SPEAr driver. I'll make sure to
refactor it out into the core once I have a good plan on how to solve
this issue properly.

Thierry

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhQQ5AAoJEN0jrNd/PrOhNR8P+wQ2jEg9eBaDXfxiZ2/hMNgw
BIGCL32nyuMmluEPtN3ir5EZoKwqsohlRDlNGKW4FvLYJGEC7bYo+Ce/4E4Bdrd7
fqwm8rOUkbtzAh3QYygH6+msydrfAe5PGupCBv8Vijse3JaoM4M+B3hSgXA/LcNY
rmbUUj3cRkuxZ4NFIWpe5k+OZmsQJXiXdWlS8hUMta+blrpcmA5tnJ3RqWT3FLFR
8uTfhTSPHKe10rTFaPwjYT0ul1YB03uw4Kc2oC9kGwmC0NxA123jTw0A9AT5p9YD
jr5j71u421sdtmXFEKP4Fn6zkDdoOpo73kzx48CKxbZH7i6U24EkBjbVEZ6CZ1dv
WCnnx4Wb6kqQYrzYqZZCBYNwgrcIIdxYbuCFbh8LdsqPu5Q6DHbt9Z22sfykr3z7
f6GoS3wVnGZFXZZZUYFyZ8Gw9OS0RX0hvrZJSLRsXsahYPFLjRM4nkukGjEbvtox
FDzyB++DE5GzFDN+HiMHJbO7CE7+QeYM9RY0vbOIgHo6tKJKTmIuizxTxgi3NLKR
CI0GGuH4WuD+B0psPIYOsl69SXJUiua/1xXopQey7cTkEsbxAS1NLVaNaae4O50M
UQC2cGIrWj2Y2+zQC/XZE/8xfAKF3JqVYRRyV/wKrW4bXPLnYCwSFBACDm3iceZg
B2GW1GYKlfjy3ltDTPrY
=Se06
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
