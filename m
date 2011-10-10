Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab1JJLNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:13:31 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:55475 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab1JJLNa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:13:30 -0400
Message-ID: <4E92D352.1030109@nod.at>
Date: Mon, 10 Oct 2011 13:13:22 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
        viro@zeniv.linux.org.uk, dchinner@redhat.com
Subject: Re: [PATCH v2] ramfs: Remove module leftovers
References: <1318244079-10815-1-git-send-email-richard@nod.at> <20111010110907.GB28672@lst.de>
In-Reply-To: <20111010110907.GB28672@lst.de>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A24968B2F6D7CBA9D88B57E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A24968B2F6D7CBA9D88B57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 10.10.2011 13:09, schrieb Christoph Hellwig:
> On Mon, Oct 10, 2011 at 12:54:39PM +0200, Richard Weinberger wrote:
>> Since ramfs is hard-selected to "y", the module leftovers make
>> no sense.
>=20
> Removing the dead code looks good, but what is the point in using
> device_initcall?  We've always been using module_init for non-modular
> code, though.
>=20

Ah, ok!
So we can keep the module_init()?
I was not sure whether it's valid to use module_init() in pure
non-modular code...

Thanks,
//richard


--------------enig8A24968B2F6D7CBA9D88B57E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iQEcBAEBAgAGBQJOktNXAAoJEN9758yqZn9e+mMH/2oo71Xmdyz1+B3I2ITlA6th
bT8rUl2tEWGn5p58vGEzJmg1u5+zERCqkgL+mvAzTfEkhhoK8bOhv77kpg0/G5Bu
VseHdUHaaOwl/Afe8mGXFw59GYKcHibTgy6Tb6HVsT825Mai2gY3RzJjgkc8r18j
I6qm5UfGDam7VWGWa2gbkt8GID3lDur5l1hXTWQEOx1PDsNNqJ7oayn2OahQ2IQe
wOwrew/Vet5wbKeW4YBxmZfJxsPuTP79DvFjUxKZHpo/cfw5ICp3dT8vRl/PfHMc
71V2vX7rt2T98CvbDTPUFemrpmYQxgO4JF1f3yriasQS4V+weQ5Ax6GsqSf4daU=
=HaSY
-----END PGP SIGNATURE-----

--------------enig8A24968B2F6D7CBA9D88B57E--
