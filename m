Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1HWJJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:09:47 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:40877 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754958Ab1HWJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:09:44 -0400
Date: Tue, 23 Aug 2011 12:09:39 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        torvalds@linux-foundation.org, mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
Message-ID: <20110823090938.GD1341@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de>
 <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com>
 <4E4D4A5F.202@linutronix.de>
 <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
 <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ycz6tD7Th1CMF4v7"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ycz6tD7Th1CMF4v7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Aug 22, 2011 at 05:45:06PM -0600, Paul Walmsley wrote:
> On Fri, 19 Aug 2011, Felipe Balbi wrote:
>=20
> > On Thu, Aug 18, 2011 at 07:22:39PM +0200, Sebastian Andrzej Siewior wro=
te:
> > > Pantelis Antoniou wrote:
> > >=20
> > > >Let me report that with this change Beagle board fails to boot,
> > > >hangs right on rootfs mount.
> > >=20
> > > Can you provide some more information about the kind of the failure a=
nd
> > > used drivers?
> > >=20
> > > >Users of BB should revert this until the offending driver(s) are fix=
ed.
> > > Which is the offending driver?
> >=20
> > I would guess it's the lack of threaded IRQ conversion on the
> > twl4030 driver. I have converted it but noone actually picked the series
> > [1].
> >=20
> > http://marc.info/?i=3D1309427470-605-1-git-send-email-balbi@ti.com
>=20
> Just a data point: applying this series doesn't seem to fix the hang.

a wild guess which wasn't right :-p

--=20
balbi

--Ycz6tD7Th1CMF4v7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU25SAAoJEAv8Txj19kN1gtgIAKs0tTCodGG6DDRBgVVw6HS3
fsJnQsmkzFcCgv5Af1n9ukXrH5h4fvTnFbb0fle9JRPE+iSU7hTWJ+QPI0qqqviI
xykSD8XZPaRMpVY0eiK1jcCaMnSEbATZQt3JQo51dG4t9TOj5fxMN3seyJvqDZAA
nRPso3gRXCQxLL1jP2WxRdyDaLw0yzJpO7eVV20aaKUow3tx1lLW4TR7wxgDWm4P
SmlmXI3Rb89PpLGRUFR3KzRklHYFEKpECWmds7A+b/7vI23Z2AFNHkW4tWLgaFkZ
QTMDXfpPO8uSEoP9S/rnokzJx3THjOwq+5BBvcpUW58DJ2RIZ5gW3D6erLDELrk=
=Rd3R
-----END PGP SIGNATURE-----

--Ycz6tD7Th1CMF4v7--
