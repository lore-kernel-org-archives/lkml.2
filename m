Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1F2IQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:16:34 -0400
Received: from 207-126-122-235.ip.openhosting.com ([207.126.122.235]:39004
	"EHLO drepperk.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359Ab1F2IQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:16:22 -0400
Message-ID: <4E0ADF27.5070805@akkadia.org>
Date: Wed, 29 Jun 2011 04:15:35 -0400
From: Ulrich Drepper <drepper@akkadia.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        linux-kernel@vger.kernel.org, rientjes@google.com,
        viro@zeniv.linux.org.uk, wilsons@start.ca
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com> <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com>
In-Reply-To: <BANLkTin7wm6m5bN4CfQzhJZuhy3bUrS80A@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAD4141DD6EDCDB9C02DD6DE1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAD4141DD6EDCDB9C02DD6DE1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 06/28/2011 01:23 PM, Linus Torvalds wrote:
> The description makes no mention of why this would be needed?

In this specific case I was trying to re-implement the pfiles program.
For normal file descriptors (not sockets) this was the last piece of
information which wasn't available.  This is all part of my "give
Solaris users no reason to not switch" effort.  I intend to offer the
code to the util-linux-ng maintainers.


> Also, it's by no means the only thing not visible in /proc. Things
> like file locking status, leases, file descriptor ownership, signal
> number associated with the setown etc.

True, and maybe that will be useful as well.

I might actually have some more patches to get to socket information but
I haven't fully checked out yet what is available.


--------------enigAD4141DD6EDCDB9C02DD6DE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAk4K3ycACgkQ2ijCOnn/RHTnmgCfeG7LyFoArwj7FCI0UG53jYd8
jMAAn1QkgZmxocMDBU4aWkOboOaZzbeC
=6bG5
-----END PGP SIGNATURE-----

--------------enigAD4141DD6EDCDB9C02DD6DE1--
