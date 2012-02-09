Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2BIVlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 16:41:03 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58773 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2BIVlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 16:41:01 -0500
Date: Fri, 10 Feb 2012 08:40:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: 8250 move broke the build on sparc
Message-Id: <20120210084048.2f019c32707151631a57458a@canb.auug.org.au>
In-Reply-To: <20120209.163009.1594369939327153054.davem@davemloft.net>
References: <20120209.163009.1594369939327153054.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__10_Feb_2012_08_40_48_+1100_Gzy_q/+6FofBe/Ql"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Feb_2012_08_40_48_+1100_Gzy_q/+6FofBe/Ql
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 09 Feb 2012 16:30:09 -0500 (EST) David Miller <davem@davemloft.net>=
 wrote:
>
> Commit 9bef3d4197379a995fa80f81950bbbf8d32e9e8b ("serial: group all
> the 8250 related code together") broke the build on sparc.
>=20
> You really can't move 8250.c around without adjusting the "" includes
> such as the one for "suncore.h".
>=20
> Simply changing "suncore.h" to "../suncore.h" fixes things, but that's
> pretty ugly if you ask me.

There is a commit that does just that in Greg's tty tree (in linux-next).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Feb_2012_08_40_48_+1100_Gzy_q/+6FofBe/Ql
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPND1gAAoJEECxmPOUX5FE0VsP/jRvXV3JkBQmcZxJySXbDrT7
SIbPM1kb9Wa77la8qIxtXEmiol04sDvBnHuVjHeOUTx4Np5jtPdUZCEZ/XrNn3Lt
+NjHhaIb9SDK91OlZPdquKtMO05fp9A9Xaey1nyAwQvciKHPVWuJg/TAC94vXvQE
NJ6I5upWbtwZhtLvAvcve/5Bgvq9e5M0OjeW8eInBMQUFx5bTNd+gw7JEfNOTxpq
USYAEQtHqMNT8DRGHCy3lf1FIJEsRWGAB3QPTOqGfTeRtHVnVgTc99pV2ofErWRu
QUSII4Rm1HtQ4U22/ZFMP5k8TskFnyCziUnoJKxndf1lMzyRiJb93BlW9dYJB9LI
DfCG+X8dCXyBWbNU/aXcqwUJ/dTJIlOBhUSdFxrrPHQdBkvXSjdxyevlZ2PPgm6K
AK3OzRpq3N8muAD/nKgpeUWPR/p3rMLL9GRGnLpD6jpwOpyw/mKYojam/UHySsXm
b/X2hZ/J7DOpXMl6qttU9BAm+XXhDSYBf1XC3EV408gB/th0wRi1HtDD94lgv9kY
pyrMZXj4watvBKmyNeTPCVXwng/u0tY+L2F+zSUaJ70bcIg2+zDB72UOte0qzodW
F5+kRVMw3mLwe8dqLNsUV8BQdcVEnEjEg3nfzC6oDkWGIez6UmG0bfx2wwNm11wy
vn4ZvVwc0oyaMke1AGWr
=+Zc2
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Feb_2012_08_40_48_+1100_Gzy_q/+6FofBe/Ql--
