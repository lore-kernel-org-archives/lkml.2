Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab1JQOby (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 10:31:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45539 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760Ab1JQObw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 10:31:52 -0400
Subject: Re: Bug#645366: [fuse-devel] Hang and suspend failure after FUSE
 server killed (3.1-rc7)
From: Ben Hutchings <ben@decadent.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>, 645366@bugs.debian.org
Cc: fuse-devel@lists.sourceforge.net,
        "brian m. carlson" <sandals@crustytoothpaste.net>, rjw@sisk.pl,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Oct 2011 15:31:28 +0100
In-Reply-To: <87ty77lmts.fsf@tucsk.pomaz.szeredi.hu>
References: <20111014225213.GA5705@crustytoothpaste.ath.cx>
	 <1318824752.3340.7.camel@deadeye> <87ty77lmts.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rppxT0+r4Yr1jotFdNZx"
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318861889.3340.23.camel@deadeye>
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rppxT0+r4Yr1jotFdNZx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-10-17 at 16:22 +0200, Miklos Szeredi wrote:
> Ben Hutchings <ben@decadent.org.uk> writes:
>=20
> > On Fri, 2011-10-14 at 22:52 +0000, brian m. carlson wrote:
> >> Package: linux-2.6
> >> Version: 3.1.0~rc7-1~experimental.1
> >> Severity: normal
> >>=20
> >> This morning I was backing up my laptop to another computer via sshfs
> >> (and fuse).  The afio archiver was writing to this sshfs-mounted
> >> location.  I decided to abort the operation with Ctrl-C, which caused
> >> the sshfs mount to become unmounted; however, afio was apparently not
> >> affected by the SIGINT (probably because processes in disk IO are
> >> unkillable).
> >>=20
> >> Several hours later, I attempted to suspend my computer and it failed =
to
> >> do so. The kernel log (attached) indicated that the afio process from
> >> hours before was preventing the suspend.  Since processes waiting on
> >> disk IO are unkillable (IMO a bug) and the underlying device to which
> >> afio was writing was long gone, I was forced to reboot the machine in
> >> order to get it to suspend.  If I had not noticed that the machine had
> >> failed to suspend, it could have stayed running in my bag and seriousl=
y
> >> overheated.
> >
> > This seems to be a bug in FUSE.  Is this known about?  If not, could
> > someone look into this?
>=20
> It's a bug in the fuse-freezer interaction.  Yes, it is known.
[...]

But the FUSE server was already killed; shouldn't that cause outstanding
requests to fail immediately?

Ben.

--=20
Ben Hutchings
No political challenge can be met by shopping. - George Monbiot

--=-rppxT0+r4Yr1jotFdNZx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATpw8QOe/yOyVhhEJAQql9hAApQL4gSZlw4KphZbtNioMKXPQihX+RRGY
2//CQJKF9EaWCARG/xctQwBrcBKpc3aCpub4anZoXSLwdEre4/yzcO13iYZv6Bye
h32Z6HY1KuHLkOyKmF6lYgZspdL+6aiNF7qC5rnRcuZh9VnDvbDhcCcWEi1FDp7h
DSbtKtrVAKavZxmdw8qQh7KSYRqIDWJ8xbBRQ+RUbN3zUxBMdQFyg5jfaGI8yDaa
p3Ygnc8pcv8T6fU7xSIBnZCBwnKx1yianpQV7eGhfF1JD5g5UVrvH0s+PLRyz8V2
fb8W7/GotWtRDUGjtAkwGc/C2A2CcMNfP2U0vHMaLBB6m8JKK0epqq9dNn8lE/yl
dypW+V0If9vqt3wiL30h6DKdAw+B5MGvpFDFYR+Fc/N5uFNLlb7yOmncVHMzwSVr
WOFWjm/Dy79kbiosWGpNPGgC7n+PUzN072a/vJNi+glsyOoYRnw3t7Bg61Eyf6xA
Shi6eWpUziKMQ9aAZopzTyN80oH1l93UmenWtE3M4BrDBYVDYT5vHKIYb0pzNtxn
2vmLv8LhoKFxod9dG9oQojK+qYEqKm0IkxqflWIrpOxegcJk6MCj/XyACSGB6Hvq
vvKa+Kmkhlcq3sXcA+X+hFhjmHWsy6EkCbVi7Y6bbmxEPzhQ8PuuaAms/qoM0dBv
aI7qv8wPP5g=
=GB4c
-----END PGP SIGNATURE-----

--=-rppxT0+r4Yr1jotFdNZx--
