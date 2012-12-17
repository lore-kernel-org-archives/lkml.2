Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab2LQJEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 04:04:10 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37253 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2LQJEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 04:04:06 -0500
Message-ID: <50CEDFEB.2030600@ti.com>
Date: Mon, 17 Dec 2012 11:03:39 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Evgeniy Polyakov <zbr@ioremap.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL] fbdev changes for 3.8
References: <50CAFDFF.3070802@ti.com> <CA+55aFz9+3mOZcjJ9C-izKkidT9mxeO7xUubJER0OTjcZjE=2A@mail.gmail.com> <20121215222431.GA7153@redhat.com> <20121216174613.GA18490@atomide.com> <20121216203536.GR4989@atomide.com>
In-Reply-To: <20121216203536.GR4989@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4415ECD25A05695994E9C486"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig4415ECD25A05695994E9C486
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-12-16 22:35, Tony Lindgren wrote:

>> Those are all omap internal devices and should be all marked with
>> depends on ARCH_OMAP2PLUS.
>>
>> It's a different story for external devices that may be used on other
>> architectures.
>>
>> I only came up with one reason to compile internal devices for other
>> architectures: In some cases the driver subsystem maintainer may want =
to
>> be able to compile test subsystem wide changes without having to compi=
le
>> for each target separately. But for those cases it's trivial to carry =
a
>> compile test patch that just drops the depends Kconfig entries.
>=20
> And here's a patch to limit the omap drivers above to omap only.

The patch looks good to me.

The reason I removed the OMAP dependency from OMAP DSS was not (only)
because of the compile testing, but also because I thought it was right:
a driver for an IP block shouldn't presume that the IP is used only on
particular SoC.

But perhaps that's a bit too academic approach for an IP that's in real
world only used for OMAP.

 Tomi



--------------enig4415ECD25A05695994E9C486
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQzt/rAAoJEPo9qoy8lh715wEP/iob+vHJ27lTH6dK7ebRG8ZG
KpkZJmcjwL7GTAdpyvaMhT+Fk5eiqHnoa+6BWRscPzkq+ar/RULns5JAtTxKWsic
xXM8A3xsLrOd+ildwwCL5cnQgBMWHxLcpIOh8UKTqzzC4xtdhLE8z1l/buBSryLV
5WcE0+iC2T4TcG6AFafDcJLTE01YrDYRfrlvF2aM2iW8z0iqqSh+0NHaACGfr971
NrWP5Mzr4lbtFo/sZOmgfsyZdCmZbirwCh18CTYqH1f8C32SFPdYVfAAiKVA6ena
PULqsKlCUSbRCWXI3fOL12gxSGmM/V7JGdpNYS/t7OY/nI+17k+c68gEKphQBYzN
U3wBp4jOPRx6RdVGmMB0RF8o7yotZC14v4n+u6C56psCc/ToTwOxsliQfVCVsTAA
m+7ddCCIjk594qfAv0RPd6u4sY77F5i2pZycWShbN6Dzf0Bt9gMA3u3Snj8Hvprq
HhRlH30Ozj/Hp1JewVAW9iBP+DWM2+ZdWeWjh3f5Y+jv/xkovXOJ4SqwC7syCod2
ahoJNVca0JZef+UVPF3CXgDekP5Sz88+mBO9CqYyTA7XpSMjGycUD8IkZVZdNhPW
KvfHBUtJUBY8c7Pv9Vol3f3UvGh5OOeciEjN1KppS/NQIcnMLa2T9yG8zz4EKfb9
l/qM8vUCySg0L9prVq70
=7pYX
-----END PGP SIGNATURE-----

--------------enig4415ECD25A05695994E9C486--
