Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2EZIzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 04:55:16 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab2EZIzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 04:55:13 -0400
Message-ID: <4FC09A6D.4060602@nod.at>
Date: Sat, 26 May 2012 10:55:09 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 13/20] arm: Do not call try_to_freeze() in do_signal()
References: <1337983476-22081-1-git-send-email-richard@nod.at> <1337983476-22081-13-git-send-email-richard@nod.at> <20120525234345.GA32000@n2100.arm.linux.org.uk>
In-Reply-To: <20120525234345.GA32000@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE49C3C89FFDA6F43D086FA3D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE49C3C89FFDA6F43D086FA3D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 26.05.2012 01:43, schrieb Russell King - ARM Linux:
> On Sat, May 26, 2012 at 12:04:29AM +0200, Richard Weinberger wrote:
>> get_signal_to_deliver() already calls try_to_freeze(), there is no
>> need to call it directly.
>=20
> NAK.  Please check linux-next (okay, viro's patches haven't appeared
> there yet) but a lot of this stuff is covered by a truckload of work
> that Al's done.
>=20

Okay.
I've rebased my patches to Al's signal tree to avoid further conflicts.

Thanks,
//richard


--------------enigE49C3C89FFDA6F43D086FA3D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPwJptAAoJEN9758yqZn9eJhoH/ihMt+Lrt3ESe3o451LBsPna
uT1O7ufXeTnk0fAX8QPVKyBkHZHDapplXmfMdCZfbI08b03iSscUUW7vkQx6mmU0
1irNzWW9qJcOELPACSzYUQBJcUV8FGZUY8VwFD3QHO+t3wahNEHw62G9Qp4Hh4p9
OCeMRrtz+g87n7naZmCJBsrZxZTkR6DwgUKIHPxsWnTYUnIBZMelZ+aTW8qZwDc2
rrqPoxXPmTN78zmJpOG0BLBP0yyrlNG/jtUM/kMqOqVb7h+kWXa5dO5JSyigBYVt
GvHyQ1xbn/7Qrq9ttWgHIWkmjL8FO/hjufzGbbZPRk9ntIr4dVpOqTmpffkahCc=
=W/BZ
-----END PGP SIGNATURE-----

--------------enigE49C3C89FFDA6F43D086FA3D--
