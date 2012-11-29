Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab2K2F3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:29:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47815 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2K2F3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:29:47 -0500
Date: Thu, 29 Nov 2012 16:29:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>, Greg KH <greg@kroah.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: linux-next: manual merge of the pwm tree with the driver-core tree
Message-Id: <20121129162945.ee9cf8d7620477159e038ccf@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_16_29_45_+1100_a4TCTY0K+1VhHI1z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_16_29_45_+1100_a4TCTY0K+1VhHI1z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
drivers/pwm/pwm-twl6030.c between commit fd1091125a1d ("pwm: remove use
of __devexit_p") from the driver-core tree and commit 6179a58ec7e2 ("pwm:
Remove pwm-twl6030 driver") from the pwm tree.

I fixed it up (the latter removed the file) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_16_29_45_+1100_a4TCTY0K+1VhHI1z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtvLJAAoJEECxmPOUX5FEmjQP/iR8A8ZQ8gJa1xG/pjeKzGQH
o/3nH82FxApvzW9h5HiP8KdAz9bOSKu3mk+e9fgw8aYXp6DQuyLgSxwDTiOvANLL
Y5ZK6QAYwUpzeeC9yf+Y4OZL/+UBVGnC0UOzYy4ZqIlEuJQHueazoCSfwRx2jDgU
bXs6Hyo8TRiaFOmKy+cP8xs2Qm9gzkvb8o4X4zrsaLSpjbejCOhoO8vgmAxJHb8p
lfMsXYxkr4jo1Ho0feGO3qOKLICZ/Vwu7cx423A1kusG4bjkpjoMnCLva/sP8C1D
9qKDkoigA4ah1zpLfm36PBPWy7G5tTVLB87OMtQWppIM9a8jz1EGLSCUa6kvq7x7
I1JiuspeXkVNcCGRTSci4Xh347t9M4opgr9z/TeWKEpU9G36Ooo0b2tQ66z+oMjQ
+986G0NgQc04yxv6T/YbgGhYJLtlFF2h7e9MM66lnb5M2CI6iDktxGCR250ofR6Z
E7sGiinU6cbg/d4uUKJcDRDuW0RXv9FnREfdLwut9YDC/CZ8y9cZdZmI9zM0ixFH
OUFlTvGNEAEO56+bE3A5RfnfTN3BwkqJi7lQ/NrCbbQfH3YqKDZteMgAQfo7GLVH
DK14svmOyhuXebiPJ9sPaInnIWzY1QXRy+YTcKYNKRL9MKr5YEfkKIew+mVE8mKd
JzBuG1RESnwBIc/52GL5
=nkZn
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_16_29_45_+1100_a4TCTY0K+1VhHI1z--
