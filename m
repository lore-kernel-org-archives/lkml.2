Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab2CWNDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 09:03:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37905 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2CWNDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 09:03:24 -0400
Date: Sat, 24 Mar 2012 00:03:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-Id: <20120324000308.4707673cf4fb3994e2b72f82@canb.auug.org.au>
In-Reply-To: <4F6C715B.2080104@windriver.com>
References: <20120323155114.a1779aa050fa05f6191b7dae@canb.auug.org.au>
	<4F6C715B.2080104@windriver.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__24_Mar_2012_00_03_08_+1100_h2wuHw77.QTuZFt2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__24_Mar_2012_00_03_08_+1100_h2wuHw77.QTuZFt2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Fri, 23 Mar 2012 08:49:31 -0400 Paul Gortmaker <paul.gortmaker@windriver=
.com> wrote:
>
> Too bad the radeon commits weren't in linux-next, then we'd not
> have to be fixing these in the merge window...

Well, yeah, but I understand that they came in late.

> I think it makes sense for me to fold this into:
>=20
> commit 50af5ead3b44ccf8bd2b4d2a50c1b610f557c480
> Author: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date:   Fri Jan 20 18:35:53 2012 -0500
>=20
>     bug.h: add include of it to various implicit C users
>=20
> in the bug-3.4 tree before requesting it to be pulled.

Except that this file does not exist in your tree currently, so you would
have to merge Linux' tree first (and put this in the merge commit).  It's
probably better to just mention this to Linus when you request the pull
(along with the one in fs/reiserfs/reiserfs.h).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__24_Mar_2012_00_03_08_+1100_h2wuHw77.QTuZFt2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPbHSMAAoJEECxmPOUX5FEZZIP+wYsdgsxcfU5IjxkMbXk7ZzH
q6R4R9/44OIGXRVApHy5vYYPxhqDT+4C5wwQKZ0R7YlPgBNk1OjwVyAhRzqbyEy1
nQWhyvSg7qz83aKdvR3SBVFp9XleqNKMUZPQOXGh2PD+uL9svQYgsgA/Ifuv6sJK
3brMMO+kTTi0x5wmns/+K0zSxxHsLmpmdzm754EM2BDk30lWG8tumkMM83OgcFY1
hFH1uUdvi9lKdlIf14HBMP1leAnxw8AaxRYHu7wmQoJ+ervhXK1hsx8+Q+8Nsoqu
emKV/mZsDohGUfOpSoD4A0lGgYN+3qyJTunrHp3cJG/aajFgOd+lLCxKKCsKyk4k
6pgOUzYCgbQRSvi+ow0XHR3s/SW3LyzragINbKIGRXoGij24bF+vsahdDtKIbnHw
FoE2OnOCkeA7yFnqDXgh6E4CqJdnDstMV1CwuFwbMptiKX122Za/zE9UhW1+Ti1E
xzTESHmASskbVRjJtKsS0ueNXwYdiE9Jx3tYWl+9n/bxhZ+zwqWapghyp3VbhWYe
Si0YioMIBnFnwLiOGoRej/41SNcxuoicXPFI6oO698YTNMvl1TbtUHni1PfWB2/G
ct/KH5hpTAKG594EhKpaArBR9nka9ugwteNKtNSS7poMK8S/WFW24sDQ4JTHeTWC
K/xmg7Jyz1KvfgSEk0mI
=i0sj
-----END PGP SIGNATURE-----

--Signature=_Sat__24_Mar_2012_00_03_08_+1100_h2wuHw77.QTuZFt2--
