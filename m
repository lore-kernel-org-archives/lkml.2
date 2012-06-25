Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab2FYM11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:27:27 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:58396 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429Ab2FYM1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:27:25 -0400
Date: Mon, 25 Jun 2012 15:24:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, linux@arm.linux.org.uk,
        arnd@arndb.de, b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: Re: [RFC PATCH v2 1/2] drivers: misc: omap: add a new driver for
 ocp2scp
Message-ID: <20120625122449.GA30463@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1340370942-23201-1-git-send-email-kishon@ti.com>
 <1340370942-23201-2-git-send-email-kishon@ti.com>
 <20120623044445.GA2993@kroah.com>
 <CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <CAAe_U6+dkiQw-i93pFapt6qKrArzaQoE8X3GjDzUDraziG8B2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 25, 2012 at 11:09:54AM +0530, ABRAHAM, KISHON VIJAY wrote:
> Hi Greg,
>=20
> On Sat, Jun 23, 2012 at 10:14 AM, Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > On Fri, Jun 22, 2012 at 06:45:41PM +0530, Kishon Vijay Abraham I wrote:
> >> Adds a new driver _ocp2scp_.
> >
> > That's not what you called this driver in the patch below :(
> >
> >> This driver takes the responsibility of creating
> >> all the devices that is connected to OCP2SCP. In the case of OMAP4, US=
B2PHY
> >> is connected to ocp2scp.
> >>
> >> This also includes device tree support for ocp2scp driver and
> >> the documentation with device tree binding information is updated.
> >
> > Can't this live where the scp drivers live? =A0Actually, where is that =
at?
> > Do we have scp drivers?
> AFAIK, there isn't any driver for scp. But we have a driver for ocp
> and it is present at arch/arm/mach-omap2/omap_l3_noc.c

I don't think this deserves a directory of its own. Maybe
drivers/platform/arm/omap/ ?? the l3_noc is an OMAP-specific
interconnect and the SCP bus is also an OMAP-specific bus. I don't know
of any other arch/soc who uses the same interconnect IP as OMAP and the
same ocp2scp bridge. That bridge was created by TI for all I know.

Greg, would drivers/platform/arm/omap/ work for you ? We could also move
the interconnect drivers there.

--=20
balbi

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6FiRAAoJEIaOsuA1yqREKH0QAJZb8F1QmXEGSn/MYxyjSLnS
A1/yWAlscmqxKNStp5Ax80z/gSVIxXcztRgzK3R6n9F5Wdvj871jqNALtA/5VHwY
heVM1AT38RLvphGqSp5WcDO2FqaWnlAvMaK709cQZhmHI8HJE1p2+g2Z48cmM5cM
FGgcwOZjgMI+18Cbd3AK3MB0PYDppdQOyMtgDgky8bQ2F8FM+XNmKrQXeEqpeg4S
y0N/jUChV/yE6gcpdndIt3Ih86B7DDCYMQU1cUNjEFJCx8zpf+yn5FPO+dZTIkDm
tjdAZW/8z9/7TMbdaA+R5uGbxREeReL4sInQDGpA4v1yEgT5bxXpTOmcVULKbTRh
2HuRrxEWm6Tb16k0rUXhwsb5t9/pNJahVHTU9ev7mm9KvZJJn/CTAKM65QLokAMR
uEE5XQ1Cbj/3sDi6Vueo6qxk8CpuxIp+kU+YKqGX8AK7HnCv9gF/awBWZFzyyUhU
FYDmCi4xWc0YopNf97aJPo84PzKAE3rhcWhTKVnT4NgJ409hLh0RM5bSK3ScYHO4
EjcW/BfstqOsBDXLNf/yU3lm5XiH/N3BjgR7iYvXZHektC4iy0EMV/5YVh+dl1vs
eLIBsqbM3PVD3mjacKMaKyxONyPewzOVHJusl/fajnEk3HthXMQUD1nN6XTTU68F
3qI4kG6YFrHz4li2q0RE
=6qXn
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
