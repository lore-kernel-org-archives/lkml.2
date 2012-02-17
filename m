Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677Ab2BQSpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 13:45:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55148 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab2BQSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 13:45:18 -0500
Date: Fri, 17 Feb 2012 10:45:12 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] gpiolib: Add comments explaining the _cansleep()
 WARN_ON()s
Message-ID: <20120217184512.GF10146@opensource.wolfsonmicro.com>
References: <1329503041-11517-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CACRpkdYuBpeKSe3HtWW8Nu=z-tnOTCCCkjvbnf8uu_udJ8Matw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <CACRpkdYuBpeKSe3HtWW8Nu=z-tnOTCCCkjvbnf8uu_udJ8Matw@mail.gmail.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2012 at 07:41:33PM +0100, Linus Walleij wrote:
> On Fri, Feb 17, 2012 at 7:24 PM, Mark Brown

> > + =A0 =A0 =A0 /* Should be using gpio_get_value_cansleep() or a differe=
nt GPIO */
> > =A0 =A0 =A0 =A0WARN_ON(chip->can_sleep);

> Actually I cannot parse the "or a different GPIO" part.

> If this means that the user may be addressing the wrong GPIO pin,
> then we could spell that out I presume, but maybe you are referring
> to something else?

It was intended as a hint that if you really need to be in atomic
context to do whatever this isn't the GPIO for you but in retrospect
it's probably not actually useful advice for most users.  I'll respin.

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPqAxAAoJEBus8iNuMP3deY0P/3olqxlydy95zHoDf8NSfUZN
Y97gSNGE7tudc9U/+vRw3YDRmlraW94OkhGuKjaMCq1NsOhPPV9DTv8c5RCvX2OV
eR4zgKNvseYhliVzT1vNwAyj1f/gEPws2uUsAi8oqMnTxuHRm/U56syjxG0sshkU
vvPf87fNVvvinyuj8t4eR7nSHZ7Kez7pE5RfJbFyJdzaLeq9j5RqDmuGxvYQsF7s
XwhcHMiCEArJ+d5C3z/bEHiiwl0fFuho3a5Ko4KvFi/J9EGMvduRLaHe/yQ6g0Lb
pt94XA7AFM+v/kp/4+SetRlN4/XrRM6iciZYz5TavzDV0Tur7t8FiQbgKbBOBg66
/GU0iVmDk24f+HivqQ9AvBwJBvrY+ch0H7NChUDKZhQFjx4I7Lj1viW60SVy7ESJ
T01JZ5x4/5hi7ArJa4sWj/p1YU8h90RGXCW4S0O5E9BHO3b2gv8HVc4uJbyEmiP3
ClZNHVeLh+YteSsedmcrHUEyN3Hgj4m21rSOmkHMryM691qOYF8Mu6m3lU4JUgeX
8yfv2Cgzjz8yKkl+3m8K4W+SIxiYcTCrCxe6osWWl/cwFUGGk1NVmeMf7dFS8nZK
gy1LPg3AuDQ4CUvt37gnSp/6YZu5Ta1DKIRZdKc6pVJNnAEM7VCuYmEo7sztalrr
6Fb6jn11c9ZTpLaDTjzi
=Yv/C
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
