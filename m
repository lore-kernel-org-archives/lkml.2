Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1KPLO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:14:29 -0500
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:57215 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998Ab1KPLO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:14:28 -0500
Date: Wed, 16 Nov 2011 13:14:23 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: balbi@ti.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        giancarlo.asnaghi@st.com
Subject: Re: [RFC PATCH] debugfs: add tools to printk 32-bit registers
Message-ID: <20111116111421.GF27980@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111115220437.GA26711@legolas.emea.dhcp.ti.com>
 <20111115212012.GA5467@suse.de>
 <20111115130230.GA23584@mail.gnudd.com>
 <20111115213734.GA5094@mail.gnudd.com>
 <20111115222119.GA17953@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Content-Disposition: inline
In-Reply-To: <20111115222119.GA17953@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kR3zbvD4cgoYnS/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 15, 2011 at 11:21:19PM +0100, Alessandro Rubini wrote:
> > this will be useful to dwc3 too, we currently have:
> > [...]
>=20
> Yes, this is similar, just factorized for everybody to use. I looked
> for files that may use it (besides stuff I received internally) by
> counting the %08x.
>=20
> So in V2, tomorrow, I'll port your file to use the centralized code
> tool, as a separate patch.

that would be great. I'll make sure to test it out :-)

--=20
balbi

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOw5sNAAoJEIaOsuA1yqRERMIQALXMzYFBDC2Osv9wHLmLOtZJ
VPnsEDD2HJeOKayBfMxkPPwCODJwC1lizlKxmqHUfboltXekGue5Iit1FIEzNV64
S7g6kPidJ6gi+gFtX6GSDjuuogiUhBqdp4k/aekcHB0rqlvax9ifDy5AqMhs851a
Ld5enTmcEW+iM5sf62KMXs4DQLFoXFTi1OVAv3uZ+oeS5EkGM2CLJV3SImE5Rj+z
xy+/Zp3oZM4vRKxlmNOMKijba45WZHAw/WwlBg142VoF9j0untgKDWIIytRxX3Td
QoU5pYqNSh7ME0MEw8g5KH0E8d07t8/EFUKdGCu9AluXCMbgZWgK4LBcrED8E11F
c+z11tYhYYILns1AnimF95I7CacebVbiwDgAhY2C1yBAoSk/aLVoySO8aj0t6s19
FD05LhBXM9/pW8SDY4cUBx788zFyhmWpiNkuSBI68SZ5SFWd8xjpth4VWFuoij2g
71IRhR14ZBmMghsMre8v7a6hcJBgTVEw3vXf1L4JtIbfgZUmP1M1375o6XTSX28U
d04KujPJAw28bP34xOmTuOYQdU6l7LAIB0Y0ljlaEz9VwAnSNFqf5bGZ+ql9lDot
mHc2+08kxdvlPizGXn/L5kKFNR22Lp5DhYV5xLn7izGQgWb0VHJDWQG01RMpKp+C
X3PnPZMi5ycqmHtIm3xp
=1K72
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
