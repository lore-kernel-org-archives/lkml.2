Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab2JVKIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:08:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54845 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2JVKIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:08:21 -0400
Date: Mon, 22 Oct 2012 13:02:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121022100240.GK14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MXxcbiX/Q4+iy5U7"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MXxcbiX/Q4+iy5U7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 22, 2012 at 02:00:00PM +0530, Venu Byravarasu wrote:
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, October 19, 2012 9:06 PM
> > To: Venu Byravarasu
> > Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> > balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driv=
er
> >=20
> > * PGP Signed by an unknown key
> >=20
> > Hi,
> >=20
> > On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> > > NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> >=20
> > I was reading this "driver" more closely and I have a bunch of questions
> > about it, but the most important of all of them is: "why isn't that a
> > real PHY driver ?". It doesn't have a probe() function, it doesn't use
> > struct usb_phy to represent the PHY, it has a bunch of tegra-specific
> > APIs and we can't let those continue.
> >=20
> > Please, take a look at drivers/usb/phy/omap_usb2.c (misnamed actually,
> > should be phy-omap-usb2.c so we have a common prefix) to see how your
> > PHY driver should look like and which sort of functionality if should
> > expose to the rest of the kernel.
>=20
> Hi Felipe,=20
>=20
> I'll go through omap phy driver and prepare similar patches for tegra
> phy driver and push them with upcoming patches.
> As current patch is mostly re-organizing the existing phy driver, can
> you plz merge This as is?

I would have to convince me about the need for that (and I'm open to be
convinced ;-), because if a later series of patches will come getting
rid of the current driver and turning it into a real PHY driver, I don't
see the benefit of taking $SUBJECT.

--=20
balbi

--MXxcbiX/Q4+iy5U7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhRnAAAoJEIaOsuA1yqREg9YP/j0QjgZyyXXnF8um1oDYthPv
8/7ioFdmdjN4oXKzTTg0JJw63Xic1KxrbBL1huSAcQ6TeQst22s36EvhzjfnnswD
9Wck8IbVRaKBe0mKUfpmIAP3nj6qS9x/UAN9O2ySZmsAmJWQk8Mcr5do+c/0vl9q
RZlwvnVlFggI1vSU5kgJq0e+WGYbgk5wFZwDrbF/QUOjZuHGPyuUa+nLS/dU6I8b
nAMbo8Q4IKWxusz2s84F3wQ5x+z/1kOMReYUezFOxfOkBABxgvaOi9DL3Y4xeYVR
Am8f6YZY2I+IPC2nbnqW1D2a1lb6A5G7aL13uQ8lvNhEZ4wrNoZBzzQVOC1krccA
4tuWLgCBRGJqhKoA5rrwsjIQW/G715PzeUoTFWjEuBH+ULvGmio3XfxeD40/xot/
qAH+Y7ZdOkE5cN26KYwvkSLonfQCdy/K7nFUP2qcT3YW+uo1CwawbGIgOOyJLnTn
X1LWBk25BD/3nzXOKDLyroo8d8u0puugu7s9o5JS+/E3i1c8ilc77lSsQnoFpsUc
ewHu8UwKz88yppEt2R0o1Fsxl7SUO3nZL0gQLFrwYFFrpwBlQEcjkMXgs1qmodBk
2M6DrgdQMRLFYGydlv4dAo/8tajF9vqzbuxYGjTwFOYsFZAPoy6rkU2yctX7afov
jADt11GcRB7WYt7XxQYq
=aYBT
-----END PGP SIGNATURE-----

--MXxcbiX/Q4+iy5U7--
