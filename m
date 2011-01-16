Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1APOHH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 09:07:07 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:60661 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab1APOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 09:07:03 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Jan 2011 09:07:03 EST
Date: Sun, 16 Jan 2011 15:01:54 +0100
From: Pierre Ossman <pierre-list@ossman.eu>
To: linux-ide@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20110116150154.127ea8b1@mjolnir.ossman.eu>
In-Reply-To: <20100715213801.627f095a@mjolnir.ossman.eu>
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
	<20100715213801.627f095a@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-28819-1295186517-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-28819-1295186517-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jul 2010 21:38:01 +0200
Pierre Ossman <pierre-list@ossman.eu> wrote:

>=20
> Status update:
>=20
> 1. Putting the other sil3132 controller did not make any problems
> appear.
>=20
> 2. Next I swapped that controller with the one next to it to test if
> this specific board design in combination with this specific slot was
> causing the issues. Still no corruption.
>=20
> 3. Today I put the "bad" controller back in, but in a different slot.
> Still not seeing any issues.
>=20
> I could move it back to the inital slot to see if the problem
> reappears, but I'm just happy the system is error free again so I'll
> write this off as a temporary glitch or a bad combination of card and
> slot.
>=20

Time for an update to this somewhat old thread. The problem has
remained, but being so very rare that I cannot reproduce it often
enough for systematic testing. Both motherboard and the "bad"
controller have been swapped out with different (but identical) cards.

These days there are some controller cards based on Marvell's 88SE9128,
which seems to be a decent chip. So the next step is chucking all the
sil3132 stuff in favour of those...

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-28819-1295186517-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iF4EAREIAAYFAk0y+lQACgkQopDLsoqlmEKhVgD8DBBdMq/YniFjd1dvAn19VSem
cBMoHEHaBvN0pYCmdhoA/RzSj9m80mchlYS/3kcqHpgZa6b7kC5YJeEBQtY5BlHA
=3V+M
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-28819-1295186517-0001-2--
