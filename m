Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0DSQOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 12:14:52 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:54448
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754863Ab0DSQOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 12:14:50 -0400
Date: Mon, 19 Apr 2010 09:14:06 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Stefan Assmann <sassmann@redhat.com>
Cc: digidietze@draisberghof.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
Message-ID: <20100419161406.GO26130@one-eyed-alien.net>
Mail-Followup-To: Stefan Assmann <sassmann@redhat.com>,
	digidietze@draisberghof.de,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org
References: <4BCC5071.4010509@redhat.com> <4BCC6206.4030003@draisberghof.de> <4BCC63EB.4010204@redhat.com> <20100419141907.GN26130@one-eyed-alien.net> <4BCC6FAF.2030809@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wHh0aNzodMFDTGdO"
Content-Disposition: inline
In-Reply-To: <4BCC6FAF.2030809@redhat.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 19 Apr 2010 09:14:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wHh0aNzodMFDTGdO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 19, 2010 at 04:58:55PM +0200, Stefan Assmann wrote:
> On 19.04.2010 16:19, Matthew Dharm wrote:
> >=20
> > 2) It is much much easier to update a userspace tool than the kernel.
> > Thus, new devices can be supported without a kernel update by end-users.
>=20
> Of course. Nobody is talking about removing existing code from any
> user-space application. Under the condition that no functionality gets
> lost, wouldn't it be convenient to have the modem exposed by the kernel?
> If the kernel support doesn't suffice you can still run an updated
> usb_modeswitch until kernel support is there.
>=20
> This also has the benefit that it would work for people that don't
> have usb_modeswitch installed. Matt, are you still thinking that is the
> wrong way of doing it?

I still believe that, for an end-user, upgrading a userspace tool is much
much easier than upgrading a kernel.

Also, the actual "driver" for the device (i.e. the modem part) doesn't need
an upgrade to the kernel component for these types of devices.

Finally, these sorts of databases don't belong in the kernel as much as
possible.

The usb-storage driver will not accept patches for device which can be
supported via userspace-only tools.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

NYET! The evil stops here!
					-- Pitr
User Friendly, 6/22/1998

--wHh0aNzodMFDTGdO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLzIFOHL9iwnUZqnkRAiDxAKCz0O/vR+tK1kpotTzcJTqMd7B2FgCcClgH
Y2aTToM+cdBvJ+8x3FYJgFQ=
=pokx
-----END PGP SIGNATURE-----

--wHh0aNzodMFDTGdO--
