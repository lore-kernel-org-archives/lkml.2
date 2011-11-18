Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1KRT0u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 14:26:50 -0500
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50837 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714Ab1KRT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 14:26:49 -0500
Date: Fri, 18 Nov 2011 21:26:45 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Alessandro Rubini <rubini@gnudd.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com, balbi@ti.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH V2 2/2] usb: dwc3: use debugfs_print_regs32()
Message-ID: <20111118192644.GE11736@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111118002049.GA24806@mail.gnudd.com>
 <20111118135143.GA1101@mail.gnudd.com>
 <20111118183109.GA4833@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <20111118183109.GA4833@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18, 2011 at 10:31:09AM -0800, Greg KH wrote:
> On Fri, Nov 18, 2011 at 02:51:43PM +0100, Alessandro Rubini wrote:
> > This a use example of the regs32 utilities in debugfs, although
> > this fuse use ":" as separator between name and value, and debugs
> > uses "=3D" (as it looked to me a more common practice).
> >=20
> > Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> > Cc: Felipe Balbi <balbi@ti.com>
>=20
> Felipe, any objection to me applying this patch?

none whatsoever:

Acked-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxrF0AAoJEIaOsuA1yqREveoP/173WjK/Qr8od3NRVqxqDdej
pkksnj/MLX5Zw6bzsSGBAnXqoWfjkek+uT2krfwkFYY2yF57onCkxM/TF4yDj9yV
Rex5MSq9XFw8TaJgWYxiRdonDHPT1UxPfaPZubJxnt1GxWh3k0LAtmNOF4YxeF++
FR1Bto45SUHdkIOW04VRK56lgzoxggYcZkrUTJUxBZVRKZAWdV58wRyQZPyTtvgV
+tZhHsRaJj/aQ8PNvX1Rw2OMiqhJNMb79g5d+5jFMI4cCzPh6KlpVIAFu9H7InUR
wZ3yOY4h6wB/5/+zqYlgxhVLtUI1Vu851WOL2mWgt/skGT4ZImC8u3VGF1SYwT1U
6tM7mEr32M1jWO6++EAOxfeVcpl9gExkJQpowUR9lDUxuTkWp4SqxRSDXX99KFpy
Sz6MeRt/WBsX8JmIcvodzsr1O9FFGtROZAZhwqNy23lTvl1+gwrYO+VSMtv/ZD0p
bTqCJ/1bcx0J9zeH5qa54pQtSwSFhkIDwL2Nxpe11d011aAmLkUWzQPkrTlIbKSm
r7sshSzSXHuc+hnmXw4Bvgk+3yfcxvIGlx9hhfDLghY0Fiwgae15pOCuYJ+hTcdZ
Ad7ozYkm8qRsOscHDHlTwdwRqqWQy6LCFdnJ8A4U80+78fcGKle9fok2YE4c0L8w
H/EzAfVBJ3aXOWRtById
=Q+QA
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
