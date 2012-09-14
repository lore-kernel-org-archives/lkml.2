Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab2INNRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:17:30 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:56019 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750957Ab2INNR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:17:27 -0400
Date: Fri, 14 Sep 2012 16:12:49 +0300
From: Felipe Balbi <balbi@ti.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, balbi@ti.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        richard.zhao@freescale.com, B29397@freescale.com,
        alexander.shishkin@linux.intel.com, marex@denx.de
Subject: Re: [RFC PATCH] drivers: phy: add generic PHY framework
Message-ID: <20120914131247.GC21130@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347623899-14485-1-git-send-email-kishon@ti.com>
 <505322E3.4090806@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <505322E3.4090806@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 14, 2012 at 02:28:19PM +0200, Marc Kleine-Budde wrote:
> On 09/14/2012 01:58 PM, Kishon Vijay Abraham I wrote:
> > The PHY framework provides a set of API's for the PHY drivers to
> > create/remove a PHY and the PHY users to obtain a reference to the PHY
> > using or without using phandle. If the PHY users has to obtain a refere=
nce to
> > the PHY without using phandle, the platform specfic intialization code =
(say
> > from board file) should have already called phy_bind with the binding
> > information. The binding information consists of phy's device name, phy
> > user device name and an index. The index is used when the same phy user
> > binds to mulitple phys.
> >=20
> > PHY drivers should create the PHY by passing phy_descriptor that has
> > information about the PHY and ops like init, exit, suspend, resume,
> > poweron, shutdown.
>=20
> Some comments inside.
>=20
> While looking over the code, I was thinking why not abstract the phy
> with a "bus" in the linux kernel. The ethernet phys are on the mdio_bus,
> see /sys/bus/mdio_bus. This saves you hand crafting devices, drivers and
> bindings,

I don't think that's a good idea, actually. You can have USB PHYs which
are memory mapped, or connected through i2c, or connected through any
other bus. If the PHYs layer itself is a bus, it means we will need to
register a device on two different buses, which doesn't sound very
nice IMHO.

--=20
balbi

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQUy1PAAoJEIaOsuA1yqREWwkQAKVV9u/kQ1iP1qccoAG635Gl
WOKdIb7EESml8nJl0x/5doiLd1bOYWK1YbCGBGLugRiPSfYql1I/x/TPjcUZBMk9
vNEcFiwsSJDF6z1s35Y4p3AAdxs//915N+axB62qN5cr4JSvWUozAt4KDiOKAgjp
AE40XNdilRhZF4mk1mHjiVdOf6wimVIiktSDLbTP0O1lcrizGmGcmH98np+w40R6
gpvAvqymkrGxvs1Wj/W1QCOQyC3jtBtLAuetjx/zRSaukxdW/bP8t+lag9ZiPddp
91ozoXwyVhCrw5oMBlzuUV4wRT83cmHFes9t8sm6MboVrCzKG5qf5uST4ij3nUaT
NOnKWVD30wbTR+1xx5+VYjhOxrIVTqoaqmpi+cZ1EwwhobTkWbsqpcOecbHs0UFF
PDYh3h2ppgCWvxIo+Jjloh6DBSo7QXiOXSMF5c8oEwB3Ji5GfLf30Nriyf28rI8A
L++rex/Y9i54tNaL5dScgrri6Y5IWz0K6hRVvhECX+NX8Bh1jeCjdAUlt0QleAsJ
zV9NIgXu7J6cbQguL1gew894Dwk6VJkBERC2tpPxPjEZqVKVZaovGBp5XRcFujtT
jQiXxc3ia0s9kCHUuvDN0TOlqt3VU8A5VNsForQhBDtjHPpExlUzAcBIGMXhkK6D
HX3VyBBhv8a2r/QSp5b0
=7eB5
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
