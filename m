Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2IFNUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:20:51 -0400
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:42731 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751436Ab2IFNUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:20:48 -0400
Date: Thu, 6 Sep 2012 16:16:24 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, b-cousson@ti.com, rnayak@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v7 1/7] drivers: usb: phy: add a new driver for omap usb2
 phy
Message-ID: <20120906131623.GI29202@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344258480-4304-1-git-send-email-kishon@ti.com>
 <1344258480-4304-2-git-send-email-kishon@ti.com>
 <CAAe_U6KBNZpT03xATmPTNTgxm5hj+wJdsShdnm08EmF4Q=hTCw@mail.gmail.com>
 <201209061303.02454.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Content-Disposition: inline
In-Reply-To: <201209061303.02454.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 06, 2012 at 01:03:02PM +0000, Arnd Bergmann wrote:
> On Thursday 06 September 2012, ABRAHAM, KISHON VIJAY wrote:
> > > diff --git a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt b=
/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > > index d2fe064..bb0c7f4 100644
> > > --- a/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > > +++ b/Documentation/devicetree/bindings/bus/omap-ocp2scp.txt
> > > @@ -8,3 +8,6 @@ properties:
> > >
> > >  Sub-nodes:
> > >  All the devices connected to ocp2scp are described using sub-node to=
 ocp2scp
> > > +- usb2phy :
> > > +   The binding details of usb2phy can be found in:
> > > +   Documentation/devicetree/bindings/usb/omap-usb.txt
> >=20
> > The above two lines should be added in omap-ocp2scp.txt (this file was
> > added as part of omap: add ocp2scp as a bus driver and is in
> > linux-next). However this file is still not in Felipe's xceiv branch.
> > So I'm not sure how I can get this patch merged in Felipe's tree
> > without conflict.
> >=20
>=20
> There are three possible ways to do that:
>=20
> * Not add that text. Is is actually required? The ocp2scp bus driver=20
> doesn't actually care what is connected to it, does it?
>=20
> * Ask Felipe to merge the drivers/ocp2scp branch from arm-soc into
> his branch, then apply your patch on top. The branch is scheduled
> for merging in 3.7 and is stable, so there is no harm merging it
> into his tree, as long as Olof and I are aware of this.
>=20
> * Split out this change and apply the patch to add this documentation
> change on top of the drivers/ocp2scp branch in the arm-soc tree.
> There is no strict dependency between this change and the others
> you want to merge, so it does not matter which tree it is merged through.

I'd be more comfortable with option 3 or 1, whatever you guys decide is
fine ;-)

--=20
balbi

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQSKImAAoJEIaOsuA1yqRErvoQAIHOaI8o8Vb2SJGsU6htjYAs
VxH/u/Vc8v0uMcmfYEm9zagUhzabUCzTbMF74/wVI1W00rBs3d152vRTHQqPaFkw
ZS8ftJ7GYmI3xKPSOdZjzaCRIH9cvt4R6n+2GaQ/pjZZFJSoLilTgfDPO+x6a2sf
nea8jsprmaxIfe52lV0tRXvpGLH9NBgzQLRskPKZf6YFw2ag89Bc0ajqNJY/zl5v
f0vzNpTXPatb2/I7WcYt2YIqpWqRJLZ/+kwgR9GTUydkeyt7mWB2MrR/Ljvyqd4e
X495xpSkG+ejdxV5YN0arSc9g0yjiIRoBbpbuzfbcSPFj1JKOBUbEWyRHztGsGQs
4PaQ9tgLheLEDAt0ab6u1ftpdo3kF9vc8Oeq3EEr0ihvZexrR5MQLf/yH3EzJTq6
ZU36cLXpDTF+mOKP9DXWvmFQEfN5fpFPO1MxqoCq0pCZzhKGx/6riOwxIBIRFEmV
qmMJlMTkSDKeb366b+1GiNPy/vPU+CBO9nSOMz/LiYeLZgGiIlhnilW2gQPnbd/s
Fd+tC2elKJ8ck5qIgm8kVtZKz4RhDjanupkN8a/cJfSdiwgf7nG/CCOER+3ydDmD
wyVhiTj7hj5opMIuFHXoi5WJbHFhrSXvBbK+Qv9UtXHMk7wamQ1brj4ZCFypmHFf
JUdZcjMRFkASmJPj07XC
=H4Yx
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
