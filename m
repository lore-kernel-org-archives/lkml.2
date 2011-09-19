Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1ISIgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:36:00 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43729 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1ISIf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:35:58 -0400
Date: Mon, 19 Sep 2011 18:35:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: build failure after merge of the final tree
 (origin/net-current tree related)
Message-Id: <20110919183549.765331241abb61e22418c69a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__19_Sep_2011_18_35_49_+1000_2QaP+yoH_MpDWJdP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Sep_2011_18_35_49_+1000_2QaP+yoH_MpDWJdP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) failed like this:

net/built-in.o: In function `tcp_v4_conn_request':
(.text+0x5b700): undefined reference to `cookie_v4_init_sequence'

This error has already been noted elsewhere and a fix queued, so I have
merged a newer version of the net-current tree that contains the fix for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Mon__19_Sep_2011_18_35_49_+1000_2QaP+yoH_MpDWJdP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOdv7lAAoJEDMEi1NhKgbs3uMH/jiyx+cofZaeUngnozLvDZ5R
MURSeHqgCsEsl6s2GTqd1xlcm2FVvXCdG3jJkrKTGoMc7fiEqEEc19sD3fLsEl33
aU0MHhhHbGDjNhdprevx3Xh2Hm8LPapFvNd6M7MmmJZzrYYQ9LFtgWAx/OKJy6QN
NWLnJJeEoe0kHa3rwC7t6hvqv2cG/rXeE9J49mFGBAXRbn5K5MzL7BO/gJRPJbdB
YBDcn0Pfonn7jtqFFktMyO5D+n7xzSURoY7SF46klZFcPnn8qwguHUnTRKRj19cE
iC6XNtS/2F9d5fEuWDD4q9QkdXB/e3fSMzjyCmV9i6LzzNxpqnqXHQo2emLFO98=
=0ugA
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Sep_2011_18_35_49_+1000_2QaP+yoH_MpDWJdP--
