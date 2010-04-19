Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0DSOT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:19:58 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:60555
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235Ab0DSOT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:19:56 -0400
Date: Mon, 19 Apr 2010 07:19:07 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Stefan Assmann <sassmann@redhat.com>
Cc: digidietze@draisberghof.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: expose Huawei E1550 3G modem
Message-ID: <20100419141907.GN26130@one-eyed-alien.net>
Mail-Followup-To: Stefan Assmann <sassmann@redhat.com>,
	digidietze@draisberghof.de,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-usb@vger.kernel.org
References: <4BCC5071.4010509@redhat.com> <4BCC6206.4030003@draisberghof.de> <4BCC63EB.4010204@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
Content-Disposition: inline
In-Reply-To: <4BCC63EB.4010204@redhat.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Mon, 19 Apr 2010 07:19:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 19, 2010 at 04:08:43PM +0200, Stefan Assmann wrote:
> On 19.04.2010 16:00, Josua Dietze wrote:
> > Stefan Assmann schrieb:
> >> The Huawei E1550 3G modem is hidden by default and can be
> >> exposed by sending some magic initialization code. This
> >> patch takes care of that.
> >=20
> > This device (as all other Huaweis using this sequence) is=20
> > supported by the usb_modeswitch tool which takes of the=20
> > switching process. Once installed, no user interaction is=20
> > required except plugging.
> >=20
> > Current policy is to leave switching to the userspace if it's=20
> > working there.
>=20
> that's good news. This is part of hardware initialization, so let's move
> it to the kernel. Or do you know any good reason why the kernel
> shouldn't handle it?

We've had this discussion, what, over a dozen times already?  It keeps
coming up every few months.

There are two primary reasons to keep this in userspace:

1) Someone might actually want to access the storage mode of these devices.
It has come up in the past, and there is no good reason the kernel should
deny access to that function of the device by enforcing a switchover.

2) It is much much easier to update a userspace tool than the kernel.
Thus, new devices can be supported without a kernel update by end-users.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Now payink attention, please.  This is mouse.  Click-click. Easy to=20
use, da? Now you try...
					-- Pitr to Miranda
User Friendly, 10/11/1998

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLzGZbHL9iwnUZqnkRAnMKAJ95BiCjIbmjFLjmlixKdKDnprGR0QCgql0X
cKRSOMWbioy5LmObE5aD0lc=
=vNrq
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
