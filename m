Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab2GRLpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 07:45:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61312 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab2GRLpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 07:45:53 -0400
Message-ID: <1342611620.7530.18.camel@brekeke>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 14:40:20 +0300
In-Reply-To: <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ef4bKrX3RLb+LvNvgDBK"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ef4bKrX3RLb+LvNvgDBK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-07-04 at 11:06 +0300, Shmulik Ladkani wrote:
> The existing mechanism of reserving PEBs for bad PEB handling has two
> flaws:
> - It is calculated as a percentage of good PEBs instead of total PEBs.
> - There's no limit on the amount of PEBs UBI reserves for future bad
>   eraseblock handling.

OK, I've modified this patch a lot, did not test, and sent what I have
in the beb branch to you - please, take a look.

--=20
Best Regards,
Artem Bityutskiy

--=-Ef4bKrX3RLb+LvNvgDBK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBqCkAAoJECmIfjd9wqK01JMQAL4PchrlyOyNvCjPCSQuSLbf
6dr2XpFQ97yqdhmGlIkddOonYs7fvva17saJIvCh/ihkYaS/y7L29JODXTWikELr
Uv2nxKe2mLWWzcsj1MD+WHUkfn0MJ7qzoJOwES2Nrr4HtNWwp3gxClHiSB8g8PbY
Q9mRjBudQzNTCo+M6K+OhI09U8UoyNJKhRZjw7zIU8HUyOqWqzEL/E2Vz+17ufgj
2nZXsATMid5F4B27pOye9U8hnA5iYDMzOVtutIG3lT8FRchfngcCiNGQBogK6PiX
1HRKDLluLKOh7nvGakvGK+UQrteY2s+6eIo/tvJZUZpyDWRS3M7PefRjdibUHIKQ
qNa+O5u87Yn1Z5roKYaDoj+h8wWfYRRr0lfLbxB6lZCeJ4aM0lGrd8t1WleiV8TS
AU9X7OALEZK1UmSkWqTLYiEC7ooopBXSJD69JVup5R9tKx+c7HbgzbChaKeDacXR
m6IrEOBpCcY3k4k4D8EC5u2eRCbOzMHyGHfsu5s+Hcc9F8uh7TiOMXEWm2oZ7ubc
nPtep+rUCjPoNMqIm/1byvApiIHI4a+Z2b25x2BTh/6bZVLro3ISqoeX2DR2YPcn
BQCQX/r3kOkoKs0ETudMwUwnGImQEE7l4CzNC6JsFzvSLlihEx82QCx2spZ9Jk7X
G4CoFeUTWEMKSl+wN17t
=Gxsj
-----END PGP SIGNATURE-----

--=-Ef4bKrX3RLb+LvNvgDBK--

