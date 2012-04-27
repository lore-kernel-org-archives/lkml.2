Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577Ab2D0Mgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 08:36:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41868 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754237Ab2D0Mga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 08:36:30 -0400
Date: Fri, 27 Apr 2012 13:36:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        balbi@ti.com, Herbert Xu <herbert@gondor.hengli.com.au>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org
Subject: Re: Default Kconfig state for hw_random drivers
Message-ID: <20120427123626.GH18260@opensource.wolfsonmicro.com>
References: <20120426114229.GG3207@opensource.wolfsonmicro.com>
 <CAOesGMj2eZvWek86D2MKQMPY9qAsC0D2MsYyN-+RPUr5gDFn4A@mail.gmail.com>
 <4F9A91A8.4050608@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0XhtP95kHFp3KGBe"
Content-Disposition: inline
In-Reply-To: <4F9A91A8.4050608@atmel.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0XhtP95kHFp3KGBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 27, 2012 at 02:31:36PM +0200, Nicolas Ferre wrote:

> I had the same kind of discussion with Felipe and Arnd in this thread:
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/122248/focus=122304

> The conclusion came out after Arnd's strong arguments:
> http://article.gmane.org/gmane.linux.ports.arm.kernel/122962

> Maybe adding a "default" directive can be an valid option?

There is one, that's the problem - the driver is defaulting to the same
state as the main hw_random option (as is idiomatic for this subsystem).
This means that if you've enabled any hw_random device this driver will
be enabled by default.  I would argue that this default directive only
makes sense if there's an explicit dependency limiting the platforms it
can build on.  If it can build on any platform then omitting the default
and just defaulting to N as is normal for drivers would be better.

--0XhtP95kHFp3KGBe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmpKoAAoJEBus8iNuMP3dMfIP/R8jgdE84jDZxEwbOJ6jv6lJ
UGzuDCdSx0Wt28mNE9FP5FBPMZYQhlvuhY6eeoQM259dr+TaKk2qwmZskg2xmocl
EqRpj+Sfg2HAErhUz/DVmJtjhXQpvaRH+pEqFcDJBjERHcE64N7Um2iZVYKe2r21
ZuqRsd/E6dh97RqbrwwHBQ8YpVFHTsEYSpa4vEDOjFFNSIGzYZq2jf35SfcAyYBg
4xdRHOHovJT42/WbKkZBhJbzHHouyEoieIiH+rxs8C41Onhuy/tOobU1coHGW5tY
AP/3KZ+Tr3SSC6FA5EQmw8mLKXtlk68P7blmc5cQ7+7oPDlhg3RETZuhuk3YhZRE
j86OZFmZDhqBHeqpB08q8UOFGFDVWmoMWtq4hdsgv6BYAMW8xi2zoSPdz/LOYUe9
hB1bZ8Z8Mb2IuZK0qzMPzQ8hoPa+5aS4rZfUtbEmFQhf1oILqjxrUel66T6AClIP
zTGm6EJ/zLKp2ISw5qnXWV58GgnRKyjMB1wu5IBxPciurpyATF/tAki4GMT8XdWm
9YNKiG2bxsUeEdywWjWfuozNBYtzbvWYMDr+qDHDDpIfu+UUT2eMTsS0BJ2u/Vqo
pWSbVTfl+fg5k+wnWjCPFADO5BBZBM+v3+2Kbf2lPhcv277pnk3Y9l7kcnvbx6DP
a44dFMFeNY1eS+T/R3Zb
=+OAQ
-----END PGP SIGNATURE-----

--0XhtP95kHFp3KGBe--
