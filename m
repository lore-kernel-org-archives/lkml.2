Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538Ab2JaQtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:49:43 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41053 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab2JaQtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:49:41 -0400
Message-ID: <5091569D.2090408@kernel.org>
Date: Wed, 31 Oct 2012 12:49:33 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: new daily bugzilla.kernel.org annoyance messages
References: <20121031163005.GA411@kroah.com> <5091535C.9050103@kernel.org> <20121031164504.GB1119@kroah.com>
In-Reply-To: <20121031164504.GB1119@kroah.com>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF8D6727650BFE52E46A926A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF8D6727650BFE52E46A926A
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/10/12 12:45 PM, Greg KH wrote:
>> I'm sorry about that -- a few people wanted to use the "whine" option,=

>> which required that I turn the functionality on. In turn, this annoyed=

>> everyone with bugs assigned to it.
>>
>> Let me see if setting "whinedays" to "0" will turn off the automated
>> whines while letting people set up custom whines as they needed. If th=
at
>> doesn't work, then I'll set "whinedays" to 3650, so at least this way
>> the only bugs you'll get whines about will be those that have been "NE=
W"
>> for over 10 years. :)
>=20
> Thanks, that would be good.  I didn't see anywhere where I could turn
> the "whine" option off, or change it, what screen is it on?

I don't think that's user-settable, as I'm afraid the whole concept of
"whines" is that users can't turn them off. Which is stupid, of course,
as we all know how to set up incoming mail filters.

At any rate, there shouldn't be any future automated whines. If anyone
receives one after today, just let me know and I'll make sure it's off
for good, even if I have to remove the cronjob.

Regards,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enigBF8D6727650BFE52E46A926A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQGcBAEBAgAGBQJQkVadAAoJEI6WedmufEle+oYL/0iYcQlpz1Vy5UpPsIjQXrFz
e752r0f2IY8rd3q2rymrtvDu6h5R32CKNYDZcDY0ZUczaVAyuSkDj0SGEws+5yC8
a+bvuJpNnFecfzkc5OIPNozi+n+Vt1U0zNOx3IRd6wAFC/Kdy4FZG0y4n/Cn6Hgs
8tgCr9MALSeBDpOAunUkxekLH27Bn1dqdBaygeSA16s7Szlwl3yquQITdFvQ1Ogu
9xH2myF/dUXIle8HK70gJYdUCWcOPutGCv/YBgAUfFGnaGaSD/GOGyetP6CPvSTH
zlXFfwPtJ1ZpBfhWKRe6Y/g41J5pT9Jt4a15E62Jlacv/uTM3GtZXfkjbJi+HqTT
WsOYt+Mb8Oi3JwnlAsZ8/RN7naanK3mj9QbUi1suNDgqBD7m3eC9pitrFWOy73ka
JE9Fm2ZbCPmWKL5HTMEsrzswsLzLBtXta4TSxPlJLjO31ljQ2Yu7tOU50plMkn/P
wetc0OSugFGStAqKlBKORF6lI/ltqdVO/nLGOtpxpA==
=gZ+I
-----END PGP SIGNATURE-----

--------------enigBF8D6727650BFE52E46A926A--
