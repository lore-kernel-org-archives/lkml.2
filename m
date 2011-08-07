Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab1HGSWq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 14:22:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59032 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754487Ab1HGSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 14:22:38 -0400
Subject: Re: [Stable-review] [28/55] [SCSI] fix crash in scsi_dispatch_cmd()
From: Ben Hutchings <ben@decadent.org.uk>
To: James Bottomley <JBottomley@Parallels.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <1312739411.2591.1026.camel@deadeye>
References: <20110806000251.682788533@clark.kroah.org>
	 <1312739411.2591.1026.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-S0qt1xkr7UCdtsM6N+3v"
Date: Sun, 07 Aug 2011 18:51:24 +0100
Message-ID: <1312739484.2591.1027.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-S0qt1xkr7UCdtsM6N+3v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-08-07 at 18:50 +0100, Ben Hutchings wrote:
> On Fri, 2011-08-05 at 17:01 -0700, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let=
 us know.
> >=20
> > ------------------
> >=20
> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> >=20
> > commit bfe159a51203c15d23cb3158fffdc25ec4b4dda1 upstream.
> >=20
> > USB surprise removal of sr is triggering an oops in
> > scsi_dispatch_command().  What seems to be happening is that USB is
> > hanging on to a queue reference until the last close of the upper
> > device, so the crash is caused by surprise remove of a mounted CD
> > followed by attempted unmount.
> [...]
>=20
> This has been reported in 2.6.39.y and 3.0, but not in 2.6.32.y.

That is, AFAIK.

Ben.

> Is the fix really applicable or necessary in 2.6.32.y?



--=-S0qt1xkr7UCdtsM6N+3v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATj7Qm+e/yOyVhhEJAQqjiQ/9FdXeDW7NUTxZVBCe6M8cwQW6IwRqiIaF
omTT/3yxJ3ZrENReJpSWWReEfwUeA5FXlwBHEE2AU4XvoSP3D850WdKmBBik7CWH
m2cKYYER0hLif69ZF+zW+SyON5NS8aoEHNLp8AEmyKfFV54aicl8DzH5So8xYLaX
VBXNUvqpQUbAeXTxq6t80avE4b4aDnQTVlR48gLBeZlmvw2shuL7WquhjVbV2RNt
CvdXcED2rvs8HUTVM/Eyf/fr5xnESgqRnHzNblmzr7eT5AyjOBw38AMJ9RvyDBHG
yXaZFBTVwocpELe7B8fk7uOZeW+at4ZJL/aJkoq9ANWOnFM7Gw1lQWmfFc3IwuDn
QGxo5o7EluqNNhAZe1vCy8F996LQZNXefPo0HCySbFg7lCK6+yjvJBomwnXPUbFR
vi71tAwQPkSIB+EBUuqgYKlYOqEr43vt0l3CS/LpirkPnzCV3+Xi4qrMMI3GiiMQ
0vxqxbM1dxwL7qFmKvtPGDb8j8qbz+XpWt0l8t13sRmICMQRpaJRshP3qf2M40ud
amMlsYKyxxCs5FXcqhbPeSkzGZiBZ1CrQfbHkw2DF4B7i2OBHNsLZyecZVqY7TR+
tN6V678wY6zDd4G0yqcbyP0boDlvvjeRKwnFYGcAFniUwvaNADQn/FU5xe3bdXj3
m0lngd2UV7s=
=hvsu
-----END PGP SIGNATURE-----

--=-S0qt1xkr7UCdtsM6N+3v--
