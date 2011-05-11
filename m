Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1EKAX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 20:23:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43543 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1EKAX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 20:23:58 -0400
Date: Wed, 11 May 2011 10:06:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: ptrace pull request for linux-next
Message-Id: <20110511100626.e5babe19.sfr@canb.auug.org.au>
In-Reply-To: <20110510122431.GA12461@redhat.com>
References: <20110329090248.GJ6736@htj.dyndns.org>
	<20110330101204.7a5459c3.sfr@canb.auug.org.au>
	<20110510122431.GA12461@redhat.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_May_2011_10_06_26_+1000_zrUAnqpTUNz7HOCp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_May_2011_10_06_26_+1000_zrUAnqpTUNz7HOCp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oleg,

On Tue, 10 May 2011 14:24:31 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
> Could you please switch from Tejun's tree to
>=20
> 	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace

Done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_May_2011_10_06_26_+1000_zrUAnqpTUNz7HOCp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNydMCAAoJEDMEi1NhKgbsG/8H/0tIK2iwSE+pUM/D4Rp3rkpW
EQc9g3h7bicbo2t8JKvRwLwKDcYc/DIRK0c6D6Wpph3AcP+I2eGWENnz4SnZHcEJ
b27zB1HsBOwax2Jypc+IOctW7NJJttZbRJkf6b0GL0dZc7nYvHnk0UkrN9F3UagF
UdbR4h+Dwr/6BU0ozPxSieSdp/NjiElWsLUQSWIPvW0H8Ug5x14Lx+W2SQ7qJZ+T
YSNjsI4nWmU/DCfZUUNc8Sq0DQpfUfT6HaOouPVLFR/U5BqTYkgHwxuxybSfqRHR
PLynbK8Xn00TZ/4RS6vtvXeRprgXV5Df55PcLAx5XoaP5fBLJCpTjvSKzWJ7YHI=
=yvxK
-----END PGP SIGNATURE-----

--Signature=_Wed__11_May_2011_10_06_26_+1000_zrUAnqpTUNz7HOCp--
