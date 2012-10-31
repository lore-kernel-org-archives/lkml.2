Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423276Ab2JaQfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:35:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45558 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422932Ab2JaQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:35:49 -0400
Message-ID: <5091535C.9050103@kernel.org>
Date: Wed, 31 Oct 2012 12:35:40 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: new daily bugzilla.kernel.org annoyance messages
References: <20121031163005.GA411@kroah.com>
In-Reply-To: <20121031163005.GA411@kroah.com>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig831E4449B4682FBAF6D85FA2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig831E4449B4682FBAF6D85FA2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/10/12 12:30 PM, Greg KH wrote:
> Hi Konstantin,
>=20
> Who is in charge of bugzilla.kernel.org?  Yesterday I started getting a=

> "Here is a daily list of your outstanding bugs" email, saying:
>=20
> 	You will get this message once a day until you've dealt with these bug=
s!
>=20
> Who made this change?
>=20
> And how do we turn it off?
>=20
> Otherwise I'm just going to go and delete my bugzilla.kernel.org
> account, as that's just about the most annoying thing I've seen in a
> while.  There are plenty of reasons why you don't want to send out
> emails like this to developers and to do it every single day is pretty
> rude.

Hi, Greg:

I'm sorry about that -- a few people wanted to use the "whine" option,
which required that I turn the functionality on. In turn, this annoyed
everyone with bugs assigned to it.

Let me see if setting "whinedays" to "0" will turn off the automated
whines while letting people set up custom whines as they needed. If that
doesn't work, then I'll set "whinedays" to 3650, so at least this way
the only bugs you'll get whines about will be those that have been "NEW"
for over 10 years. :)

Best,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enig831E4449B4682FBAF6D85FA2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQGcBAEBAgAGBQJQkVNcAAoJEI6WedmufEleu/sL/38VzuJ6y9+VlrbALsmYeyTy
VXGOIwE7YjntX1QKmOWi6RnBZi97OPGnrLrkf6UItlXvFrz9EnaLokvJ8SMEiMc8
23iB39JMHW7PiTeLdt26ux20EJrrQOylojZ37F+CPOM+xJ4XZrwnwKnQKO3ynHjd
MD5khbeVHmXensG+k3tFN0BkaWzXjjjDboeuenS3J2opqM+L1H+LJ3qapjPIUfA+
WDtfy8FdVCx/Yir2dZbp1uCH8efhzAOE/Zst5tT3oVpurpcdsSlNjrmNaaVKW586
M77KoSHqj/HbGEA/4nDmhPmz+23NmtzTQrEyXCmtp7VfKOS0hxMX3yFSigbF7Wzv
UADD8MGLLA9nYweCSkm+IkHmea8ZJNGOGmS66zvWm5clRFA0YP6SPS9sfri7R/o2
cklj4m2KXDndSXBG19sbID8RnQjbBF2iZPOuKnG5O+JM1xTzqba0osIKduD0gXWl
cBlbauMNOTQ99fj2bdAgaiL9SumktnTs9zuEi75grw==
=sLqC
-----END PGP SIGNATURE-----

--------------enig831E4449B4682FBAF6D85FA2--
