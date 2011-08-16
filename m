Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1HPCJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 22:09:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44594 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498Ab1HPCJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 22:09:08 -0400
Subject: Re: [Stable-review] Future of the -longterm kernel releases (i.e.
 how we pick them).
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        stable-review@kernel.org, stable@kernel.org,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
In-Reply-To: <20110815041524.GA7578@kroah.com>
References: <20110815041524.GA7578@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-aM1mijzD2JPdozvEW7cR"
Date: Tue, 16 Aug 2011 03:09:02 +0100
Message-ID: <1313460542.2981.76.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aM1mijzD2JPdozvEW7cR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-08-14 at 21:15 -0700, Greg KH wrote:
[...]
> Today:
>=20
> Now that 2.6.32 is over a year and a half, and the enterprise distros
> are off doing their thing with their multi-year upgrade cycles, there's
> no real need from the distros for a new longterm kernel release.  But it
> turns out that the distros are not the only user of the kernel, other
> groups and companies have been approaching me over the past year, asking
> how they could pick the next longterm kernel, or what the process is in
> determining this.
>=20
> To keep this all out in the open, let's figure out what to do here.
> Consumer devices have a 1-2 year lifespan, and want and need the
> experience of the kernel community maintaining their "base" kernel for
> them.

This timespan is both somewhat optimistic with respect to current
reality, and also rather depressing in that it sets a very low bar.  I
would hope that we don't collectively treat consumer electronics as
disposable and that responsible vendors would like to provide security
support for a lifetime of 5-10 years.  (But no, I don't think that's
easy.)

[...]
> Proposal:
>=20
> Here's a first cut at a proposal, let me know if you like it, hate it,
> would work for you and your company, or not at all:
>=20
> - a new -longterm kernel is picked every year.
> - a -longterm kernel is maintained for 2 years and then dropped.

This is nowhere near the maintenance lifetime for any of the vendors
that are following 2.6.32.y now:

Debian: ~3 years (stated as 1 year after next release)
Oracle: ??? (probably as long as anyone pays for it)
SUSE (SLES): 7 years
Ubuntu (LTS): 5 years

(and those distributions were released well after the original 2.6.32
release).  Given that we'll want to carry on sharing the maintenance
burden, it seems silly to set such an early cut-off date.

[...]
> This means that there are 2 -longterm kernels being maintained at the
> same time, and one -stable kernel.  I'm volunteering to do this work, as
> it's pretty much what I'm doing today anyway, and I have all of the
> scripts and workflow down.
[...]

I entirely understand that *you* don't want to be stuck maintaining
longterm releases from 1, 2, 3, ... n years back.  If you could set a
policy of handing off longterm series around the 2 year mark (and
terminating them if there is no volunteer) then that would be more
reasonable.

I see that you've accepted Willy Tarreau's offer to take over 2.6.32.y,
so if you could just formalise that before /. goes wild over the looming
end of all the above distributions, that would be nice. :-)

Ben.


--=-aM1mijzD2JPdozvEW7cR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATknROOe/yOyVhhEJAQr1Lg/8CkgP9jQtB0RKLRIKxsqrB4rkkW4ZVPsB
J+HRkJ60YB613Mh9+QOQk2OweVlLaEIHy5pJspmJdr2BjHqLfkPvZEzubwVFhSE/
L2BwlMVioTMOAnRzedzMqLZl9fld7dir4lFz3jlZis+VD2rhBiSSPMaQZqZARxNC
poEwkuImW5YMA/N5vAUbEbIwtmRqEwQXSedM42eRGXqbNghq0o6TlULCjn4bMIKJ
mgEKPzDz+qvbP5pPty0DgAgJSEH1Qgs9+vPSJ2uc7RlFtS2ZDsFP8EmapfLDWW4L
bOVGejwje84dXW3BhdyLn6d6mGqw38YtLGGXMcOPdK5jhRRn9z1m5SKowu9KVkDx
MnhPRicXqjphNFFVTXQ7KTI4VlWIJ3I/VqDQIpqTQAT6+fIaEOdZGkhoEwcE6tuX
1swskEbVW3XtSHGlbBy0GPWQez5JIRkaTTrIwWZVMZ/zOgxcBn1ZteVNKtZrOsDM
rrHu5A4UyurXOZepV5LV5HYHDWK4kVKEDdO+H1iOitIP5H3ZiINdwZgs+cYH72Hg
aUlGOxdthCNfcJOj3CQ6cnlCatAfMZOqgUGpMf7hRzrPsHI0Re1xHIBblxLX3YGe
NZw3/n0NCRm7gvqfZGud1QXv+qOlghka4c+EYYakNsWJEuHk5vrZHTTnWAwXSRE2
FfCGtZg9eSk=
=u2E9
-----END PGP SIGNATURE-----

--=-aM1mijzD2JPdozvEW7cR--
