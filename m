Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab2JVKWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:22:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53860 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2JVKWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:22:04 -0400
Date: Mon, 22 Oct 2012 13:16:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driver
Message-ID: <20121022101623.GM14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350643085-27294-1-git-send-email-vbyravarasu@nvidia.com>
 <20121019153555.GC440@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CDCA@BGMAIL02.nvidia.com>
 <20121022100240.GK14033@arwen.pp.htv.fi>
 <D958900912E20642BCBC71664EFECE3E6DDFB0CE1E@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYoqghpzCwoKvQG2"
Content-Disposition: inline
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DDFB0CE1E@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TYoqghpzCwoKvQG2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 22, 2012 at 03:47:02PM +0530, Venu Byravarasu wrote:
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Monday, October 22, 2012 3:33 PM
> > To: Venu Byravarasu
> > Cc: balbi@ti.com; stern@rowland.harvard.edu;
> > gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY driv=
er
> >=20
> > * PGP Signed by an unknown key
> >=20
> > Hi,
> >=20
> > On Mon, Oct 22, 2012 at 02:00:00PM +0530, Venu Byravarasu wrote:
> > > > -----Original Message-----
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Friday, October 19, 2012 9:06 PM
> > > > To: Venu Byravarasu
> > > > Cc: stern@rowland.harvard.edu; gregkh@linuxfoundation.org;
> > > > balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.o=
rg
> > > > Subject: Re: [PATCH v3 resend] USB: PHY: Re-organize Tegra USB PHY
> > driver
> > > >
> > > > > Old Signed by an unknown key
> > > >
> > > > Hi,
> > > >
> > > > On Fri, Oct 19, 2012 at 04:08:05PM +0530, Venu Byravarasu wrote:
> > > > > NVIDIA produces several Tegra SoCs viz Tegra20, Tegra30 etc.
> > > >
> > > > I was reading this "driver" more closely and I have a bunch of ques=
tions
> > > > about it, but the most important of all of them is: "why isn't that=
 a
> > > > real PHY driver ?". It doesn't have a probe() function, it doesn't =
use
> > > > struct usb_phy to represent the PHY, it has a bunch of tegra-specif=
ic
> > > > APIs and we can't let those continue.
> > > >
> > > > Please, take a look at drivers/usb/phy/omap_usb2.c (misnamed actual=
ly,
> > > > should be phy-omap-usb2.c so we have a common prefix) to see how
> > your
> > > > PHY driver should look like and which sort of functionality if shou=
ld
> > > > expose to the rest of the kernel.
> > >
> > > Hi Felipe,
> > >
> > > I'll go through omap phy driver and prepare similar patches for tegra
> > > phy driver and push them with upcoming patches.
> > > As current patch is mostly re-organizing the existing phy driver, can
> > > you plz merge This as is?
> >=20
> > I would have to convince me about the need for that (and I'm open to be
> > convinced ;-), because if a later series of patches will come getting
> > rid of the current driver and turning it into a real PHY driver, I don't
> > see the benefit of taking $SUBJECT.
> >=20
>=20
> Hi Felipe,
>=20
> The current patch splits out the existing tegra USB phy driver into two p=
arts, as
> you would have already noticed from the code.
> The probe and etc changes that you asked to add, will be applicable to co=
mmon
> Phy driver and should not have any implications on SOC dependent phy driv=
er.

what is this SOC dependent PHY driver ? What sort of dependencies are
there ? Those differences should be handled with runtime checks.

--=20
balbi

--TYoqghpzCwoKvQG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhRz3AAoJEIaOsuA1yqREvcQP/jNDV3onHmHkdbxbTwwgV/Fv
YRwrB9F8coCTf8Yztd7mQwp+yP+IkwZugWo8QbtN8p2LBXwy2Q2+FE3juoBasxfV
iHaAKKqGdYGodaX7WdAmxqCKK43iLFunpor7cTCJXovC2hd4qdMAAiE490U/5vjb
mW/oVzRpAXc3Nu93KR857uh0b/j5CTDdd+rn79dZlMoXWUHc6nrqldUyJ8dk8qpL
rXyRYE2QDVCAF9kAWg19ZRs49kWme6m05oq7HhwLgJK8MkNlkAeUEVYGSC4Il4DI
qX1f9YYJ/bwqtqSAyGNdpbiKSOS254TmdaA20oGqGa4lnB2eGmiUU7eUukVdk1cu
EL+2LDLcGfaY5yItyywFw2XbqgEe//Xp/+rUV/ivmVPFKRFUT2GK5/a2SlsDIEvV
ubg4mil1nS3xuzD/h7DJjs5lXR632X8I0eBh40R4G1dUQyzq2QbmL2D+sWrgAKwO
UTWUT0lah+9yw8uoniF0N5KqmRKRjqzlZetQq36tNbyBJGD776I3Sxx3AMSLhDyK
lcbASl5bNqQ6hoG4uSZfb0zm8MO0xQm1Er8ZHCuski6bT6UdBTij+3mSNuX3uI7o
WemFvNCYuEN0BneU5UgYdcYL0nomTPqR/ZYIbbj7UhvUEcWC/qa9hfxRWuQjoPus
sVMI0OBxbuacIpK6fVIf
=TmJQ
-----END PGP SIGNATURE-----

--TYoqghpzCwoKvQG2--
