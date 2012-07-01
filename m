Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2GAB2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 21:28:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40292 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710Ab2GAB2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 21:28:42 -0400
Message-ID: <1341106098.4852.64.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
From: Ben Hutchings <ben@decadent.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Date: Sun, 01 Jul 2012 02:28:18 +0100
In-Reply-To: <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
References: <4FDB8563.3030805@us.ibm.com>
	 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
	 <20120617164751.GJ12429@burratino>
	 <20120617173456.GA3684@netboy.at.omicron.at>
	 <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-f0eYVWD88MqQGfaew4nI"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f0eYVWD88MqQGfaew4nI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-18 at 14:55 +0100, Ben Hutchings wrote:
> On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
> > On Sun, Jun 17, 2012 at 11:47:51AM -0500, Jonathan Nieder wrote:
> > > Ben Hutchings wrote:
> > > > On Fri, 2012-06-15 at 11:56 -0700, John Stultz wrote:
> > >=20
> > > >> commit dd48d708ff3e917f6d6b6c2b696c3f18c019feed upstream.
> > > [...]
> > > > This doesn't apply to 3.2.y, unsurprisingly.  Let me know if there =
are
> > > > any urgent leap second fixes that will be needed there.
> > >=20
> > > 6b43ae8a619d (ntp: Fix leap-second hrtimer livelock) sounds important=
,
> > > but the patch depends on bd3312681f69 (ntp: Add ntp_lock to replace
> > > xtime_locking) which does not have a commit message explaining its
> > > purpose (and that patch in turn depends on ea7cf49a7633).
>=20
> If I understand the commit message for 6b43ae8a619d correctly, the
> livelock results from ntp_lock and xtime_lock being acquired in opposite
> orders in two threads.  Which means it wasn't possible before ntp_lock
> was introduced in bd3312681f69.
[...]

Apparently some other livelock was possible, though I was unable to
reproduce it myself.  Some proportion of systems running 2.6.32 or 3.2
(not sure about the intermediate stable-supported versions) are reported
to have locked up, either in adjtimex or during the leap second.

I understand that we might not have so long to wait for the next leap
second, so if anyone understands what fixes are still needed in stable
updates I would really appreciate that.

Ben.

--=20
Ben Hutchings
If you seem to know what you are doing, you'll be given more to do.

--=-f0eYVWD88MqQGfaew4nI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT++ns+e/yOyVhhEJAQqXPRAAxlG82zh1WBr3NiErqTA07uSe3Qo9sJks
NeeGR7WqHBvUFZHmDIdzjfTAkUqGwz/xeaQuqrWEqrm0X5ZAB0JB9dya5v7mqPs9
5n2+I5QZMkIuR3vtJJxYWmGsb1u3Epgi5RWKKBEeOsdYQhHC89uzxfl7sHxZb5Zp
MdEajWCDf7m2iKcd1RCwafnkQSi7u/RZxjXQKqXhqVcVPyU9xbKvCxX0ybPzaan1
lDoGNZ8Q8zhDATWPMmsGdmzWAJhY+VNloAFn10xn0UN6LitdtEhzoC8MgpaWW7Vt
8OKkp/K3dkDMVImWTwZbhpEJujKKf4DKJyCyD1KU4UO5hmYN1zUeATFvEU9MpznA
rUXOcyDwRhtKQfYWo+Lx220+mjBLuDyjMkzXn89diKsuG7i0tnaL0tCY5It+u47f
YGkkmYhuQAkCAH56CT9+YqQ2+YJYFy2Ko9+9li09oM/GFQ6mThoWEqAGiBBWI3gD
tYKBaoMk66GBKVJN3phPhnjEBF/f0BeAP9E5jRaITzWV5MZfzZgV/i+K364PBoOk
Aoop1UXJB3Xlt3i+ZRlnPkuhAGpYsfVdxZ7YGTlZip8xy4soQtncrpp6wog6GpI1
zGSckxCKgWz8Di/jYwOJ+OSsogxv7KGeH/3gy5yxmSF5sw96L0sw1ZS2kHqB49xC
9tsOdCWVrfs=
=rQi3
-----END PGP SIGNATURE-----

--=-f0eYVWD88MqQGfaew4nI--
