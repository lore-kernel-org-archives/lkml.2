Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2HTHbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:31:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2HTHbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:31:47 -0400
Date: Mon, 20 Aug 2012 09:31:42 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <bryan.wu@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] leds-lm3530: replace pwm platform functions with generic
 pwm functions
Message-ID: <20120820073141.GA27645@avionic-0098.mockup.avionic-design.de>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0095@DQHE02.ent.ti.com>
 <201208200537.48993.arnd@arndb.de>
 <20120820055817.GA17149@avionic-0098.adnet.avionic-design.de>
 <A874F61F95741C4A9BA573A70FE3998F41EF0939@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0939@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:90mmISKuWr5JMdSuvrI+B6KW1EZc77m4COtpJhIsOj/
 uP1go3IV+M07TFdvnZxAJ3m+D5gYLfgM1fdhoIreSb5yImH+jo
 x0Tp7Ow7T/9JWm7xrEE2maWcb/Jh0y4sbveWe7+wDECoIBEZnh
 wG7e6QZdL5a2DXSc+QLVUoDYTR7/6g9vIZ6ZpeMUwnbqDazqoT
 YljIpl/uXrhRCF9PtjcjwPd4DqlhKmNypFJF9q2cuaoVLN8iGs
 bmN1aSkyTW+hhEAZSN+xL5WHvDIl7i8NVDJNtq2c/HOE3lxfJX
 +5841Lkc4s5c2EX5ibzPXvOlV6MBfF4U16vqM+mGoVOHTdPIB4
 Vq2/1Aui73AN5VovpcYI6zSdzRo18jlfSAYlhzpBL1dbS+Td8d
 nR4xiDqHyQi5saNzfry+DWQscH29dlelLc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 20, 2012 at 06:16:41AM +0000, Kim, Milo wrote:
> > > * Rather than having to do the #ifdef here, I think it would be
> > better if
> > >   the PWM subsystem provided stub functions for pwm_request,
> > pwm_config,
> > >   pwm_enable, pwm_disable and pwm_free that do nothing, so you can in
> > effect
> > >   let the compiler optimize away the above code.
> >=20
> > That's actually on my TODO list, but I think it needs to wait until we
> > have gotten rid of all legacy implementations. The stubs would have to
> > move into the !CONFIG_PWM branch, which will in turn break because the
> > legacy implementations would provide non-inlined duplicates.
> >=20
> > Thierry
>=20
> OK, then it's better to wait fixing that first.
>=20
> Bryan,
> please just ignore this patch.
> I'll resend the patch later.

Maybe we should get this resolved somehow in the meantime. Resolving the
other issues may take another cycle or two, so you may not want to wait
that long.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQMefdAAoJEN0jrNd/PrOhPyMP/A7wBDJGTfz0RRPgpCAAyoeA
+hYmo+SzK+tCANaBC2R2A6gFma4TVvhQAdfwVYv7HB54b2mJ6MY5mXIxjBsoIa3W
+DUnSeqZlJmxwx3ntJmoL5fE+TrI3oc7LhlTkpQvZQIVuzqV+Sj/8LDJgJxf3Xe2
Jtcn554rl6RcSbolyrRoZnbFwNya3GpNICcpvY2Xew1A1wEME/WuedQ6byrpktxL
CajkvnItlV7ztlWvGlS9oJGuTi4qvx6QQvUD+x9SamY0gXqyfRfGZ3vAfT6xAaDz
54JC40+ZDFLKL521h7ENYNTi8vWsUB20N7MaeAikYGg0WdaYBeVvfao0r/bFcpjM
/wXEo9s/JDSa25K4swDPEAVk0Ame3tMHHMeKT5efHBQt24Hg50RA5B0Rv//V3xxP
u+3ePFG2N6XV8YWogQcuIVCKkuN7e3ODVJOFTCmdmUkf2suz0N8Tl8kb8hyttnMr
TrQ2M8dAXoA8nVeAf2rY2q885jBUsrghIyUCl6ueHtsVnGotY75RCHOmNEdGiC1F
7OBfJ9yE1Dp20GxfHOIjKdhXCFx+ZFuP8yESSKtfGQkJo8Yyt2t+IjaJZ6Z17HLy
1RTijdYKpw8fHmILm1FpGfgX4XcOJjsl2zuL3QOA7XffEKtPJLpDyeporNPKGY7A
qfJ9fiuM+E8qP0NwcIzm
=d4Q+
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
