Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab2B1TjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:39:15 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:56128 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757287Ab2B1TjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:39:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of balbi@ti.com designates 10.112.84.68 as permitted sender) smtp.mail=balbi@ti.com
Date: Tue, 28 Feb 2012 21:39:07 +0200
From: Felipe Balbi <balbi@ti.com>
To: Joe Perches <joe@perches.com>
Cc: Felipe Balbi <balbi@ti.com>, Jiri Kosina <trivial@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH trivial next 9/9] gadget: Use vsprintf extention %pf with
 builtin_return_address
Message-ID: <20120228193906.GA891@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1330454853.git.joe@perches.com>
 <1bc7879deffd667985a3bcfce70e19418c704143.1330454853.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1bc7879deffd667985a3bcfce70e19418c704143.1330454853.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 28, 2012 at 10:49:38AM -0800, Joe Perches wrote:
> Emit the function name not the address when possible.
>=20
> builtin_return_address() gives an address.  When building
> a kernel with CONFIG_KALLSYMS, emit the actual function
> name not the address.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/usb/gadget/u_serial.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
> index 6597a68..a553bee 100644
> --- a/drivers/usb/gadget/u_serial.c
> +++ b/drivers/usb/gadget/u_serial.c
> @@ -920,7 +920,7 @@ static int gs_put_char(struct tty_struct *tty, unsign=
ed char ch)
>  	unsigned long	flags;
>  	int		status;
> =20
> -	pr_vdebug("gs_put_char: (%d,%p) char=3D0x%x, called from %p\n",
> +	pr_vdebug("gs_put_char: (%d,%p) char=3D0x%x, called from %pf\n",
>  		port->port_num, tty, ch, __builtin_return_address(0));
> =20
>  	spin_lock_irqsave(&port->port_lock, flags);
> --=20
> 1.7.8.111.gad25c.dirty
>=20

--=20
balbi

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTS1aAAoJEIaOsuA1yqREewcP/1dkFwSJCrgL+snifZ+OzVeG
+WGuIPpJzexBvuLj7+C6y7+YM8xepf7WI+90/zOXQJn9LNkRN68uMz2N7KG57Lhf
mGZTYnId3kdk5WIuDD5iewn7G/hAtU1KgS6z6orqJvR/My7aLNqewjmkzbpnITbg
J9XdSGK7wWFAcyq1bLGnHfFmlOeRwqC11FFNHt4Vj+9N4JZMRwtNCmGfJoiBuVrA
vZb8+x8tBi4lpD+nr3gooGMpTezepPenjWemNxDP894D+zcfJDtkfld5Te2xy//0
xPjDffVFPSutSkrYzM710Uma0UxD92Jh9csWKKUzPEIGzruEUYbJDbdowBMvcMtJ
uG/oLgAy3CJdJKT3cdE+sw5spEy15DQ4PJpHpcgRPfGqfXTUYRPi3p1VdKdpQTjy
6WXOTI33va3srHNzZvkr4yJrSjGLLqC+kEWyVN9OFKUDuzkbnHedX+Y/EIBsqrei
c57j6sPFapwiR9glD1UVFJ/JI35JnAGmUaXml9P5eEElA9G1LXNl17+qOoOC2bnc
8XvspFR4XlZRSQL6uRVw+yoOy5KmL+PGER1owZ5CGnM1N7pc+N3+a79N5/W0p9La
zWdgqFjIFFx0Pv5pvuA8WG8tr7zIDKheQgs2VByO1BFdivZUhJ5We3TJM6IjBkPT
A/q2fYKNqw+PR+IdGxQV
=GT+b
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
