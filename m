Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2HILwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 07:52:44 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:60884 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932147Ab2HILwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 07:52:41 -0400
Date: Thu, 9 Aug 2012 14:49:02 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2] usb: gadget: composite: parse dt values
Message-ID: <20120809114901.GV12174@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343135720-26559-1-git-send-email-aletes.xgr@gmail.com>
 <20120809114242.GA4689@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iytlPraCFSCqrfnM"
Content-Disposition: inline
In-Reply-To: <20120809114242.GA4689@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iytlPraCFSCqrfnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 09, 2012 at 01:42:42PM +0200, Sebastian Andrzej Siewior wrote:
> On Tue, Jul 24, 2012 at 10:15:20AM -0300, Alexandre Pereira da Silva wrot=
e:
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/usb/gadget.txt
> > @@ -0,0 +1,20 @@
> > +Usb Gadget DeviceTree bindings
> > +
> > +These optional properties inside the usb device controller node are us=
ed to
> > +change some of the gadget drivers configuration:
> > +- vendor-id: Usb vendor id
> > +- product-id: Usb product id
> > +- release: Version of this device
> > +- vendor: Textual description of the vendor
> > +- device: Textual description of this device
> > +- serial: Textual representation of the device's serial number
> > +
> > +Binding Example:
> > +	usbd@31020000 {
> > +		vendor-id =3D <0x0525>;
> > +		product-id =3D <0xa4a6>;
> > +		release =3D <1>;
> > +		vendor =3D "Some Corp";
> > +		device =3D "Test Device";
> > +		serial =3D "12345";

on top of everything Sebastian said, I think we should stick to the
field names set forth on the USB specification meaning that instead of
vendor-id we should use idVendor, instead of vendor we should use
iManufacturer, and so on.

--=20
balbi

--iytlPraCFSCqrfnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQI6OsAAoJEIaOsuA1yqREiFMQAJ3Mp6FHOV9tBsDWhdTXTO/s
8Jly2fYs8rH7JBqJNvyCw9mPNuKQUxRxUgW6cRM5XbScG21QMkOvo+y1gxYWjzhI
iWhgoRTODPeyaE1L/c4vUlWoNTWpET6BeS3MRv9vYRVFHSlf6nP8+suF5nlM87sC
TLuzXfXJdUdLC7gwQaczxfsFBAk3rd2MIBtZt4cMDHx7fgqgrbpMXoxTcKlpzH69
9pLk4b/OcdRxassEv5Hwgu4f5wgUoaSNF3HzhM7nT1ruXL2jTAV2h3ydUV540+IJ
nzy8RMvbpUpfCvhPqwvrfvjK5BcAQgTTihPq33XEpJiWIDeAmdJpnhkiyqkxEFcJ
DD709eLhgFbeulWQ0G+k8UhOxHiJlNNcjjB+R6/0xNDrM5ODjsYQx2qg8I6f5m3H
pFORORod9zysVO7DX6DvJVL8WdpRw5jDyCR0GvIpg0Uo/BMZ8JjWXTAaUMF16KWu
4ugn+1ST0/wtUU2u7RaVcupni+XKMIgQXjZQRv6bC/siLv+Gxj4hBWhCNBU5Ers0
v3FkFzBIEsCNNgVdh4DQC/f0XTs2XJQ3Q8iHFLLb/M8iHcD3yH3RsTnlzissIfn+
uvthC20fM4eE/umxpgBf14wrDAM8rn5ZbDH3v3czuC7g2c60ec9NI744m8gCPKYp
mWOyi0hqqqBDFb9LDFwQ
=m9Ux
-----END PGP SIGNATURE-----

--iytlPraCFSCqrfnM--
