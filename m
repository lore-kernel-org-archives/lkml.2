Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab1ERKLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:11:02 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:47030 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754788Ab1ERKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:11:00 -0400
Date: Wed, 18 May 2011 13:10:53 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v10 4/7] usb:gadget: Add SuperSpeed support to the Gadget
 Framework
Message-ID: <20110518101049.GK11981@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305637403-3832-1-git-send-email-tlinder@codeaurora.org>
 <1305637403-3832-5-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJI8q/aziP9idhqk"
Content-Disposition: inline
In-Reply-To: <1305637403-3832-5-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJI8q/aziP9idhqk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, May 17, 2011 at 04:03:18PM +0300, Tatyana Brokhman wrote:
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composit=
e.c
> index 5780f35..5be5f6d 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -352,7 +392,9 @@ static int config_buf(struct usb_configuration *confi=
g,
>  	list_for_each_entry(f, &config->functions, list) {
>  		struct usb_descriptor_header **descriptors;
> =20
> -		if (speed =3D=3D USB_SPEED_HIGH)
> +		if (speed =3D=3D USB_SPEED_SUPER)
> +			descriptors =3D f->ss_descriptors;
> +		else if (speed =3D=3D USB_SPEED_HIGH)
>  			descriptors =3D f->hs_descriptors;

on the previous version of this patch I remember asking to convert these
to switch() instead :-)

same to all others below

--=20
balbi

--vJI8q/aziP9idhqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN05spAAoJEAv8Txj19kN1fQkH/AhBWBv9yM4tjdTHXk01bRD6
b94om6F+k+RCoJc9t/TNrV9M14mHBWczjBrbx8jmmr01D25matVhMI2Tx62UA1ta
JY1/8tlBOIbdg2E/1/3H3blup2MiIkhuItsPGIl9b5FoXOACT8Xjt0RFYJdQy/Nm
vK18C7rOn758ni8IIGlDL/oMkjiECXbmnYrengzt5fQ2njPUdmpoqauqb/rH3qBi
VNKtd2/sy1Bys7i+QmMVpIf5bVShgV8Hvn8u9QcAbapvhnglquApDkB6vB/fjjZA
TgOwtN1tc0cQZfUxAIwDeNOxs2AxprXpAR29RoQBUGZz2xLEN8CuLIT3E1vri0A=
=YGMt
-----END PGP SIGNATURE-----

--vJI8q/aziP9idhqk--
