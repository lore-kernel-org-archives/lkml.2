Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885Ab2JYOZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:25:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40762 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759115Ab2JYOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:25:35 -0400
Date: Thu, 25 Oct 2012 17:19:44 +0300
From: Felipe Balbi <balbi@ti.com>
To: Benoit Cousson <b-cousson@ti.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <sshtylyov@mvista.com>
Subject: Re: [PATCH v4 2/7] usb: dwc3-omap: use of_platform API to create
 dwc3 core pdev
Message-ID: <20121025141944.GF16564@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350307680-24938-1-git-send-email-kishon@ti.com>
 <1350307680-24938-3-git-send-email-kishon@ti.com>
 <508946FC.7090704@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GLp9dJVi+aaipsRk"
Content-Disposition: inline
In-Reply-To: <508946FC.7090704@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GLp9dJVi+aaipsRk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 25, 2012 at 04:04:44PM +0200, Benoit Cousson wrote:
> On 10/15/2012 03:27 PM, Kishon Vijay Abraham I wrote:
> > Used of_platform_populate() to populate dwc3 core platform_device
> > from device tree data. Since now the allocation of unique device id is
> > handled by of_*, removed the call to dwc3_get_device_id.
>=20
> Just for my understanding: How are these devices organized exactly?
>=20
> Do we have : omap_wrapper -> dwc3-omap -> dwc3-core ?

omap_wrapper =3D=3D dwc3-omap, so it becomes:

dwc3-omap -> dwc3-core

--=20
balbi

--GLp9dJVi+aaipsRk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiUqAAAoJEIaOsuA1yqRE/kcP/07hQMsC45EW6YHymHu5x4cD
wmUq5XivfkYzu9vM2TsnNBEjn8AzHqXQgXMorvT6XEDQukyE6p9k/maGtTdG/SxH
dKbIpiZLnMUJ1Zzbr0TB6ye2l7y1HJuvnd0/ieojsjOEHfKgNTauxes+4Pi4DWjm
OrIbAY9fUOLVHk3kR0+MAcTTIuZ4tqm3CmInAHHG3h8NBx2Um8rbHr8E4/KK8SqV
pkP+leF1V0HrpMtFGejmuFsBDlax/4xWEcbiShScwBbuplaMw7JFSFBLmwxbNv/e
rOWmOVSu7LQRwvLIfPV4gbvveDY3OLZL5XXjyKJ+LkzYPcw092y9DKaDD4CDSWLN
Az+t3Y7yW2/wq0uw22ELAbEZXRGTt3+TDi3TH/xECIKH3uzBNhpzg76SDMt1RFrp
ctdBGiYp0fa62ti+oWtW93psYBR9a6P/hcoRG5kD3dc6X2nSo/JDY+upV2fFblPu
cGO626GH6ApR9qi0KkbSKqx+N4L7CHjyw/SrExBcBnwLsUt35Ae2OnkWZmP64JhJ
mEitOAdOBJGluGWv9WDoSwCaC7ujYiGSZZedgrrZrCbLKKaD0H7ueLpbJfQg3g3q
/VSkDrhcnnkf3Rzc+wf6bf5GRggowaRIRlH3jp1D8jZ4u6IR7yep0X0gJVNwumpl
yOQ3t7pJy+0qH6E0IrSO
=EIey
-----END PGP SIGNATURE-----

--GLp9dJVi+aaipsRk--
