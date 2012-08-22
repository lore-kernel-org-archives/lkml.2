Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab2HVPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 11:48:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41986 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab2HVPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 11:48:15 -0400
Date: Wed, 22 Aug 2012 16:48:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120822154812.GK7995@opensource.wolfsonmicro.com>
References: <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
 <20120821105413.GD26899@gmail.com>
 <20120821110329.GA7995@opensource.wolfsonmicro.com>
 <20120821120243.GF26899@gmail.com>
 <20120821165207.GX7995@opensource.wolfsonmicro.com>
 <20120822081746.GA4089@gmail.com>
 <20120822111913.GG7995@opensource.wolfsonmicro.com>
 <20120822115524.GA18545@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IdGNrZu1oYcejyEu"
Content-Disposition: inline
In-Reply-To: <20120822115524.GA18545@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IdGNrZu1oYcejyEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 22, 2012 at 12:55:25PM +0100, Lee Jones wrote:

> > I *have* asked you to communicate more clearly about what you're doing
> > but that doesn't mean to stop sending code, it means to have clearer
> > words around what you're sending.=20

> That's not how I interpreted your words:

> "What you can do here is to commmunicate about what you're doing more.
> Don't just think about the code, think about the communication
> surrounding the code - this is the core of the issue."

Just to be clear I'd include things like commit messages, cover letters
and so on in the general area of communication.

> I think it's great that you like the idea and want to extend that
> functionality to other MFDs which perhaps don't support DT, or the
> ones that do but don't want to provide compatible strings or device
> nodes for all the MFD's child devices. But that is all we're doing
> here. There was no breakage. It served a purpose and it worked well.
> So well in fact that you've now provided the intended functionality
> to other devices.

I'm looking at this from the point of view of adding the compatible
strings and then finding that the core starts remapping things in the
case where you're probing from DT - and this behaviour will vary
depending on the device tree that the user is using so the driver can't
even make a decision based on if device tree is being used by the
system.

> You only noticed it 2 days ago and I had a patch ready to go yesterday.
> I'm confused because I don't understand why would you even complain about
> it if you intended to work on it yourself? Surely, "Ah, I see an issue wi=
th
> xyz, patch to follow." Would have been more appropriate, instead of=20
> complaining about it, then I go and waste my time trying to fix something
> you intend on fixing yourself.

I didn't originally intend to do anything, if I had done I'd just have
sent a patch as you say.  Originally I'd just noticed it as being an
awkwardly designed interface at the wrong abstraction layer, it was only
later on that I realised how it could blow up.

--IdGNrZu1oYcejyEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQNP81AAoJEFJkBDiqVpZ43FgP/0h+Ke0tOqodTDXZ+VXBM0yB
Abfa6sTbjCfGL3DGhf4TvngPoUy/3Hsj4AA8SOV66oFZ+0mw6GcfMYv7dg0ixiZh
a7RSInapNy4voYOHeRsF2lT3Uw7ZHHiT8K4Mq3ZmKQ0GPltfLF/g73lR49/7TdLC
Rx8MhNvm4uViPLzz7txQwG77tqVyINY8foJkm3nlFSyef4iyqG2OtuxfurQcEmSv
GgA8Y2tvWeCmnWnf7vBDZ+TYgkER1xV/1XrC1Z2pTzVMBMHt8deFY048SegjfHtW
oeYUxTPDkLKqQ1lfVDcvUHurK3jrQIeo+hN2c8qypCc41WoJEwS3Xte/hFR4nkk/
PiY0CHs3f2+u64inWlEthEc+fPIA68XvxlYkxdXsviixV6taTIjUs5p+ZW+YDAIZ
W6ZbMIrN0Vjuh3Z07zBx8hX2HQstLjl+msPvSEnjAEuf2dLjkJ2yA9lzV0aOd9yu
1w/woHiSx1dVaXkYJyDBIZEsHhRT6JVRYBNq5+H2GpwuzI1Ajf60QuJF26bGvoMN
/Mt+CzVSb145zY5boMSyBZyO/hrVn+yH69ES2zzwPRh10buOppPE74kxI5gkhrBn
zjBK7vnJw03Rdmx5OlDgH70c5NSZD9RoouzgduvKBy4H/AB9KOBHUh74hapBLSz7
2FcYoaJdwSMN3WMx7v1X
=eNsF
-----END PGP SIGNATURE-----

--IdGNrZu1oYcejyEu--
