Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab2B2UGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:06:51 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab2B2UGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:06:50 -0500
Message-ID: <4F4E8555.5040002@nod.at>
Date: Wed, 29 Feb 2012 21:06:45 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: akpm@linux-foundation.org, Ian.Campbell@citrix.com, florian@mickler.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] get_maintainer.pl: Add support for moderated lists
References: <1330544962-995-1-git-send-email-richard@nod.at> <1330545526.22465.5.camel@joe2Laptop>
In-Reply-To: <1330545526.22465.5.camel@joe2Laptop>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDC09E90526011196B43020DA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDC09E90526011196B43020DA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Joe,

Am 29.02.2012 20:58, schrieb Joe Perches:
> <shrug>  From my perspective, it's correct and simple.
>=20
> Moderated lists just means your email may get delayed
> and you may get a "delayed due to moderation" email.

Most moderated lists are "moderated" by nobody and the patch
goes to /dev/null.

> It's not a big deal to me though if Andrew wants to pick
> this up.  It seems that all current lists are marked
> the same way.  You might consider using a case insensitive
> m/\(moderated/i though in case some list has moderated
> in the email address itself.

Let's keep the regular expressions as simple as possible.
get_maintainer.pl is already damn slow enough.

Thanks,
//richard



--------------enigDC09E90526011196B43020DA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPToVVAAoJEN9758yqZn9eeaEIALwwuH6gDV3Z9fOwE6JaOUev
LruQH7y3OmGR9OekOYRwqzWPW5703LSUBd21yGqkCOEnxsiHs6zmq3VKLPqlQpLv
1j0YAGXnsWW+tDbCV80yGqJe7B91uFjuxdNapQznJBV5jPHTSHu6MFm3ZsRbpDAA
0gTvL78/T0o/OlIG1Wwf3leFyY4za5avgrjo+E7cXFypfOv9HghtkNhRRjOECfVc
a92iGgDLPsZhujZGQ3uaoLYJUoWgo+JMLwzr/YdCZ/RmHObgLWnlI0gZtHonk7cE
ncg4lbqIKXSUdPxk+27vNmLD3WA4lKq9ZbdIXfEmH3UWU7KZ03UfR3+rWa22c2Y=
=4ICx
-----END PGP SIGNATURE-----

--------------enigDC09E90526011196B43020DA--
