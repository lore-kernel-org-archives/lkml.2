Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab2F3SK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 14:10:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52743 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F3SK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 14:10:28 -0400
Date: Sat, 30 Jun 2012 20:10:06 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: linux-next: build failure after merge of the final tree (pwm
 tree related)
Message-ID: <20120630181006.GC23990@avionic-0098.adnet.avionic-design.de>
References: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <20120629174826.546cc991459b12833f2aaebd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:P60J1SOKOK40IoJ6amiPjj4z1p90/IlsDIO9nbMWz11
 jyFzNl8RETe9VMzmQUddakqeRtCjQIHpufvasguxSCYz3XUqtb
 QXQcONOIGXrb/GyPgrM6c2pgPhgoDmr/5F9fLSaXnTJbEUNrUE
 m8SAmLD1S8VUbaNzi0xLfzBFnpYmTfUHPmsW/P7ljLh8t6fAkN
 FIZRXaqgZlBVkymvTnxPmiqzAfHorfwFAJIvInv/8HsCIVsAEc
 dIH9KcxkMtaLSZZT8uu1H6NQF0U5mDaqQmq5z6rv7qFjKApPNY
 VltgE8UnhZqCYXSKlZp0w9gw1uvRli+K32M2mbmLMRc9H2Ayur
 wodc2z5j4MdQJjEG4JjA9IKR4Vi1Kw0twRHMkS9BVbyEVHrxIh
 bQKXwjAk30fdvrLVXj+OSZFf027owlA5mT3TesengXx5aDbL8U
 fiayR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 29, 2012 at 05:48:26PM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/mfd/built-in.o: In function `__crc_pwm_free':
> (*ABS*+0x15ee601): multiple definition of `__crc_pwm_free'
> drivers/mfd/built-in.o: In function `.pwm_free':
> (.text+0x187a0): multiple definition of `.pwm_free'
> drivers/pwm/built-in.o:(.text+0x740): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_request':
> (*ABS*+0xaee34e3d): multiple definition of `__crc_pwm_request'
> drivers/mfd/built-in.o: In function `__crc_pwm_enable':
> (*ABS*+0xd83c7949): multiple definition of `__crc_pwm_enable'
> drivers/mfd/built-in.o: In function `.pwm_enable':
> (.text+0x18800): multiple definition of `.pwm_enable'
> drivers/pwm/built-in.o:(.text+0xbc): first defined here
> drivers/mfd/built-in.o: In function `.pwm_request':
> (.text+0x1858c): multiple definition of `.pwm_request'
> drivers/pwm/built-in.o:(.text+0x1178): first defined here
> drivers/mfd/built-in.o: In function `pwm_config':
> (.opd+0x2970): multiple definition of `pwm_config'
> drivers/pwm/built-in.o:(.opd+0x0): first defined here
> drivers/mfd/built-in.o: In function `pwm_free':
> (.opd+0x29b8): multiple definition of `pwm_free'
> drivers/pwm/built-in.o:(.opd+0xf0): first defined here
> drivers/mfd/built-in.o: In function `pwm_request':
> (.opd+0x2988): multiple definition of `pwm_request'
> drivers/pwm/built-in.o:(.opd+0x180): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_disable':
> (*ABS*+0xa4ee3c79): multiple definition of `__crc_pwm_disable'
> drivers/mfd/built-in.o: In function `.pwm_disable':
> (.text+0x186b8): multiple definition of `.pwm_disable'
> drivers/pwm/built-in.o:(.text+0x198): first defined here
> drivers/mfd/built-in.o: In function `pwm_enable':
> (.opd+0x29d0): multiple definition of `pwm_enable'
> drivers/pwm/built-in.o:(.opd+0x18): first defined here
> drivers/mfd/built-in.o: In function `.pwm_config':
> (.text+0x184a4): multiple definition of `.pwm_config'
> drivers/pwm/built-in.o:(.text+0x0): first defined here
> drivers/mfd/built-in.o: In function `pwm_disable':
> (.opd+0x29a0): multiple definition of `pwm_disable'
> drivers/pwm/built-in.o:(.opd+0x30): first defined here
> drivers/mfd/built-in.o: In function `__crc_pwm_config':
> (*ABS*+0xdeebfb06): multiple definition of `__crc_pwm_config'
>=20
> Caused by commit 0c2498f16608 ("pwm: Add PWM framework support").  There
> are (e.g.) definitions of pwm_free in arch/mips/jz4740/pwm.c,
> arch/unicore32/kernel/pwm.c, drivers/mfd/twl6030-pwm.c,
> drivers/misc/ab8500-pwm.c and now drivers/pwm/core.c.   Four of these are
> EXPORTed.
>=20
> I have just left this broken for today - please investigate a solution
> quickly.

I hadn't thought about the allyesconfig case yet. Adding a "depends on
!HAVE_PWM" to the PWM symbol should work and is the easiest fix to this
kind of problem while other PWM legacy API implementations are ported to
the PWM subsystem.

Sascha, Arnd (Cc'ed): what do you think?

I don't know if I'll get enough time to test this over the weekend but I
should get to it when I'm back in the office on Monday.

Thierry

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP70D+AAoJEN0jrNd/PrOht3MP/0EHhDlO3sfnI0eqRERawd6w
5KJpuqkH6TBeRGfpf1q5/gCO4/QHVQ5Z7q+R5pmgPQkvtSDPWFlrs9MEvi0Ijt54
gjd9PPizlz0aWR7eFpoIyVzS562sCJtkgfAEM+51jNGneD++UtJAOi/PMbmVTipO
+XN9DCURoPlp2eGq+s4RdsmJ9APPQ3YtzU3U2KvgRjnNW/Ruo/WRoehCUuFnOgPO
KTGTIPEYRyrgGOxP8K304qoZh5erhr8QP7C3yEzt3pWJGv5BkFEbsffiJphZEPqU
sL8PcJqxAaFWRL1Fp77L/SRIxYwX54VFejhzSz68nVbCkZxBkOH5nSZ9jYLy1v1U
T1o9qx97W+NMEE28lF6yw1MmGKnFoyih/5YjUENWqRT1Ep59J6cepHv2D2pYoK2G
PApHPE3EXDAPHLA0gLU1l8GNDVi8Km+UNhgla40DKkSnM6k/iWmD+LmeoLtk3OHN
rGc9ES7qHfF15t6p9IkcWSIJwEyy+JwTQV/cMDozPUXpQvUlJW+3R0RMzHVAU2E7
8WpPsK3AZocZ7LKO+xA9KDl9GVDiyF0gg+PM7RYs6zoOFJl9W8tNbCPHFKicm2c4
5uU2ht3mTclbw/WlAIg9dq8Hq/nb82NfPY0MmgdEupROJNymEiMUeuLCzuf26Tap
xIe99qpZ2SL17XkveYqk
=kjH4
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
