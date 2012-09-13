Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab2IMGXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 02:23:08 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:52181 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab2IMGXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 02:23:03 -0400
Message-ID: <1347517377.7471.23.camel@lappyti>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Thu, 13 Sep 2012 09:22:57 +0300
In-Reply-To: <1464760.6eqxJ2IzZ2@percival>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1347443867-18868-2-git-send-email-acourbot@nvidia.com>
	 <1347515139.7471.7.camel@lappyti> <1464760.6eqxJ2IzZ2@percival>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZLX1dizWK3K7XKAr9srU"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZLX1dizWK3K7XKAr9srU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 15:08 +0900, Alex Courbot wrote:
> On Thursday 13 September 2012 13:45:39 Tomi Valkeinen wrote:
> > * PGP Signed by an unknown key
> >=20
> > On Wed, 2012-09-12 at 18:57 +0900, Alexandre Courbot wrote:
> >=20
> > > Some device drivers (panel backlights especially) need to follow prec=
ise
> > > sequences for powering on and off, involving gpios, regulators, PWMs
> > > with a precise powering order and delays to respect between each step=
s.
> > > These sequences are board-specific, and do not belong to a particular
> > > driver - therefore they have been performed by board-specific hook
> > > functions to far.
> >=20
> >=20
> > The sequences are not board-specific, they are device (backlight, etc.)
> > specific. The sequences have been handled in board-specific hook
> > functions so far because there hasn't been proper drivers for the
> > devices.
> >=20
> > If I were to take the same panel (and backlight) you have and install i=
t
> > on my board, I would need the same power sequence.
>=20
> You could also have power sequences that control a set of GPIOs for an=
=20
> external interface (and would then be more board-specific), but you are r=
ight=20

What do you mean with "external interface"?

But it's true that there can always be interesting board specific
hardware designs, and they truly are board specific. In my experience
these are quite rare, though, but perhaps not so rare that we wouldn't
need to care about them.

However, I fear these board specific things may be quite a bit anything,
so it may well be pwm, gpios and regulators are not enough for them. For
example, there could be an FPGA on the board which requires some
configuration to accomplish the task at hand. It could be rather
difficult to handle it with a generic power sequence.

So I guess what I'm saying is that mostly these issues are device
specific, and when they are not, they may be rather complex/strange and
require c code.

 Tomi


--=-ZLX1dizWK3K7XKAr9srU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUXvBAAoJEPo9qoy8lh71soMP/Rib3XaxlW/uQO5zmE/8O0FK
JGxO9Ci+/2DhWR+x/IHSARaEvB1NjaZmrtrTAhwB7UBYgq2ZmExbAV0/6ixDJeJI
GvaCNrmTPoutNujJ3XHZwpT6fMIY3Td14Jxg0q0aTCFH34bPolXAYGVE7AdE25FU
rwruxl4hIJcgnyKnjEQ5Xw9reDiT40eSDf9tRA1X7qLrM9hiJL08ECGWcDZZrnGc
/+XpQDA52IGDieVaE44G0A8iQCxeQgvEjNQ+bfmJyt1oORghMrktDOEe7Aw72owX
zp0PRaIPL8lUKUAIHpGJirEsp+O1iIP+azQpGQePgzMwjSIkaL36ZPw5Nzrybrhb
TpDvBE9axriVm1vqGdQ/lr75YIdkaclqkc87/C9flwdIofRGWH8V+MUnyFYrM/Yo
wlYDRpG0LGkEap8YXReCSBQCtBTDSRqh6Hz/MOz1rImgEYTHyAlytKUOs0SenvoZ
0AaYdPpRXPZFPbSr90VBOC+EcjuLS4MXO7R1OSrSvTONIGFMeJh867YCTpqQIHDh
2/2j4kaOEnLNcc8/QbNOxDGjNL+rekMrrFqWhdu0NZUsOb++V3NOrgxhF/3vOekr
eoVDMPAnMCDPrgG66TD+gENJQw6hTRDHz51VXAVXSk51C1AE9cAno8tjGuTSmNnM
a6tn51n+5MBawclaO/Zx
=7oms
-----END PGP SIGNATURE-----

--=-ZLX1dizWK3K7XKAr9srU--

