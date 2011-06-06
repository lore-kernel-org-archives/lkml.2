Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711Ab1FFLOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:14:36 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:60861 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755015Ab1FFLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:14:33 -0400
Date: Mon, 6 Jun 2011 14:14:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, greg@kroah.com, linux-usb@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, ablay@codeaurora.org,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 7/9] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110606111425.GU18731@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1306847914-19876-1-git-send-email-tlinder@codeaurora.org>
 <1306847914-19876-8-git-send-email-tlinder@codeaurora.org>
 <20110603080333.GS2409@legolas.emea.dhcp.ti.com>
 <003401cc2218$1ae868a0$50b939e0$@org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yRXsXhSYq7voLSEz"
Content-Disposition: inline
In-Reply-To: <003401cc2218$1ae868a0$50b939e0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yRXsXhSYq7voLSEz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 03, 2011 at 09:00:17PM +0300, Tanya Brokhman wrote:
> Hi Felipe,
>=20
> > On Tue, May 31, 2011 at 04:18:27PM +0300, Tatyana Brokhman wrote:
> > > @@ -377,9 +425,10 @@ static int config_desc(struct usb_composite_dev
> > *cdev, unsigned w_value)
> > >  	u8				type =3D w_value >> 8;
> > >  	enum usb_device_speed		speed =3D USB_SPEED_UNKNOWN;
> > >
> > > -	if (gadget_is_dualspeed(gadget)) {
> > > -		int			hs =3D 0;
> > > -
> > > +	if (gadget->speed =3D=3D USB_SPEED_SUPER)
> >=20
> > if (gadget_is_superspeed(gadget)) ??
> I thought so too at first but then I decided that checking gadget->speed =
is
> better here because it's possible that gadget_is_superspeed() will return
> true but the actual speed will be for example HS. In that case we want to
> enter the  else of this if (else if (gadget_is_dualspeed()) {... })

ok, makes sense.

--=20
balbi

--yRXsXhSYq7voLSEz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN7LaRAAoJEAv8Txj19kN1VlEH/RzhPuUOy5rS7K7vex9WaGJe
2SQZG9/vAGS8RCyE1Fd6iRBSxUkzHI6OUyY/Ax7tYdUPdL7ZhsmCzvRXw0Mgu75V
B2A/J0X+K7YF4wm64yjNxfFPcZULpCZG5TmpzNf498jJMu7x6qKwD8TTt1xlQeQM
LYUM2SC264uHkjSfG/DTobfmtd4cTcDoRZE3Ckf0grX7dixcSoxL5xuYJ6fW4XqB
GifvL68XPLY4nhUHuAQU8L+usaOUxlD6MDss34XWJs/BPHfw7dBTHBT3SlJbTWh/
p+6QUhiMlWpfSesWZb1MC43G+ZExBMHJpnB/YPUEpLhCagtjOQJBuoCBvF0U74I=
=ilic
-----END PGP SIGNATURE-----

--yRXsXhSYq7voLSEz--
