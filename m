Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2IWV77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 17:59:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527Ab2IWV75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 17:59:57 -0400
Message-ID: <505F864C.2000103@nod.at>
Date: Sun, 23 Sep 2012 23:59:40 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 05/14] userns: Convert hostfs to use kuid and kgid where
 appropriate
References: <87k3vote43.fsf@xmission.com> <1348187330-6616-1-git-send-email-ebiederm@xmission.com> <1348187330-6616-5-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1348187330-6616-5-git-send-email-ebiederm@xmission.com>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig670CD0EC8234AD49ECC064C4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig670CD0EC8234AD49ECC064C4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 21.09.2012 02:28, schrieb Eric W. Biederman:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
>=20
> Cc: Jeff Dike <jdike@addtoit.com>
> Cc: Richard Weinberger <richard@nod.at>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---

Looks sane to me.

Acked-by: Richard Weinberger <richard@nod.at>

BTW: How you do test your user namespace patches?
Is there a generic way to compare/verify uids within a namespace vs. the =
initial namespace?

Thanks,
//richard


--------------enig670CD0EC8234AD49ECC064C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJQX4ZRAAoJEN9758yqZn9eZkMH/3PMootkUYID2/hTZXChfFpL
T7/YE7JSuJh9Eg3xRPVxkgOOmNA/T5lziEkjsclRhcAEWD3HBs+g1AEQyRWVtJIa
kjbY/b1dnK9QM2/c8gAEaX5YWGsP1aPsHS5TIeP/dIn175MH59aA2tN/YfLPkYAm
kKKDEE31YAwb3jKyDN/dxS2XRleNeYIoUNebF76vAqFdVXjDyfi6ST/0VltVekRX
FHEo+m4xVORD0J6r5jGunTopVVPxhSSGFy5ZlcxV5gPLr4L4LC+5QEdbpLyQd87g
iVPZIPp+hw4yCMEACfbjlGNVnUZTIwvtR2DTUxiiqZKBbgFc5xNF/RiJ7j8z6Xk=
=trgK
-----END PGP SIGNATURE-----

--------------enig670CD0EC8234AD49ECC064C4--
