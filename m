Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab2IMI1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:27:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53911 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860Ab2IMI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:27:22 -0400
Date: Thu, 13 Sep 2012 10:26:59 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@nvidia.com>, Simon Glass <sjg@chromium.org>,
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
Subject: Re: [PATCH v6 1/4] Runtime Interpreted Power Sequences
Message-ID: <20120913082659.GA12259@avionic-0098.mockup.avionic-design.de>
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com>
 <20120913072920.GA11459@avionic-0098.mockup.avionic-design.de>
 <20120913075037.GG6180@pengutronix.de>
 <1469388.zjfDz88nxK@percival>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1469388.zjfDz88nxK@percival>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:3Qs1OUueeIItnbWLk9bemFHK09LTFXGX4yq45/Pomf8
 Tk7/RejoHSxL0PdigaURgH/HVO2he2cEuELBmjSMeV7LRmvJHJ
 XGc6MmGaNto0CFnNJdDl+NFYOCCgfANKMujIeS4vYspQCUIB7T
 YIiwQKNRUqn/rdPiSjlRWlcKv7rUQDak10O8ZZF8EtF/MegX4U
 QS9JmrmZmTXhe8gpQaoiDn+R41HSmlW+OYnZmSTutfTkTu/sTX
 uBvm7Ekv0f8o/LQvI8dFE9Xycc0/swGr/Qz5z9OsYalu2eVXGw
 oMLofNNQedHMsVxNFpeX6hx4R2lPf7ycNv4pBp6GfD2m3Gau1W
 xndurbfqg9m10ukU/k1VKuh/01pfoaiUctY9t9i7intJ8I7TXS
 cnvvMbV0htfdI0dd6VoL8yFOcC/1uxNv4VRPbIWEemED80ihmv
 d6hvH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 13, 2012 at 05:21:10PM +0900, Alex Courbot wrote:
> On Thursday 13 September 2012 15:50:37 Sascha Hauer wrote:
> > On Thu, Sep 13, 2012 at 09:29:20AM +0200, Thierry Reding wrote:
> > > On Thu, Sep 13, 2012 at 10:03:27AM +0300, Tomi Valkeinen wrote:
> > > > On Thu, 2012-09-13 at 09:00 +0200, Sascha Hauer wrote:
> > > > > On Thu, Sep 13, 2012 at 09:54:09AM +0300, Tomi Valkeinen wrote:
> > > > > > On Thu, 2012-09-13 at 15:36 +0900, Alex Courbot wrote:
> > > > > > > On Thursday 13 September 2012 14:22:57 Tomi Valkeinen wrote:
> > > > > > > > However, I fear these board specific things may be quite a =
bit
> > > > > > > > anything,
> > > > > > > > so it may well be pwm, gpios and regulators are not enough =
for
> > > > > > > > them. For
> > > > > > > > example, there could be an FPGA on the board which requires=
 some
> > > > > > > > configuration to accomplish the task at hand. It could be r=
ather
> > > > > > > > difficult to handle it with a generic power sequence.
> > > > > > >=20
> > > > > > > Right. Note that this framework is supposed to be extended - I
> > > > > > > would like to at least add regulator voltage setting, and may=
be
> > > > > > > even support for clocks and pinmux (but that might be out of
> > > > > > > place).
> > > > > >=20
> > > > > > Yes, that's one concern of mine... I already can imagine someone
> > > > > > suggesting adding conditionals to the power sequence data. Perh=
aps
> > > > > > also
> > > > > > direct memory read/writes so you can twiddle registers directly=
=2E And
> > > > > > so
> > > > > > on. Where's the limit what it should contain? Can we soon write=
 full
> > > > > > drivers with the DT data? =3D)
> > > > >=20
> > > > > I have this concern aswell, that's why I'm sceptical about this p=
atch
> > > > > set. But what are the alternatives? Adding power code to the driv=
ers
> > > > > and
> > > > > thus adding board specific code to them is backwards.
> > > >=20
> > > > As was pointed out in earlier posts in this thread, these are almost
> > > > always device specific, not board specific.
> > > >=20
> > > > Do you have examples of board specific power sequences or such?
> > >=20
> > > It is true that most (perhaps all) power sequences can be associated
> > > with a specific device, but if we go and implement drivers for these
> > > kinds of devices we will probably end up with loads of variations of
> > > the same scheme.
> > >=20
> > > Lets take display panels as an example. One of the devices that we bu=
ild
> > > has gone through two generations so far and both are slightly differe=
nt
> > > in how they control the panel backlight: one has an external backlight
> > > controller, the other has the display controller built into the panel.
> > > However, from the board's perspective the control of the backlight
> > > doesn't change, because both devices get the same inputs (an enable p=
in
> > > and a PWM) that map to the same pins on the SoC.
> > >=20
> > > This may not be a very good example because the timing isn't relevant,
> > > but the basic point is still valid: if we provide a driver for both
> > > panel devices, the code will be exactly the same. So we end up having=
 to
