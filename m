Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966065Ab2FAXmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 19:42:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966023Ab2FAXmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 19:42:00 -0400
Date: Fri, 1 Jun 2012 16:41:55 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: fate of the ecryptfs tree
Message-ID: <20120601234154.GB6340@boyd>
References: <20120531144115.0f35af0a8a5d79b73b0ecbe6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <20120531144115.0f35af0a8a5d79b73b0ecbe6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-05-31 14:41:15, Stephen Rothwell wrote:
> Hi Tyler,
>=20
> I am just wondering about the fate of the ecryptfs tree.  The most recent
> commit to that tree is dated Feb 11 and seems to have been included in
> Linus' tree as a different commit.

My next branch has become stale. Sorry about that! I haven't been doing
much development on the kernel side in the last couple months. That will
soon change, as I have a few bug fixes in the works and I know of a
contribution or two that should surface shortly.

In the meantime, I've just pushed the HEAD of Linus' tree to my next
branch to clean things up.

Tyler

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJPyVNCAAoJENaSAD2qAscKKGkQAJyO4nTq0+/1GPoQ1eId4p7H
8rt18pi01bm6d51kPMEhYPZWTc2DO3OSmMzU7fX7Pr/nlghe/cNXNV6T3K9Lyacf
s6ktt0w3nr3l9D2Hid40jCYp/+vvin8wYnUbqW6OjGVRecRBHjco6svZTY6vdLhU
xnrh0IejHqZKlBHSbeMsK14jAqlln6sYFOlIQ4SHKsA1b+/8zmkSB6wukcBbARTb
9Iov6otRW0REV44qXaPcKiuFAyAw+NbTXJqwnBFBjooRPdQxuoHbPmHmM6kPEzga
d7xjJVavDscg2UGaXzWwkgX18kvb8Sf8R3UZc2ULAFSZk2L0Kg5Kv9BNSXIX4lxW
qq1EejljihNlRFy/TSkYn7YmU0mYuO8yTkgbh9Rlb2CVdbGD7uh0+z5sRtK3iMIt
dmD+iIzFYsBO6grjiGEHP47OnPLTJnUzMSmArd8NSJtP4/5ksUfsZ2vYr6tgtddn
KzziLbm6cf387sTUFO5H1nSFIP1NyupSaODPHXxfCSOcQnFedKnjd7WcB85iLWTS
yOSIfacLmgWDh1xkirISPV2p1EMnD7TEq7+4gkeQgcCyxu9OacIYT1Ai1OwDPFiQ
Or3/pcE0c96KkhJyJNr0hfaBEHwge2GRkDXV1vOlHnuJJb1vw/yGIEdNbU8TyPCM
GNQHEaU0rnL3s+/55xkJ
=Cf7G
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
