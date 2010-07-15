Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934567Ab0GOTnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 15:43:12 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51621 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab0GOTnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 15:43:10 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 15:43:09 EDT
Date: Thu, 15 Jul 2010 21:38:01 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100715213801.627f095a@mjolnir.ossman.eu>
In-Reply-To: <20100520182852.58f504fb@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
	<20100519233408.7436bd9b@mjolnir.ossman.eu>
	<20100520091429.192d560c@mjolnir.ossman.eu>
	<4BF4F979.4070903@kernel.org>
	<20100520112945.61bf9705@mjolnir.ossman.eu>
	<4BF50405.4070706@kernel.org>
	<20100520122227.16ea1cbc@mjolnir.ossman.eu>
	<20100520160049.1528772b@mjolnir.ossman.eu>
	<20100520182852.58f504fb@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-5019-1279222684-0001-2"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-5019-1279222684-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 May 2010 18:28:52 +0200
Pierre Ossman <pierre-list@ossman.eu> wrote:

>=20
> Controller now taken out of the picture and I no longer see any errors
> on either filesystem nor direct disk level.
>=20
> I have a sil3132 of a different OEM brand here. I'll try that in that
> pci-e slot next.
>=20

Status update:

1. Putting the other sil3132 controller did not make any problems
appear.

2. Next I swapped that controller with the one next to it to test if
this specific board design in combination with this specific slot was
causing the issues. Still no corruption.

3. Today I put the "bad" controller back in, but in a different slot.
Still not seeing any issues.

I could move it back to the inital slot to see if the problem
reappears, but I'm just happy the system is error free again so I'll
write this off as a temporary glitch or a bad combination of card and
slot.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-5019-1279222684-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iF4EAREIAAYFAkw/Y5sACgkQopDLsoqlmEKLaQD+MJo3EddRrVqm2+sCwfYjOYEk
ZdG/hJW61VaU7NCdKaEA/RUhclgEA9E0SY4Di4XzYI4ZONB1I8rMW35J6gS6gyC2
=CE9O
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-5019-1279222684-0001-2--