> > > refactor to avoid code duplication and use the same driver for a numb=
er
> > > of backlight/panel combinations. Which in itself isn't very bad, but =
it
> > > also means that we'll probably get to see a large number of "generic"
> > > drivers which aren't very generic after all.
> > >=20
> > > Another problem, which also applies to the case of power-sequences, is
> > > that often the panel and backlight are not the same device.
> >=20
> > Maybe that is the problem that needs to be addressed? They *are* not the
> > same device, still they are handled in a single platform callback (or
> > now power sequence). Maybe the amount of combinations dastrically go
> > down if we really make them two devices.
> >=20
> > Most of our panels have:
> >=20
> > - A regulator (or gpio) for turning them on
> >=20
> > And the backlights have:
> >=20
> > - A regulator (or gpio) for turning them on
> > - A PWM for controlling brightness.
> >=20
> > The power sequence for the above is clear: Turn on the panel the panel,
> > wait until it stabilized and afterwards turn on the backlight.
>=20
> Actually the sequence I submitted in this patchset only takes care of the=
=20
> backlight device (the panel - or LCD - should have its own). The regulato=
r=20
> controls the power supply, the PWM the intensity, and on top of that it a=
lso=20
> has an enable GPIO. These 3 resources are exclusively for the LED - the L=
CD=20
> uses other ones. So as of now it seems that the LCD/backlight separation =
is=20
> effective and the resources needed are not so uniform across backlights (=
not=20
> even mentioning the delays).
>=20
> The LCD's power sequence is even weirder - VDD must take at least 0.5ms f=
or=20
> going from 10% to 90% of its power, you must wait 400ms after switching i=
t off=20
> before switching it on again, and you should also transmit data for 200ms=
=20
> before switching the backlight's LED on (using its own sequence). That la=
st=20
> point is interesting since it somehow makes the LCD and LED dependent on =
each=20
> other - on an unrelated note, this might be something to consider in Laur=
ent's=20
> proposal for a panel framework.

Maybe this could be solved by adding a backlight resource type and
embedding a reference to the backlight within the panel's power
sequence?

Thierry

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQUZjTAAoJEN0jrNd/PrOhaPwP/3vwgxWBsiYvt35YCVALDUV2
ows5mlrhF24tYZOnD1sH8uDinGd8nDmZkXo8tY0od6GGsJM76cSaZqgx9k6pp3Qu
Ez5q4/LrFMz1brc8Ayi+t968+Nm4hzLvFHWQQA2tQ3iIaQ1mB+YW0q2RZn1LvJej
iOgb+68h9sUiHK+qMFj1Bu2DKCo29LyUviH3x2Q0wJ2S3zYzBL0e71PO0C8baWNC
/F2fpGyN9hDeCYP4Wzc1F25t7iMRp/bL75/4nUS5kWjlHyNUdLZfiTuPSjD5QSjJ
tPnlF+0zuACjvS4T+gDPxQ11WjrL7YBbWg/1qbaQbfXjUWuZJFs7ZhHN2w/QMN71
n6I72yGGXiQQQKPh/a5L8Redm2Uk6YWWqOCqOYt8B0soibYhFyEarWvVAN7h9N8v
qmKOvRyiV+2gH0AVrT+uJdFnTlwfD6PMS9/mLFHRtPFJwBdYSl0PPCTBLSbIUOax
SADZM5jTROMJx2ORDZ4HVHmLjncRPC2XLkgw/XUAlFWA0vjMNLATDP2w09Ur9HI0
i7uHqSJIg3IaY8YUfZ8ws89xzeYfEdQg1Q9qN5zOlZ//vAgBcj/vGiw5kbaXX3R8
qhioZzfbWamZzhQSYy3f/hSdoocwum7kgJQKcX8QlnEkoTRopGuKqA4w2cwBQoQe
HXjUs74sYwbOIlhOpeBC
=gwJh
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
