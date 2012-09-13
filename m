Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2IMHDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 03:03:43 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49192 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751157Ab2IMHDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 03:03:35 -0400
Message-ID: <1347519807.7471.45.camel@lappyti>
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
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
Date: Thu, 13 Sep 2012 10:03:27 +0300
In-Reply-To: <20120913070012.GC6180@pengutronix.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
	 <1464760.6eqxJ2IzZ2@percival> <1347517377.7471.23.camel@lappyti>
	 <2689722.93BQTh4lSC@percival> <1347519249.7471.42.camel@lappyti>
	 <20120913070012.GC6180@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HGYq0tzyMtgGlYGPESbW"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HGYq0tzyMtgGlYGPESbW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > =20
> > > > However, I fear these board specific things may be quite a bit anyt=
hing,
> > > > so it may well be pwm, gpios and regulators are not enough for them=
. For
> > > > example, there could be an FPGA on the board which requires some
> > > > configuration to accomplish the task at hand. It could be rather
> > > > difficult to handle it with a generic power sequence.
> > >=20
> > > Right. Note that this framework is supposed to be extended - I would =
like to=20
> > > at least add regulator voltage setting, and maybe even support for cl=
ocks and=20
> > > pinmux (but that might be out of place).
> >=20
> > Yes, that's one concern of mine... I already can imagine someone
> > suggesting adding conditionals to the power sequence data. Perhaps also
> > direct memory read/writes so you can twiddle registers directly. And so
> > on. Where's the limit what it should contain? Can we soon write full
> > drivers with the DT data? =3D)
>=20
> I have this concern aswell, that's why I'm sceptical about this patch
> set. But what are the alternatives? Adding power code to the drivers and
> thus adding board specific code to them is backwards.

As was pointed out in earlier posts in this thread, these are almost
always device specific, not board specific.

Do you have examples of board specific power sequences or such?

 Tomi


--=-HGYq0tzyMtgGlYGPESbW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQUYU/AAoJEPo9qoy8lh711ZMP/3JNh0JDh9aq72eFbQy8glAx
8drMjd/6Jd+hscvylkikwaxoUrU1J+i1VwC/hXJOEEh6x+3FocG+QwJRuhryjDTl
20oZrjgYIuX6ee++RCA7hLXg+ubIrcQEvT2jDESY/VPaCy/xYCFrdAkA07gexWoY
/L3au+u55sXbau6E20VWkZZkw0vwBpA+n1WRPhv705Sj8gxkn71kpxj7i7B3rS63
bdEprYEj/ac3Uz12skBjaPVXMc280/ELiBqZYhcaTLq60Bwr0GuQ9neIiBUxR2Af
1eDUi/5vnm0euHfndC2w69Gh/gxXwVVQTiCpCb1Zg7xXftGXrx37ejS4srBoAiV9
Z7jwxEuXINx/zOUTI348ZY996k9hZ5nZ4jZGOuotOR1Ek5mSXz+Chpq7Ht+Wnnty
YSkCV/R2EypYVNE4oU4k1O0aQFgKa3Fu0KFGCpIpZMBaQ8eq3rq438ySF9NsQaRV
F6fZmx5yEuertbFiP2AepsiExbrErlAvp2gfnHnVvUVmlsu9jQIepUxwNUfBsZIU
O/sxKvCDviAz0WKq811isbpT4vbavs8+6sjvWeXQfznsiYfHVtsFcsidfJMxUDR8
EGCPbzy7Pag8c9+5qmAiJQYz6iig2ClHJZ/XkHUxV+w8Ak43K/9BA+ypOSGZzDPf
Yl0MREZklImPMXkT7ZRx
=s2EQ
-----END PGP SIGNATURE-----

--=-HGYq0tzyMtgGlYGPESbW--

