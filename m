Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1I0A2q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 20:28:46 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44411 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab1I0A2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 20:28:45 -0400
Date: Tue, 27 Sep 2011 10:28:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: error trying to fetch the md and md-current trees
Message-Id: <20110927102821.cb00d937491f799c86a6a1fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Sep_2011_10_28_21_+1000_Djj9dbTqaMRlH7=M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Sep_2011_10_28_21_+1000_Djj9dbTqaMRlH7=M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Trying to fetch the md or md-current tree produces this error:

fatal: read error: Connection reset by peer

I am using my previously fetched version of the trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Sep_2011_10_28_21_+1000_Djj9dbTqaMRlH7=M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOgRilAAoJEDMEi1NhKgbs0/4H/i4YaJ7QEDjutOZ3W3b8t2f5
Y9WDA+0kS4H9sA7wpfcdYgXQsoKgElu31SnanXZne2h9gzD9vU3IFlfOTiKwE9dP
8UBycw7iZIgD1rltMw1PiVOyCCadSKSIO71wD7719DeCCpYlJW0oQ9UQT2gBo3Cw
XIy4AWUT/ddszXM16WK8LlDnKEPE5unKKn4HWRACig3yE14FxkV9oxifStw2wMfG
5IyjtUR8pTIhRQtWWwDedxCC9tPNuO8HKh/ViXkONtCysSrHcfLRLfuQKyQ4+sXw
uiQbUKvxW76o53bQDvQX1CAVQ2tMXTcvhht9OhuNRbl7wIx6Qrmh++Jj3gW58tc=
=DPwu
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Sep_2011_10_28_21_+1000_Djj9dbTqaMRlH7=M--
