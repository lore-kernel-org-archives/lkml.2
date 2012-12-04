Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab2LDVh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:37:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:37949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab2LDVh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:37:56 -0500
Date: Tue, 4 Dec 2012 23:29:44 +0200
From: Felipe Balbi <balbi@ti.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Li Wu <willy.woo@gmail.com>, Li Wu <li.wu@st.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Shawn Landden <shawnlandden@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Jianchun <jcbian@pixcir.com.cn>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        <simon.budig@kernelconcepts.de>, <rachna@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <device-drivers-devel@blackfin.uclinux.org>, <victor.phay@st.com>
Subject: Re: [PATCH v2 1/1] Input: STMicroelectronics multi touch capacitive
 touchscreen ftk
Message-ID: <20121204212944.GA32645@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1354620389-1841-1-git-send-email-willy.woo@gmail.com>
 <20121204191042.GD23964@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20121204191042.GD23964@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Dec 04, 2012 at 11:10:42AM -0800, Dmitry Torokhov wrote:
> Hi Li,
>=20
> On Tue, Dec 04, 2012 at 06:26:29AM -0500, Li Wu wrote:
> > +STM FTK TOUCHSCREEN DRIVER
> > +M:      Li Wu <li.wu@st.com>
> > +L:      device-drivers-devel@blackfin.uclinux.org
> > +W:      http://www.st.com
> > +S:      Supported
> > +F:      drivers/input/touchscreen/ftk.c
> > +
> > +
>=20
> You have an extra blank line here.

looks like many of my review comments weren't even taken into account
since you have some of them here ;-)

--=20
balbi

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQvmtIAAoJEIaOsuA1yqREoJ0P/RH+szhP3qU76/mYIv2JXW2A
j7s1PsSrtyHi/VbRgtYK2BxzXlCO3E8Yqk3XysFkqxLOKKnMhfLmAHC+ZIDvekyX
D8zxqCtJIs62J5VPXae+wMJfuS+xE8v88XXLG0j5J7UxpxRusZLqVcL+OjOOvSxF
sergKNcdNRQt4jNeq+8VvRqN0HFX5ZEaSFYrnpuoy7Za6CukyTzsLF5dHteA/wtN
81KdtfsPrtFzicehBWeS4+V5jE8AUR/aj4Oxpz1ScH2p/S82Bh+oyj8ZM9CMrL9F
ijLmNTIbS5BcBbPPwPxCXXGYnIzBtms5dExKwzIOVl9U8aK0/u0afGUw8f1h1UvK
tjK7QbIUhN2yPjsoqPiC0tDbKV44YRt9g/QLHbYuJpvCSa+1ui/AoASnIv1EIh/U
NAEXx8tXlXk7bjIg6VKyKRAeX3rHpGPQqfWLkAj3gq3A6lm9iwZqeG4hm47CjeIJ
mEvQpdAsVtb2oN5gk8B3zZ48thjPNEULZ04UDN7r1c7L39SXh9g6UZfGhx1xXqOU
WZm8dt7SKtq+qb2mKJNXy7iN+z6zV0L+Ewl9msBZdUfBMQJWPNXfyjMga1YkLffx
K5dB6cRuMRSS42HdJhgTMLIdT4TZ+i2+QhqMK4P9TxUBKMSERVJOKoh9ej3CPhdF
sTu/jHQXIIHXtaYU5dUG
=fzrY
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
