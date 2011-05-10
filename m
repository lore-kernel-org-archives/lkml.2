Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1EJM7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:59:11 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41534 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751284Ab1EJM7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:59:09 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Greg KH <gregkh@suse.de>, Hans Rosenfeld <hans.rosenfeld@amd.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, bp@amd64.org
In-Reply-To: <20110506074120.GB21046@liondog.tnic>
References: <20110419204117.979118654@clark.kroah.org>
	 <1303263653.3464.65.camel@localhost> <20110420020128.GA27631@suse.de>
	 <1303265862.3464.77.camel@localhost> <20110420031105.GA11945@suse.de>
	 <1303274910.3464.95.camel@localhost> <20110420050617.GA16756@suse.de>
	 <1303356555.3464.128.camel@localhost> <20110505225302.GC12316@suse.de>
	 <20110506074120.GB21046@liondog.tnic>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-UNiJWQsWBNwPhiiKxos2"
Date: Tue, 10 May 2011 13:58:59 +0100
Message-ID: <1305032339.4065.276.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [12/28] x86, cpu: Clean up AMD erratum 400
 workaround
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UNiJWQsWBNwPhiiKxos2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-05-06 at 09:41 +0200, Borislav Petkov wrote:
> Hey Ben,
>=20
> On Thu, May 05, 2011 at 03:53:02PM -0700, Greg KH wrote:
> > On Thu, Apr 21, 2011 at 04:29:15AM +0100, Ben Hutchings wrote:
> > > > We got a few new quirks added for AMD hardware platforms that fix
> > > > problems.
> > >=20
> > > Maybe, but I still haven't seen anyone explain what those problems ar=
e!
> >=20
> > I'll let the AMD people answer this.
>=20
> it's hard to follow back in this thread to what exactly you'd like to
> have answered. Can you please repeat your questions concerning the AMD
> backports? Is it, per chance, about Erratum 400 CPU f/m/s ranges that
> got changed?

I read that:

"
    Support for Always Running APIC timer (ARAT) was introduced in
    commit db954b5898dd3ef3ef93f4144158ea8f97deb058. This feature
    allows us to avoid switching timers from LAPIC to something else
    (e.g. HPET) and go into timer broadcasts when entering deep
    C-states.
   =20
    AMD processors don't provide a CPUID bit for that feature but
    they also keep APIC timers running in deep C-states (except for
    cases when the processor is affected by erratum 400). Therefore
    we should set ARAT feature bit on AMD CPUs.
"

This implies that the HPET was previously used during deep C-states, and
that all this erratum checking is about deciding whether the CPU has
ARAT.  So what bug is being fixed by using ARAT instead of the HPET?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-UNiJWQsWBNwPhiiKxos2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATck2jee/yOyVhhEJAQpDRxAAwYGkF9nqmC01FIH+CozFxFnZLoxqnGrv
t3JEbcJvx21fsaeIJ6iDHgC8AkPBLqdtSt/7ILsQkprO4lgG/ISN3IUUt0xRgjDB
HtqC1qrwcbAx34CgsnhwTJDAtb6lv2XocAtF9IObVx3uq2hn+W2ac5Y3Xkp/GUBj
TRVW1hhylGmCQZ4xo2OSvACTQpIn/lTdYhRcymD0S3OdAOmeawiIUCX+cNT2oG6F
gUEHl+ZcosrUb1L0MQiPtuICwzj2/+8zuFouS2CMbYNkjCxdtueVfaNw1V6XYXcK
NqHmXxA17o1PlyFPlYRm+Oj4nj3qvt2W9F4k3cWBEnmfw4DHi2awFHiZ/cVhpoGZ
ElMywDlzYE600+f/+qAliRaH/JiKrzR9ISpAFoQ1cU0oAc8Lm61qFLyDx06b0I6H
DDy0WuB794jr0YdiYZgPUqIT4Lv2Yiuy+cXv431g8lHqtGR+qqi9yWDsTr4SsFlz
YSwbXM7eAhJokJfzh352LXVxn8xwOR/GWZWviOt+O+T2DZ/c0JB+ZU3Ndqjf6+2U
WHAqWd3eeBqsTOWUWCXjaRZQTR6X8vLa/DuQWhpOXz97OXVOECE6LA6xO5zzJ7oj
nwX/OZZ92qKJdYzm0Elp+2Xaoo1GeoTaJNHvw7CYMKumCrRJixM27pyYKBsvkPqO
L/E9vqxEUQw=
=y9A+
-----END PGP SIGNATURE-----

--=-UNiJWQsWBNwPhiiKxos2--
