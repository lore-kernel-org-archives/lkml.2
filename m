Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1JJGCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 02:02:35 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:54043 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab1JJGCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 02:02:32 -0400
Date: Mon, 10 Oct 2011 09:02:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mnazarewicz@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yang Rui Rui <ruirui.r.yang@tieto.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 3/4] usb: gadget: rename usb_gadget_driver::speed to
 max_speed
Message-ID: <20111010060227.GB31707@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <cover.1314364322.git.mina86@mina86.com>
 <00303915f94de28b1aa2cc711cb46aa503e07bff.1314364323.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <00303915f94de28b1aa2cc711cb46aa503e07bff.1314364323.git.mina86@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2011 at 03:18:36PM +0200, Michal Nazarewicz wrote:
> From: Michal Nazarewicz <mina86@mina86.com>
>=20
> This commit renames the =E2=80=9Cspeed=E2=80=9D=C2=A0field of the usb_gad=
get_driver
> structure to =E2=80=9Cmax_speed=E2=80=9D.  This is so that to make it more
> apparent that the field represents the maximum speed gadget
> driver can support.
>=20
> This also make the field look more like fields with the same
> name in usb_gadget and usb_composite_driver structures.  All
> of those represent the *maximal* speed given entity supports.
>=20
> After this commit, there are the following fields in various
> structures:
> * usb_gadget::speed - the current connection speed,
> * usb_gadget::max_speed - maximal speed UDC supports,
> * usb_gadget_driver::max_speed - maximal speed gadget driver
>   supports, and
> * usb_composite_driver::max_speed - maximal speed composite
>   gadget supports.

same here

--=20
balbi

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkopzAAoJEAv8Txj19kN19bYIAIQMW9YZwuWxlFoxMjWiu6Ou
A2/6THBAOkXojWj3My6QR9Rmp4L1mXVYJEN06hsC6J8Q+32Yx89++zTGag1sYVrb
3mEEqjglR1v48nz8gYU7HlU7yzj44QfHT3uQmgCuCyU3EJDuMIuxp4Q0EQ5wBO4v
s7LeddGG0/7Ky3vFzWIJixRmbyO7vZV9oQFtKiBIpXXmixppwQFbM8ruK0vgy0+0
FeCSu0au+hmQ+iuUpIstgma6FlqlTfy02HjzZCqK1lLOnVr6omRhq6K+khOL1BVX
JB79XQG5mxMiGmYp3FXwA/ZgOt44i5np1oHr51uYhmVgsfY9ivUyO8cmTQrOMWM=
=hyC6
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
