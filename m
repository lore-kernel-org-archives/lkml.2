Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab2KMDCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 22:02:07 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44393 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab2KMDCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 22:02:04 -0500
Message-ID: <1352775711.16264.96.camel@deadeye.wl.decadent.org.uk>
Subject: Missing signoff for 'module: fix out-by-one error in kallsyms'
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Nov 2012 03:01:51 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-VWIiC4bPInvRx2qLoTzF"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VWIiC4bPInvRx2qLoTzF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This doesn't have anyone's Signed-off-by:

commit 59ef28b1f14899b10d6b2682c7057ca00a9a3f47
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Thu Oct 25 10:49:25 2012 +1030

    module: fix out-by-one error in kallsyms

It's a bit late to fix it now, but maybe some kind of an automatic check
for this would be a good idea.

Rusty, can I have your signoff for stable?

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.

--=-VWIiC4bPInvRx2qLoTzF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUKG4H+e/yOyVhhEJAQo1+Q/+K/t2U7rgULoxzUJBf9DBN+gilN9ECf+E
gEImFJ13X4pKynGUUgUVYtLKzx2A/xNq34IpUZTJEfGJZ0Mx/JDZgYfbpnl8zbM7
u/hUlJbSFd3XQ/vGh0uMi7rPK+VyqFtRGjioFPZEBI9msNZnj6B6Y4GDlXxUuPsy
A9tUxjUTeMRY1yF5TXkGSAagKP9eNAF2YKRjilrGu5QjRYnQogpvTU2kgkZTm1sH
l+gsyRWCOsJUXsRyi/gQyuWSO0bCu55CXDiZnXs1QHa4CGeWzjTB951zkH2SkqOl
4SmjxS9sxgkAk4qmqeUAiG3q6ft7Hup1r3YyrFzyeL7xFK4FBDZ7kUp/HGT5OLda
aEVFjcvJvUvGbMyj0tZ5UtM2rLs00Jt5nbK40jvzu3T8LxelV5LNkWHzgL3SrK/C
4f6SWKBljTLVRndkQ/DZ2MseYxlgR+HGuZypZR7JCxif/SUXAXHWyDn+WgacQXzw
BFT50hHiyXCL2yiQQ5kffe2HPjh8P6AJYtMVnnXzX8UzGcr4QO9HFggfz9h72mHl
iMAmZEx1Rm340CU90u8OULwg0O0Me8RZpMTnudkmm/dBI/Nb6/8Drt58AP18y2ak
bbdM/HvP++R2OX0CqMvS4y4DS650T5RED3SEEc8BPnKHDAU5S+SavxyZ372OTc2c
XrWcwzKALHg=
=/fIc
-----END PGP SIGNATURE-----

--=-VWIiC4bPInvRx2qLoTzF--
