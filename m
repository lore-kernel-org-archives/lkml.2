Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab1KQPTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:19:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932186Ab1KQPTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:19:17 -0500
Message-ID: <1321543120.2885.96.camel@deadeye>
Subject: Re: [PATCH 1/2] lockdep,rtmutex,bug: Show taint flags on error
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Bowler <nbowler@elliptictech.com>,
        Greg KH <greg@kroah.com>, Dave Jones <davej@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Thu, 17 Nov 2011 15:18:40 +0000
In-Reply-To: <1321519709.27735.13.camel@twins>
References: <1319773015.6759.30.camel@deadeye>
	 <20111116215236.GD3366@decadent.org.uk> <1321519709.27735.13.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-iP4ypxUcT0o6J/j8iHaP"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iP4ypxUcT0o6J/j8iHaP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

rap,On Thu, 2011-11-17 at 09:48 +0100, Peter Zijlstra wrote:
> On Wed, 2011-11-16 at 21:52 +0000, Ben Hutchings wrote:
> > On Fri, Oct 28, 2011 at 04:36:55AM +0100, Ben Hutchings wrote:
> > > Currently lock debugging is disabled when the kernel is tainted, with
> > > a few exceptions.  It is already recognised that this can be useful
> > > for staging modules (TAINT_CRAP), but that also goes for out-of-tree
> > > modules (TAINT_OOT_MODULE) so long as core kernel developers don't
> > > have to spend time debugging them.  Also, there are several reasons
> > > for tainting that are unlikely to introduce false locking bug reports
> > > (e.g. TAINT_FIRMWARE_WORKAROUND).
>=20
>=20
>=20
> > > Instead of disabling lock debugging, show the taint flags in all
> > > lockdep and rtmutex-debug error messages.
>=20
>=20
> So this is two patches in one. I took the last part, the printing of the
> taint flags thing, not the first part.
>=20
> I did a small patch adding TAINT_FIRMWARE_WORKAROUND to the list of
> TAINTS that shouldn't disable lockdep.
>=20
> As for OOT_MODULE, with staging the only reason not to merge a module is
> it being the wrong license and I really can't be arsed about OOT stuff
> anyway, so no.

That's not true.  For example, VirtualBox OSE is GPL but would not be
accepted into staging.  But if VirtualBox developers want to use lockdep
to fix their crap, we shouldn't stop them.

Ben.

--=20
Ben Hutchings
The world is coming to an end.	Please log off.

--=-iP4ypxUcT0o6J/j8iHaP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATsUl0Oe/yOyVhhEJAQqA9Q/9ERPS3CKw7+GliOYINV6x2TyIfPQeE7Ae
tftk1Ijvk84bOWD2HhCzV4PYkUErNpLzjvepvCmmBfCWD2yuJNfwvfJCV3MitN0E
IVbDf9SE6Lecc++mM9M/Q1BUd14nXQoYw8DEmOosNUOWD8nRjJSplOtxK529RFHO
Iah2c2RHrVo1koU0XzVrtOSJLhzdm/kxODQi+1DXC0sqkeSyhwPgBBoUb+2wBFMg
V+jswpU3TTBjqsUcImgZLT7Bz0SUxS4p6yVXB5s+lo+JPuaaMSf23KVNTM//yO8l
OhY6TJuERWktQwcCs5dkJQtz94byuUYX6/GlXIG2G4fiMlGxhQv3y7zJmeDKospm
jOxytosxns8m390aq6sp4pAO+SaA1ZclpMXBH7yFTguf718bF7iffXo5Fdab49lK
7A0kyEfa2fK1A8fsSSKTgCE4wA0PraRwjwK+khAU/u/3ma9DTuGbUMfbBjbZ8sP6
+0SaB62Rig0oMyKYyitB1t2iGFllate0hswAKoaHd+IL1mYvJtf4ZbY9JZcEZHDX
owDHaIqxY12B/9HM6DxpzlKz+H7MJYIPTXv5E70a7GqsjekGp5s099+0eah4/tnq
Fowe7YAU6+wtj7H/JOrlDYqUUlW5JeQ6sJf3YZrNsITaUPlpUTAt1ddHmPjTFawA
NXpDqRWtHDA=
=VTAC
-----END PGP SIGNATURE-----

--=-iP4ypxUcT0o6J/j8iHaP--
