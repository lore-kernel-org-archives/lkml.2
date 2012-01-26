Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab2AZQp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:45:27 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:51337 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752180Ab2AZQpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:45:25 -0500
Date: Thu, 26 Jan 2012 18:45:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yves-Alexis Perez <corsac@debian.org>
Cc: balbi@ti.com, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-usb@vger.kernel.org
Subject: Re: [3.2+] BUG: scheduling while atomic: swapper/0/0/0x10000100
Message-ID: <20120126164512.GD8665@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1327587732.2296.25.camel@scapa>
 <20120126161539.GA2098@kroah.com>
 <20120126163130.GB8665@legolas.emea.dhcp.ti.com>
 <1327595767.2062.7.camel@scapa>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FFoLq8A0u+X9iRU8"
Content-Disposition: inline
In-Reply-To: <1327595767.2062.7.camel@scapa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FFoLq8A0u+X9iRU8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 26, 2012 at 05:36:07PM +0100, Yves-Alexis Perez wrote:
> On jeu., 2012-01-26 at 18:31 +0200, Felipe Balbi wrote:
> > > Very odd, it wouldn't seem that this patch would cause such a problem,
> > > as it is "obviously" correct.
> >=20
> > The funny thing is that I don't think there's any x86 system out there
> > with this *DRD* controller :-)=20
>=20
> Out of curiosity, what is a DRD controler?

Dual-Role Device. This Renesas controller can act as Host or as
Peripheral controller.

> > Specially when you consider the fact that
> > it's very recently that we dropped the ARCH dependency with commit
> > d242c110c43b55aaf3ebb3ceac1eeab0d452a177
> >=20
> > > Kuninori, any thoughts about this?  Should I revert this from the
> > > tree?
> >=20
> > I don't think so, I think this was a bad bisection.
> >=20
> Maybe (especially since the first bad commit is a merge commit, so I'm
> not completely sure I did correctly the second bisect). But I'm puzzled
> why reverting the commit on top of 3.2.1 fixes that. And now that Felipe
> mentions it, USB Gadget is not even compiled, so I'm completely lost.

Hehehe :-) That's fun... Maybe it's some other instability and it just
didn't kick when you reverted that commit. It could be that the problem
is somewhere completely different and you just didn't fully debug it yet
:-)

--=20
balbi

--FFoLq8A0u+X9iRU8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPIYMYAAoJEIaOsuA1yqREhGoP/A9+15Voib43l4L1w8OCexkn
nlVNZDlwvuhgKI2nFkxdxQ1sXnRClp/4bvIL4/u+J9IR1WPV26U3VDsj3mAgebyj
DIcPzIfFOZ70jETL/fpQlBP+8XmQdNCo27tLO3DnXXz/g9F/R8UxnF5A8BbO2Y45
kRQJumUGwUaOZVEuQPsj3ldfLNscRTUXDB1sPCnkk0JSEOuV1l3Ko4Ug63E1dqp6
rJetFJP5eXj51y0VSPbebVS7dpQYFf6hG7ArsZYBIK8hVMEgm8p/t+gbMLvkVW5w
hqVb2ZsDWpyj7HOc3XGJ31h1Z1mym64NVjSSAyLNX96Y0JyOL7Yl4GU/RLOYrIrH
BgkuiBzG06OX3w+NE3uC8/LuHwPQ/1rgG37ZfYI8LWW88BL7Z/ddNdHQ+V5Bf3/f
h9iNuTt/21dFwD1EqWgO3PpYZXpvAG2xnzUy+wjONpbnIeAsvjWewRFFl49B3w46
Mx8+/C7Tvl4PrgUs3sWh4Udb2eY+LoL0o/OfTi2izuAYFYEUHNELUuuJFquYKhSU
u7OoEY3/2TGfOQ2BccQaY3WKKtwgsmFW7rNbMiHZUCbO+75djATW6e8489nLC+ax
UIw4VUXLYekBmpl6xMEy87RjmJ/dlFi8N8WNZVRH2Bc85zEEIonLPINgapDdK8S2
sYG2/l8Trb6scXqLjhWZ
=+mRm
-----END PGP SIGNATURE-----

--FFoLq8A0u+X9iRU8--
