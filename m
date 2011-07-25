Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab1GYR2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:28:00 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:34636 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183Ab1GYR15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:27:57 -0400
Date: Mon, 25 Jul 2011 20:27:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [RFC][PATCH] musb: Avoid musb_gadget_pullup "Unhandled fault"
 oops on omap4
Message-ID: <20110725172754.GJ18062@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311206974.2945.198.camel@work-vm>
 <1311608634.2945.265.camel@work-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dy3pjCZLf6+6NySR"
Content-Disposition: inline
In-Reply-To: <1311608634.2945.265.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dy3pjCZLf6+6NySR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 25, 2011 at 08:43:54AM -0700, john stultz wrote:
> On Wed, 2011-07-20 at 17:09 -0700, John Stultz wrote:
> > I've recently run across an "Unhandled fault: imprecise external abort"
> > oops that is caused when a driver called usb_gadget_connect() when there
> > was no cable plugged into the musb gadget port.
>=20
> Felipe: Ping? Any thoughts on this patch?

I'll start looking into fixes once linus tags v3.1-rc0 ;-)
This is in my queue though, I'll start testing soon :-D

--=20
balbi

--Dy3pjCZLf6+6NySR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLaeaAAoJEAv8Txj19kN1ZQoH/2FeHSFENidCRFGzeHx2dPPe
Ya0zBFYoFKbkQqUFCkIqVPlAmJ02mhZw1OOJ2/KRRdqcDqVj3DfNQiMrQHaqK6QP
SjXeKEX2wxB821xyM9np6ZksGWnqQC4TVc8ANaAZJ8R1hoIuplz5nPTWx/3HUURO
nkVmiFNqN8khOyp+pfFm+HYnfzVTgco8oED1O5SysfRbZf1LrQuQxaDhVI5tP+0o
Lo60TkawsVCvj/klYLQ8z5wH7tRYBDK5gtFw+XfROMzTNlMmezmSUErIBtCA2GFg
S+ZQ2v7WjXv9dMD+Fl2W/8kS51v0Ze+/QVeWOOTRvxpR8CkncywIG7rBsm0e+5I=
=G9mc
-----END PGP SIGNATURE-----

--Dy3pjCZLf6+6NySR--
