Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2E1JuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 05:50:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab2E1JuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 05:50:03 -0400
Message-ID: <4FC34A40.8030000@nod.at>
Date: Mon, 28 May 2012 11:49:52 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: Shmulik Ladkani <shmulik.ladkani@gmail.com>, linux-mtd@lists.infradead.org,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com
Subject: Re: [RFC v7] UBI: Fastmap support (aka checkpointing)
References: <1337771191-95358-1-git-send-email-richard@nod.at>  <1338036094.2525.7.camel@koala>  <20120528093625.050badc6@pixies.home.jungo.com> <1338187619.2480.9.camel@sauron.fi.intel.com>
In-Reply-To: <1338187619.2480.9.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC2070EFF36E3EBABF25BD24E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC2070EFF36E3EBABF25BD24E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 28.05.2012 08:46, schrieb Artem Bityutskiy:
> We should have an ubiattach option instead (and add this feature to the=

> attach ioctl - thankfully we have unused bytes there).

Okay, I put that on my list.
I'll add an option to ubiattach and a kernel command line parameter.

Thanks,
//richard



--------------enigC2070EFF36E3EBABF25BD24E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPw0pEAAoJEN9758yqZn9eEiAH+wY1xNv25XGCNO9XO+calym/
wxxEd2RglS+/rmXOY9FvN0pamI2aHdiiG5vzkXU26V0PbOibSCoW35E0zNr1bXxJ
11fMFiaZoF0sXsTup1qpQFB6SIAmHkd6fFXjBEatinnnxZ0aRwO9cvHyZE4gTA27
yDqUtX2ROSemOfrkAbvxBXeGorn18Wdp0w55yLnSzBZwUzpZ7uVH8y5x1hQApH5r
ItzCaIHz42qNO95nwi5qkAs1PZ1ngkUQzhA+85ZucOEAAjN2DOH0Y/0NUy5kVtly
VjTr0kR+69uPoZYj2PUHZezzqWK2baXk1SZs+C7Fo3ceAhuBBqxLoByb3Q9o/1s=
=jWti
-----END PGP SIGNATURE-----

--------------enigC2070EFF36E3EBABF25BD24E--
