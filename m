Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab2F0HRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 03:17:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab2F0HRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 03:17:15 -0400
Message-ID: <4FEAB36E.4030008@nod.at>
Date: Wed, 27 Jun 2012 09:17:02 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
CC: Namjae Jeon <linkinjeon@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com
Subject: Re: UBI fastmap updates
References: <1340456602-46050-1-git-send-email-richard@nod.at> <CAKYAXd-3ArdssdotKHjvUU0f+yqcFC6y2rHF-mqnJnUcP=+eOg@mail.gmail.com> <201206271048.31524@zigzag.lvk.cs.msu.su>
In-Reply-To: <201206271048.31524@zigzag.lvk.cs.msu.su>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1B9E50BF9585E8C6DD8E6FC5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1B9E50BF9585E8C6DD8E6FC5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 27.06.2012 08:48, schrieb Nikita V. Youshchenko:
>> Would you infom me how much UBI attach time is improved with fastmap ?=

>=20
> I'm not Richard but still.
>=20
> On board I'm currently working on, ubi attach time for 1G chip without =

> fastmap is more than 5 seconds. With fastmap, it is less than 250=20
> milliseconds.

I can confirm these numbers.
On all of my boards the attach time dropped from a few seconds to
less than 500 milliseconds.
(The worst case I've seen was ~800 milliseconds)

Thanks,
//richard


--------------enig1B9E50BF9585E8C6DD8E6FC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP6rNyAAoJEN9758yqZn9eU08IAIVjRIoJHpUZZaexWkZ0gRGE
U5n6/xMf8dQb9CzCdBcZYoy0/ATv2s8nNIfZ8bLSPdn/sqJ3nmxsdxm4tPbA2JQD
KTryL0pCK2OSM7RGU0R3m2x5A4T82GBnGzFdvW6JK6+EOtLC9Nmc72Y1ReE69Di9
fxdA2VN1+9qawC7lMQxUmk8Ag9cntcBFMrBz/XFVGNo0KbCk256D9jaCCgptDTkP
ku+FCiFAFvRrTkLpcxVrcN33p1CYmCYcOpNIvPrHQnH/4EiYWUyYoTwZRjsR2hzn
NhMiULHCz28Wpr5srMNlNonYHedU2UwzBHysG8y10+qh86KPiBsGuPHKLSBzfec=
=Pagm
-----END PGP SIGNATURE-----

--------------enig1B9E50BF9585E8C6DD8E6FC5--
