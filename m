Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab2HPNAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:00:00 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:39008 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab2HPM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 08:59:59 -0400
Date: Thu, 16 Aug 2012 15:56:08 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com
Subject: Re: [PATCH] usb: hcd: use *resource_size_t* for specifying resource
 data
Message-ID: <20120816125607.GB26408@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1345121659-24873-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1345121659-24873-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 16, 2012 at 06:24:19PM +0530, Kishon Vijay Abraham I wrote:
> Changed the type of rsrc_start and rsrc_len from u64 to resource_size_t
> so that it behaves well with resource API's like *resource_size()* on both
> 32bit and 64bit devices.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

looks correct to me. FWIW:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  include/linux/usb/hcd.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/usb/hcd.h b/include/linux/usb/hcd.h
> index c5fdb14..608050b 100644
> --- a/include/linux/usb/hcd.h
> +++ b/include/linux/usb/hcd.h
> @@ -135,8 +135,8 @@ struct usb_hcd {
> =20
>  	unsigned int		irq;		/* irq allocated */
>  	void __iomem		*regs;		/* device memory/io */
> -	u64			rsrc_start;	/* memory/io resource start */
> -	u64			rsrc_len;	/* memory/io resource length */
> +	resource_size_t		rsrc_start;	/* memory/io resource start */
> +	resource_size_t		rsrc_len;	/* memory/io resource length */
>  	unsigned		power_budget;	/* in mA, 0 =3D no limit */
> =20
>  	/* bandwidth_mutex should be taken before adding or removing
> --=20
> 1.7.9.5
>=20

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQLO3nAAoJEIaOsuA1yqREmdwP/22809D/7zsZ9blk/WDvbBc0
eugsxbTk7FuGrpAqJPdnjoDvxCagWv4H6oNk4dJqagpAmPusPe77TcnctzmxmEOd
610dQNHpAP27GE2JuSm79qFhYKP/VFgc/LCpWnYKSYfyXtjXe8cgmZ7zFQL7HUX1
y5QrOUAfnFPQpdo7Gx/Bs5SDJusslOPFTKt9f+NrUbdR1rHANsVgx8O6uQ8JQ4Bs
3IUTislDjd13fHNTsscZ5E663hXl34ygU8y1/v65g0j6pUCPeWnOLKZdqWLktf/P
C+6TIUTS/k/kXzsIbnDJp3UDRYdxnEym5FLvZXPZjw8NcFM0pabFMT4l4Hizcsqj
s37naltDaSp74bgaoy+++bLXaox6bD92+P211llb4utBpd3ghoGCfKLXF+Gz51Kg
guwvgkGI9yUHMYAaZChJOCYig227Hht1bA1n4v74SEiioUUh4RDs2OdTHxDuZing
JeNYth49CM9xvv+j8gNKPA8LqNQOEPg4dGGwqCfh3yMKdl0TZhnj8RxSgNeX3xsj
mkgc8XhkJZXd7G9di7puQMXColnhbxHS6eE58iUgKcidLy5c3UkVrgKs0MjXBaNO
dseHut54Pk/ezRZHEaH6mAGHXfVHRwB3MGtYKnbbL4T4VLnInZE00JgcP9jzGIiN
EHFpITGTpgjCM0RgV82y
=cHlh
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
