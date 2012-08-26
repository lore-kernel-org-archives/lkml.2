Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2HZUQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 16:16:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63582 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2HZUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 16:16:41 -0400
Message-ID: <503A8418.50809@kernel.org>
Date: Sun, 26 Aug 2012 13:16:24 -0700
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: ksummit-2012-discuss@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] Pubring and instructions for the KS 2012
 keysigning
References: <50387307.9070001@kernel.org> <1345999370.20840.13.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1345999370.20840.13.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig417565F88CA1742DCF59BD49"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig417565F88CA1742DCF59BD49
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 26/08/12 09:42 AM, Ben Hutchings wrote:
> You seem to have missed step 0:
>=20
> Verify your own key fingerprint in ks2012-pubring.gpg by comparing:
>=20
> gpg --fingerprint $KEY_ID
> gpg --no-default-keyring --keyring ./ks2012-pubring.gpg --fingerprint $=
REAL_NAME

Yes, you are correct. I'll send a mass mailing to all people who
submitted their keys to remember to do that step -- I meant to do that,
but got busy doing all the datacentre stuff.

Thanks for the reminder.

Best,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enig417565F88CA1742DCF59BD49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQGcBAEBAgAGBQJQOoQcAAoJEI6WedmufEle+QEMAIP3dNZMxwbeE6VtSwfkdTJc
2E0pmYCTtu3K1xsMr5B0vMyILZYOHt0IHsRHY5eFfAqfXo5W1tQrqGcZcuWxoCxz
ui3KYgnmIKYZAyLdQeSJOvQ99Spb4X4rWqSk8d18c2/QFiJ4qyXwvB2VguBt172f
g5nrzn7iie5AcHVizX623QV38BxwhL+j3cTmyTVRQCSa+vHK4uF+R1M4rhcr4nN+
edfa0ygKWvmjfbbprahGAbZQz5VGlwhHqDf8OSg3v23negmFGNwH+8cDvYOj9OqU
xs8cqAuRugPt4jaduRupqCcXlZ3+uQNS6g83dfHgjlszzp0yKLpetuYXPe+g0bMM
kTYA6WYi+v1jtU5r9rRocb6N04PBV6zjnXrhcWj01ahMkpucIYHJdLtwwM9jdbsF
5vElVmZH3YDWEANy90Q2i0RYhjhaw81xyrITzIGKaN8ujN7XZx88gOoYrrtjQwRs
KM68jzIXAqyt/hLYEm19Ew6FIcdmBKxfnm91VYc0ww==
=Reda
-----END PGP SIGNATURE-----

--------------enig417565F88CA1742DCF59BD49--
