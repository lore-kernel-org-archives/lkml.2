Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1KHT7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:59:00 -0500
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:45366 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1KHT67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:58:59 -0500
Date: Tue, 8 Nov 2011 21:58:55 +0200
From: Felipe Balbi <balbi@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <balbi@ti.com>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        rmallon@gmail.com, Nikolaus Voss <n.voss@weinmann.de>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        ben-linux@fluff.org, khali@linux-fr.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Message-ID: <20111108195854.GD24399@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <20111108144115.GH20728@legolas.emea.dhcp.ti.com>
 <4EB9477E.8070002@atmel.com>
 <20111108152343.GJ20728@legolas.emea.dhcp.ti.com>
 <20111108182955.GH12913@n2100.arm.linux.org.uk>
 <20111108184447.GB24399@legolas.emea.dhcp.ti.com>
 <20111108185525.GI12913@n2100.arm.linux.org.uk>
 <20111108190200.GC24399@legolas.emea.dhcp.ti.com>
 <20111108193930.GJ12913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DrWhICOqskFTAXiy"
Content-Disposition: inline
In-Reply-To: <20111108193930.GJ12913@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DrWhICOqskFTAXiy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 08, 2011 at 07:39:30PM +0000, Russell King - ARM Linux wrote:
> But, that's something very different from your statement in your previous
> message about my alleged stance on *all* asm/*.h includes in drivers,
> which is FALSE.

http://marc.info/?l=3Dlinux-arm-kernel&m=3D132077795410718&w=3D2

I don't see me complaining about *all* headers anywhere in that message.
I did generalize, but I didn't stated you were complaining about *all*
headers. Go back and read it for yourself.

> > Now, all the other topics I agree and, in fact, have been pushing for
> > that as I can. Specially with regards to IP cores being shared among
> > several architectures (see drivers/usb/dwc3 where I have a core driver
> > shared between ARM and PCI/x86).
>=20
> Good, so you've just taken back most of what you said in your previous
> message.

of course not... maybe you misunderstood me. My whole point was to avoid
using cpu_is_* exactly because it would prevent this driver from
compiling anywhere outside of ARM builds.

here's where you chiped in:

http://marc.info/?l=3Dlinux-kernel&m=3D132077706910296&w=3D2

And a small quote:

| On Tue, Nov 08, 2011 at 05:23:46PM +0200, Felipe Balbi wrote:
| > On Tue, Nov 08, 2011 at 04:15:10PM +0100, Nicolas Ferre wrote:
| > > -----BEGIN PGP SIGNED MESSAGE-----
| > > Hash: SHA1
| > >=20
| > > On 11/08/2011 03:41 PM, Felipe Balbi :
| > >=20
| > > >> +	if (cpu_is_at91rm9200()) {			/*  AT91RM9200 Errata #22 */
| > > >=20
| > > > I don't think you should be using cpu_is_* on drivers.
| > >=20
| > > It is a common pattern in at91 drivers and has worked for ages.
| > > Do you think it is related to the need to be able to compile the
| > > driver for any SoC in the case of multi-SoC zImage support?
| >=20
| > we have drivers compiling on multiple OMAP versions without those
| > hacks.
| > Generally, we check the IP revision for that. Don't you have a
| > Revision register of some sort ?

You see ? I was asking $author to try and use some revision register in
order to apply erratas instead of using cpu_is_at91rm9200().

--=20
balbi

--DrWhICOqskFTAXiy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuYn+AAoJEIaOsuA1yqREmpQQAJxm/v/PRk7H0O69Nq3Z45jj
GjWNy2pcgHlWytkGoWEQzjYfz2anqowCRCRl4uABu5T/Uj/u6i+Mkf2CKDAK8nYM
EIs0wfARPaOcdXxCL84g+XZRJGwzjQ5yx2uJJ/sJZJ7AlyuAMg52wiASThJzTzXZ
filWw/k1EfOJc7C6+ReUCkkKkHvg54K7NpeNnGm6zIi70ZmVvXAtdz24wt9CwB/D
y3vwxWO8ER+9SVaY3N0I8fnuWAmt2BrNhgOEYVbvNyNwHEZPYZVdYhOY91v2vk3h
NtE5ZZ5YLRrC3KG1tNn/2AhyYDlbsrTJ0aJkmV8ebQ9dzuR9WzAn2v1jcfQu0LKl
sjBCdlIoD/T4aBLLLee293MJOyDDh8falW6QeHn+h+b88tFa8/7JFFx3wpzYKdbh
eR56v6kmirVIh3b7Z4IPrkNPm9nqawWNN29kQBnTXjSfMXGkjwyHDjbxWJsoFKdK
EbrrWMC5cW5vJelqKUER7Kkb128m9EwjlK+xz4yjXyIze79vSlREDEDj+nrYICLf
zcRcTFJ/bQc4XeXl9tX14RU+R+sjoPjVoc87r4myM2DT/jJ/QHYa8U1rkiG7Hwyp
9Mg5HMGaUCdalQEAjV+R3F7/BeyqV9VjntbYkwdiy0gVB3wbLlsaXyPDV0lfEzA9
Wv9tBi334ksMIC9p7+pz
=3cwg
-----END PGP SIGNATURE-----

--DrWhICOqskFTAXiy--
