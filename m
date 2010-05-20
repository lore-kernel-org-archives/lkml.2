Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0ETOA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:00:56 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34587 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0ETOAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:00:54 -0400
Date: Thu, 20 May 2010 16:00:49 +0200
From: Pierre Ossman <pierre-list@ossman.eu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Strange read data corruption on ext4/LVM/md
Message-ID: <20100520160049.1528772b@mjolnir.ossman.eu>
In-Reply-To: <20100520122227.16ea1cbc@mjolnir.ossman.eu>
References: <20100519225653.1fedb453@mjolnir.ossman.eu>
	<20100519230426.47c6c1ed@mjolnir.ossman.eu>
	<20100519232906.3be82279@mjolnir.ossman.eu>
	<20100519233408.7436bd9b@mjolnir.ossman.eu>
	<20100520091429.192d560c@mjolnir.ossman.eu>
	<4BF4F979.4070903@kernel.org>
	<20100520112945.61bf9705@mjolnir.ossman.eu>
	<4BF50405.4070706@kernel.org>
	<20100520122227.16ea1cbc@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-5869-1274364051-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-5869-1274364051-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 May 2010 12:22:27 +0200
Pierre Ossman <pierre-list@ossman.eu> wrote:

>=20
> I've since constructed a script that keeps re-running the above over
> all relevant disks and keeps track of how many unique md5 values we
> get. It's been running for about 1.5 hours right now, and here are the
> results so far:
>=20
> sdd - 3, sde - 4, sdf - 1, sdb - 1, sdc - 1,=20
>=20
> sdd and sde are both on the same controller, so the problem you
> mentioned could be relevant.
>=20
> I'll let the test run for a few more hours and try moving things off
> that controller later tonight.
>=20

The trend continues and the numbers are now 9 and 8 for sdd and sde and
1 for the others.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-5869-1274364051-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAkv1QJMACgkQ7b8eESbyJLhZpACg3JozT+SYje+kxZ4+gmCHXlSj
DEEAoIPGjarKh4eZU25zM37fj/Pm7Acm
=yri/
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-5869-1274364051-0001-2--
