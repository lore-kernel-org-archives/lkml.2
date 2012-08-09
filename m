Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365Ab2HIADk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:03:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38827 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2HIADj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:03:39 -0400
Date: Thu, 9 Aug 2012 10:03:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: linux-next: manual merge of the osd tree with the nfs tree
Message-Id: <20120809100328.b8d6af3b95e1537ffcb7b053@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Aug_2012_10_03_28_+1000_xLRv2IAxBR=6Pc+v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Aug_2012_10_03_28_+1000_xLRv2IAxBR=6Pc+v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

Today's linux-next merge of the osd tree got a conflict in
fs/nfs/nfs4proc.c between commit 47fbf7976e0b ("NFSv4.1: Remove a bogus
BUG_ON() in nfs4_layoutreturn_done") from the nfs tree and commit
d8e8b68405db ("pnfs: Don't BUG on info received from Server") from the
osd tree.

I just used the nfs tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__9_Aug_2012_10_03_28_+1000_xLRv2IAxBR=6Pc+v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQIv5QAAoJEECxmPOUX5FECQIP/1mtrc9xRsq+dE5TyB9rgMfv
HlNgZ0FJqabLcqA6aQ2eQJRxrZqSseyFNKxe8Uasfs8Djs0CsJB1dRXxsfsGackI
6NNgjcERgjus7d6r2bqWELLgPQixDBMihiV4lITCjWnjdVGZf/vzyAORDbk+N//8
mtFCOdya2lm8cGWxYwEN20BQstsMwlpoFvfTxDrWQiL8C5dpbVBUediccz7xPKtH
qY7RJOqkf5ZiLOlG9dUS6+UeVXowFCGVfKjKBhBimjcocjcSrX3GM8iFfNTEAa03
WF1Iozd5OzXqJnjm/hWSvYlb2oTPJCZPD1/j52MTHPjEE6ZHM/E9RZ8HXulEFEiC
RNOpRAHI4LlsnZjoYw8n9tCITjiaMJPk96yGOXQFP9eevcXtQu0QGw+4tIrD2Tv2
uFve/JT3S9n/bEtJeYK0+RElFLbsESxQg3wusj55uXchw9bEevp9p0uJdrGRwwtf
jr4kz4ir0yHs52/0Mt9p3TxOJCH+2tgCTW3OpicbIafQNAy6fkU11maxC42xR7LG
4Lc9Yj8xaS/GIjxEb3VHzfRKYiXMU9VmUvtIEVUcBMh4un8PrhFgcOxKiOGuNfLN
jNIsk5G2HSA7TcI3bfYYbokzVI8QEhra6I9VGvX3oU27xzQnNKZztsMnd/RyMfJR
OoM8nCuLUgzgRyb1RXVD
=kcfz
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Aug_2012_10_03_28_+1000_xLRv2IAxBR=6Pc+v--
