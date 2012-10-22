Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2JVH64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 03:58:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59712 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab2JVH6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 03:58:55 -0400
Date: Mon, 22 Oct 2012 10:53:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Li Yang-R58472 <r58472@freescale.com>
CC: "balbi@ti.com" <balbi@ti.com>, Simon Haggett <simon.haggett@realvnc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests for a
 disabled USB endpoint on Freescale hardware
Message-ID: <20121022075308.GA14033@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350667166-3559-1-git-send-email-simon.haggett@realvnc.com>
 <20121019173718.GA2738@arwen.pp.htv.fi>
 <94F013E7935FF44C83EBE7784D62AD3F094730DB@039-SN2MPN1-023.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hUH5gZbnpyIv7Mn4"
Content-Disposition: inline
In-Reply-To: <94F013E7935FF44C83EBE7784D62AD3F094730DB@039-SN2MPN1-023.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hUH5gZbnpyIv7Mn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 22, 2012 at 03:33:19AM +0000, Li Yang-R58472 wrote:
>=20
>=20
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Saturday, October 20, 2012 1:37 AM
> > To: Simon Haggett
> > Cc: Li Yang-R58472; Felipe Balbi; Greg Kroah-Hartman; linux-
> > usb@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> > kernel@vger.kernel.org; Laurent Pinchart
> > Subject: Re: [PATCH 1/1] usb: gadget: Don't attempt to dequeue requests
> > for a disabled USB endpoint on Freescale hardware
> >=20
> > Hi,
> >=20
> > On Fri, Oct 19, 2012 at 06:19:26PM +0100, Simon Haggett wrote:
> > > Some gadget drivers may attempt to dequeue requests for an endpoint
> > > that has already been disabled. For example, in the UVC gadget driver,
> > > uvc_function_set_alt() will call usb_ep_disable() when alt setting 0
> > > is selected. When the userspace application subsequently issues the
> > > VIDIOC_STREAMOFF ioctl, uvc_video_enable() invokes usb_ep_dequeue() to
> > ensure that all requests have been cancelled.
> >=20
> > bug is on uvc gadget, then. Laurent ?
> >=20
> > Also, fsl should be removed from the tree, I'm trying to persuade iMX
> > folks to use drivers/usb/chipidea instead.
>=20
> Besides the iMX usage, the driver is also being used by many Freescale
> PowerPC/Coldfire SoCs.  I agree that it's ideal to move to a common
> driver.  But it is a large task to make the chipidea driver works for
> all the hardware that fsl_udc had supported and been tested on.

I understand that, but we just can't keep so many duplicated drivers in
mainline. chipidea udc had at least 3 different implementations. Now
it's the time to combine all of those and stick to a single driver.

Just make a plan to slowly move towards chipidea in the upcoming few
merge windows. I can continue to take in bugfixes for fsl_udc, but only
if I see that you guys are working towards merging with chipidea driver.

--=20
balbi

--hUH5gZbnpyIv7Mn4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQhPtkAAoJEIaOsuA1yqREJjsP/iibVj4fB03dHEu9GRKmuWcz
CB6ZfyFqpdcwQHT4AZ0/Dc8dfuDh3Tl58PPW6jshkyVd1s55vjarW8YTVagD7TQz
3idDHHjPSvXz9ZgDa1u3+dF07kKrehLXEuJNHxwbFLXZiRKGDhHSwr39swRv3CHP
6a63FeOopBuT7anPvWK0jJ4ywaXioKB4OctNTSeplaHg8EPGmjnzO2O4UhBVamSi
1n9znfm0UaXwVsDE1dpVgy2jFTV1NFCs50o8qheW8qiqeb9xPxkJqsoWivJgqwXI
H8Ss7hglR6YVzzeLJE2e2994enNSFSEPmYSBT39vq14sviaRbT5vhsPqeqEvebFC
uLAIuWx4xbPfNZfe9c/GJ5RndOW8K7cQ6h//zrv0bLCOAHhheFs7gHDwF1MdNn1+
NFpKFUs8XNQ6G5YUHHIBd5MdAELysAwsafzqlnYRw3VYNOIdcAHqjxJd7u6daYSF
G923H2IDhdkfltv2zXe4myEjYvVfmL4zYaGCrc9VSA5ZgNfL+ytPCn9tYEt65Ljq
8RjTHEUkEjGv/K+8H88g6ZTi0p+2/6vzlD7CX1Is38T/wfI39EGuADML7l8RrKmY
mhHf9Heysu+clKDs0Q+UH8oy8/igGi8PjWec5fjQm9vP3OSlleMyk+INhlkoPQDc
v1nECQC76RS0om4Nf17B
=khOJ
-----END PGP SIGNATURE-----

--hUH5gZbnpyIv7Mn4--
