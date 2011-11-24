Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab1KXJq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:46:58 -0500
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:55878 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128Ab1KXJq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:46:56 -0500
Date: Thu, 24 Nov 2011 11:46:52 +0200
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mpn@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <balbi@ti.com>,
        Thomas Dahlmann <dahlmann.thomas@arcor.de>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        Anatolij Gustschin <agust@denx.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Ben Dooks <ben@simtec.co.uk>, Heiko Stubner <heiko@sntech.de>,
        Thomas Abraham <thomas.ab@samsung.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: udc: Fix gadget driver's speed check in various
 UDC drivers
Message-ID: <20111124094651.GR3352@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <Pine.LNX.4.44L0.1111161624570.3443-100000@iolanthe.rowland.org>
 <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U5J2I87mWnf1KeOw"
Content-Disposition: inline
In-Reply-To: <12833fb1f3db020248c582c1f947724056a34fe2.1321719300.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U5J2I87mWnf1KeOw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 19, 2011 at 06:26:25PM +0100, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> Several UDC drivers had a gadget driver's speed sanity check of the
> form of:
>=20
> 	driver->speed !=3D USB_SPEED_HIGH
>=20
> or:
>=20
> 	driver->speed !=3D USB_SPEED_HIGH && driver->speed !=3D USB_SPEED_FULL
>=20
> As more and more gadget drivers support USB SuperSpeed, driver->speed
> may be set to USB_SPEED_SUPER and UDC driver should handle such gadget
> correctly.  The above checks however fail to recognise USB_SPEED_SUPER
> as a valid speed.
>=20
> This commit changes the two checks to:
>=20
> 	driver->speed < USB_SPEED_HIGH
>=20
> or:
>=20
> 	driver->speed < USB_SPEED_FULL
>=20
> respectively.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Reported-by: Alan Stern <stern@rowland.harvard.edu>

applied, thanks

--=20
balbi

--U5J2I87mWnf1KeOw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzhKLAAoJEIaOsuA1yqRErO0QAJQPLfgzMS9TBVpU6WOd/VDg
ZvoPO1oupoASf3mdPvPEWAics4n4Ct7Wrge6F8daS0lYJB/szOUTLx7ZZfiwP0k7
B7e5pfq4RfTW/bfztPqMgpvxkhcCpPCxfYtV/KIoPaimv4+z+XyMIcpZs7OyAx6T
IKtZls7jGvvQav5ANBzJuysVM2T6wA7qhmKBERU89rNmfz/N+RORcwQgOynTIfJC
KguNnV3upVcg5utrqJ8YyV/jxmq6TQ5w7jnenLu0t42GHpo4+OYEW98Zoe6P638x
UdOLTwjMmfm9s8lMDvO8MHr0YCQU0iYiofOtVVezz5kc9JbQz59Pz21doZOcrw5C
bM3vQZFZX1/S1FFkinINi1hykhXX3pfzFYA43aC2l2lGC/TDKMJ8n35azmPfeKUn
z0UaV3lY8cAyq0KWyQ/l6CYOJCE/25THBF1RuY6OVOgm+mtvJeFFirU3R7m7nK7h
jWxiDSn/+2PLTn03V3+7amTV/DGQQHfqyMQh7o23QLFrX1189Agx47ZO3T07C64+
ldQ9+nNMSUdPdjPn3fFWT+ZOn9oumNPRnwF0Spfk3lh10TmNkmDEFNU1Oq3kQxSG
3WlyzWFXvR8WwcJCJoKJLQPmGdXe+cNM85KQLdmXY2tq71aIsW4HMdVDueuV95X9
T60sYv+/Iiut3d5P0CPT
=zqSO
-----END PGP SIGNATURE-----

--U5J2I87mWnf1KeOw--
