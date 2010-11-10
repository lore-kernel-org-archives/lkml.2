Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0KJDhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:37:38 -0500
Received: from ozlabs.org ([203.10.76.45]:50895 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104Ab0KJDhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:37:37 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimksMYmLZrg3RUkbvYygeu1bLXkV7b4y8JeEAih@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <20101109221338.GA19947@suse.de> <1289345811.10536.8.camel@concordia>
	 <AANLkTi=UftgQn0ydRd2wszqFtpRrkEcW7dzfapKKix_V@mail.gmail.com>
	 <1289350360.22787.9.camel@concordia>
	 <AANLkTikGHNkUN6t9rPhdE6XOQiqb5xAzH_9eY6L9h2H2@mail.gmail.com>
	 <1289351423.22787.22.camel@concordia>
	 <AANLkTin_VixECn4AdQW_xC=_5ZNY5wBsif6cW5dDEJFe@mail.gmail.com>
	 <1289353544.22787.49.camel@concordia>
	 <AANLkTimksMYmLZrg3RUkbvYygeu1bLXkV7b4y8JeEAih@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gJ1Y9VrJ7vwVEiNBBYm6"
Date: Wed, 10 Nov 2010 14:37:33 +1100
Message-ID: <1289360253.22787.51.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gJ1Y9VrJ7vwVEiNBBYm6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-10 at 02:59 +0100, Kay Sievers wrote:
> On Wed, Nov 10, 2010 at 02:45, Michael Ellerman <michael@ellerman.id.au> =
wrote:
> > On Wed, 2010-11-10 at 02:19 +0100, Kay Sievers wrote:
> >> On Wed, Nov 10, 2010 at 02:10, Michael Ellerman <michael@ellerman.id.a=
u> wrote:
> >> > On Wed, 2010-11-10 at 01:57 +0100, Kay Sievers wrote:
> >> >> Stay on the list please, with any possible reply. Thanks!
> >> >
> >> > You dropped the CC when you replied, or is my mailer being weird?
> >>
> >> You replied to me only:
> >>   From: Michael Ellerman <michael@ellerman.id.au>
> >>   To: Kay Sievers <kay.sievers@vrfy.org>
> >
> > Because you replied to me only, or at least that's what I see at my end=
.
>=20
> Sure, I don't add lists back when people reply to me only. You never
> know why they do that, and if they have a reason for it. That's why I
> added the the same mail:
>   "Stay on the list please, with any possible reply. Thanks!"
>=20
> >> Devices can never be on two subsystems at the same time. Not with
> >> classes, not with buses, that was never, and probably will never be
> >> possible.
> >
> > OK, I guess I'm getting my terminology wrong. My devices, which show up
> > in /sys/class/foo are symlinks into /sys/devices/virtual/foo, so they
> > _appear_ to be in two places.
> >
> > I also see entries for example in /sys/class/scsi_disk that link
> > into /sys/devices/pci.
>=20
> Sure, all devices (devices are real directories) end up in the tree in
> /sys/devices/. That's one tree, where all the devices from different
> subsystems stack on top of others.
>=20
>=20
> All devices have a symlink called 'subsystem' which points back to the
> individual class the device belongs to.
>=20
> To find all device of a specific subsystem, you start at the subsystem
> directory (class/bus) which collects them (only symlinks to the
> device, not directories).
>=20
> That way you will find a blockdev, even when it's deep down in a chain
> of devices:
>   pci:bridge/pci:dev/scsi:host/scsi:target/scsi:lun/block

OK, I think I get it. Thanks for taking the time to explain it to me :)

cheers

--=-gJ1Y9VrJ7vwVEiNBBYm6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzaE30ACgkQdSjSd0sB4dKyxQCgpU3tANNcXYiq/NyBxhYux73u
TjEAoLtKQdEMvpZWSYSbHwgan2iFPI0l
=vlAx
-----END PGP SIGNATURE-----

--=-gJ1Y9VrJ7vwVEiNBBYm6--

