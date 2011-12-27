Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab1L0Xdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:33:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45976 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1L0Xdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:33:35 -0500
Date: Wed, 28 Dec 2011 10:33:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: linux-next: manual merge of the s5p tree with the arm tree
Message-Id: <20111228103326.b4f211f3c46127b8acf2dda6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_10_33_26_+1100_k8yY/QI4_M.0PVL3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_10_33_26_+1100_k8yY/QI4_M.0PVL3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the s5p tree got a conflict in
arch/arm/mach-s5p64x0/init.c between commit 95af214becab ("ARM: 7246/1:
S5P64X0: introduce arch/arm/mach-s5p64x0/common.[ch]") from the arm tree
and commit afba7f91e640 ("ARM: SAMSUNG: remove struct
's3c24xx_uart_clksrc' and all uses of it") from the s5p tree.

I just removed the file, but the latter patch will probably need applying
in some form to arch/arm/mach-s5p64x0/common.c.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_10_33_26_+1100_k8yY/QI4_M.0PVL3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+lXGAAoJEECxmPOUX5FETPEP/Aki6DwRki+X8s+CH2J5Xsvy
5Rslm6VWJP6fJ5jCQ90aoArhbvcCD3XDnPGR7ytAY4RT+LhISYPudBE2WMPOkFY3
6KS5oCaOFQcE6fRwmRUSX+dpTrn2ughSN6R6SopJ/5eRn3y1xkKLSC0shpkNk3C6
BUtaHIdqgZqR/mkef/+WmwJ8pPIaXNtx59k1d+a6CcHuAZsKdS11MRnyn2becENE
Vc3mPrBum/PEjJ6Wl4ToMXbiBhIhoN8mFg3oMkFisEGKFzs/DSPRLmTEsGWV4voI
i90IzzLVYWeC6f6DbBlR9j9T8Nhb2JvYQ4u6JgwQ1t+1fQgVkHen0BA3xYaN9H6/
VCbXE1B2B3yIK64D2CoPS2MMZSQHBvLRpVSTNP0hN0jVH1d9k3vzZdAOhOLbKw3k
6ZP2y32DCWZcI4Ii3mMEgjVAajjEkN0nmI3FfPi4lCWm7yb4GPcacSxNh0aDu+5j
duz+kcO17TGsKf4yGc/ZwUKngfRIT4nesBrKPeAqiic6QCLXNyotorq+OZITIqBB
hL3pVHLaY3tCORr4QATbEhHrJBUWR0IlUoaMuE4mzQmojQxruV7JS4/zJujgbkkM
PWmr1HnjVu3wsrai4MOD9YMvoz2EqaUXK/5H9rlhlZ3Pjwz+cAFoV0o6UkSyS+fH
pDYAWQQ3qoIUig8f3jqa
=/TmH
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_10_33_26_+1100_k8yY/QI4_M.0PVL3--
