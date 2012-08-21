Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab2HUI55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:57:57 -0400
Received: from na3sys009aog127.obsmtp.com ([74.125.149.107]:58929 "EHLO
	na3sys009aog127.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752597Ab2HUI5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:57:50 -0400
Message-ID: <1345539465.4085.22.camel@deskari>
Subject: Re: [PATCH v4 1/3] Runtime Interpreted Power Sequences
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Alex Courbot <acourbot@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <leelakrishna.a@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Date: Tue, 21 Aug 2012 11:57:45 +0300
In-Reply-To: <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
References: <1345097337-24170-1-git-send-email-acourbot@nvidia.com>
	 <1345097337-24170-2-git-send-email-acourbot@nvidia.com>
	 <1345535069.4085.7.camel@deskari> <1562509.b0FYTUZ1D8@percival>
	 <20120821083329.GA28992@avionic-0098.adnet.avionic-design.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-wBdSPFNbFs73o+cuydTi"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wBdSPFNbFs73o+cuydTi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-08-21 at 10:33 +0200, Thierry Reding wrote:

> I suppose power sequences aren't needed if you have a specific driver
> for every panel out there. However that also means that you'd have to
> write drivers for literally every panel that requires support. In the
> end this will just result in discussion down the road how the common
> functionality can be refactored and we may end up with power sequences
> again.
>=20
> Also as you mentioned, power sequences are useful for a number of other
> use-cases. Without power sequences you'll have to potentially create
> extra frameworks tha reimplement parts of the power sequence code for
> their specific hardware needs.

Right. I think my main concern is the use of DT data, not power
sequences as such. I've been going back and forth in my mind with this
issue with OMAP also.

The question is: what stuff belongs to DT data and what belongs to the
kernel? I've been trying to go to the direction where DT is used to
describe the HW connections of different IP blocks and to pass board
specific configuration. Everything else is in the driver.

This doesn't mean that we'd have a separate driver for each device. For
example, we have a generic panel driver in OMAP, which contains a kind
of small panel database. The panel database contains the name of the
panel as a key, and panel specific configuration as a value. This
configuration could also contain some kind of generic power sequence.

I'd like to require the board developer to only fill in to the DT data
what panel he is using, and how it's connected on his board. Not panel's
internal functionality.

The one benefit I see with DT based approach is that if we have, say,
10000 panels, we'd have quite a big database in kernel memory and a
board may only need one or two of those. But perhaps that could be
helped with the use of __initdata.

 Tomi


--=-wBdSPFNbFs73o+cuydTi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQM02JAAoJEPo9qoy8lh71WtAQAKX+bcZY0vx9b7uxiJQn2K0B
QlwpAOLa88qGLWoMYo1ExCWDL19LyTQT4qEHCnJ9a1wr1y0RreHKeyv7PhyozHoj
XK5Fo29VCLbOp4NtHSih/rHDcvtTvcEgq/TyoEOQwiE0E23kAmnFVMHwVe9zActb
Q46Zalag4dO9MjND/ncOJ0RiYvnB8plUvq+D0IgDLNOLp52U9MqJ6p5vt73sRgxK
TS81AhD3C5POK4U+JT2ASmabV+WCKsFEEJ1n/rv23oAZVfxNgKED5PWMqwT8lVfH
pPZ4oW/GF50kGkjF5dLGBJ+jbGeYRv+mnuY2MG4pCC7N9VBFaMBI2wq1/d9q0idR
g3NUYF4oU6Mb3jfBb4V8RRxH36k6ucn3ttA/+p+HSizvxXWbB0MKcAH0Q0XvVauJ
PIZ8d2pIFOSmiCcK/aKNGFiuAMCUIjI0ZFMtEetL5wEcx3iy/y3roZ55q7wUDC12
JEcAlm8vkVzpvfI9I/ZuMqfewOLzR5RwkpBjHCAgYJNdFobFNPgUvrIsNN8J/gBl
EXu2Cm7OgfVGMMLUuzpZRrhTPaAwIuMZfe98cSoQgGxG4MJfTfMzgzgLVLYZuyOm
jusEZJiamTMx/kYQgJOTuVYj9BpzwULJy6lrD21bq9N3It1rp/NJDTuBdpW5cFCH
sVo/Xc34OYbrh8V6h4pa
=boI3
-----END PGP SIGNATURE-----

--=-wBdSPFNbFs73o+cuydTi--

