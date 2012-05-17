Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761743Ab2EQLuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 07:50:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761704Ab2EQLup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 07:50:45 -0400
Message-ID: <4FB4E613.4020100@nod.at>
Date: Thu, 17 May 2012 13:50:43 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        tim.bird@am.sony.com
Subject: Re: [RFC v5] UBI: Fastmap support (aka checkpointing)
References: <1337201522-86521-1-git-send-email-richard@nod.at> <1337225964.2730.11.camel@brekeke>
In-Reply-To: <1337225964.2730.11.camel@brekeke>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADAA0287309751902C9FBCC6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADAA0287309751902C9FBCC6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.05.2012 05:39, schrieb Artem Bityutskiy:
> On Wed, 2012-05-16 at 22:51 +0200, Richard Weinberger wrote:
>> This is a bug-fix release. v4 handled static volumes wrong.
>> v6 will address everything that Artem pointed out.
>=20
> Hi, I'll try to review this further, but few points I'd like to
> highlight.
>=20
> 1. We'll need to re-structure the code a bit and rename scan.[ch] to
> attach.[ch], all data structures like 'struct ubi_scan_volume' which yo=
u
> re-use we will also need to rename and remove the "scan" word, etc. I a=
m
> willing to do this preparation.

No problem. It's already on my list.

> 2. You need to re-use the scanning code we have for scanning the fastma=
p
> volumes, I think. May be you need some amendments there, but currently
> you have more duplication than needed. You'll just plug more of your
> code to the attach.c file: check if there fastmap, if yes, read it and
> scan the internal fastmap volumes by re-using functions in attach.c. So=

> all the fastmap reading/checking/manipulating stuff is in fastmap.c, th=
e
> scanning and interpreting is in attach.c.

Okay.

> Again, I am willing to do corresponding preparations for you, you'll
> need to amend your code then.

As I said, v6 will contain all requested changes.

> Also, I think you probably do not have to split your patches. For me it=

> looks like there is a lot of work needed anyway, so you could just send=

> it as one patch so far, to make things easier. Because reviewing this
> stuff by reading patches is too difficult anyway, and the reviewer has
> to apply it and review / navigate the real code, and just look sometime=
s
> to the patch.
>=20

Will do.

Thanks,
//richard


--------------enigADAA0287309751902C9FBCC6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPtOYTAAoJEN9758yqZn9eyRoIAL3f6ktYfh1q8GUL9V6/QF0n
MXefjgv0VYlDoPYNKRx0Itj71hNjx0nO453IHOG8mQyVebg0fUMSgq8P9Cs4TQfg
sU7SBrGLJGW7aHlFYVAJk4QgCr/bjrVBpXJEMdrZVoG2sSqp3VvnDd8tuNf6Z+Fx
u3nxc5ha/wev5ABqOGNL2arxyyT7Oiet55NNUkdqR2C5svRZajw/a99hyh93JblQ
fppsl0An7W52w9CqQFstKleE2e+DWrOiuDqnhXrIDby88DvsaWF4a4GT5rpqJ6Y8
gev1KHHYIqcomyfBREVoO1rA+cAi7ZlU0GxFeE+e58fvkb7H1N72W1SiAgv4Z0s=
=UaEY
-----END PGP SIGNATURE-----

--------------enigADAA0287309751902C9FBCC6--
