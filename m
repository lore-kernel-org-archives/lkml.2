Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2GRG76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:59:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40298 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2GRG7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:59:52 -0400
Message-ID: <1342594461.31927.9.camel@brekeke>
Subject: Re: [PATCH 0/5] ubi: Fix bad PEBs reserve caclulation
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>,
        Richard Genoud <richard.genoud@gmail.com>
Date: Wed, 18 Jul 2012 09:54:21 +0300
In-Reply-To: <20120717102333.26cb10fb@pixies.home.jungo.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	 <1342452837.7270.15.camel@brekeke>
	 <20120717102333.26cb10fb@pixies.home.jungo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-gCT1bM7wyGyKRD97ohmA"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gCT1bM7wyGyKRD97ohmA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-17 at 10:23 +0300, Shmulik Ladkani wrote:
> But it would only make sense after accepting Richard's patchset as well,
> which suggests configuring per-ubi-device beb limit via the attach ioctl.

Yes, sure, you are right.

--=20
Best Regards,
Artem Bityutskiy

--=-gCT1bM7wyGyKRD97ohmA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQBl2dAAoJECmIfjd9wqK00lMP/00D5rELb3GzXlhij1zpWkFV
WjbPs/JjdiBl+ilM8ZzkLWc8wyJy6ebtXrvGhRNErkHjecW3+9o3l/3xu7wlPX+k
0w3sP0Vq5/MQprI53besEkb4QI0lQLIdfbZzz9T1sOhu7tozM39nm6s6kwVkH0Q/
B6Uyg1s/J2SxFj4f2tP0ZVli4mX+lSb0+pcyDihIZLJU2EGuc+9XjM/tssvBjLZh
qTLfEhOIExZl2nqn8M5nI70MFKyJvfn0d7wR+4PxnmjDHhguG65Ozhyqs37ie3vx
OeV1wJndxry6fyOGv6PFtMrpgcNJSsfh3VstlhSD1jEpf5E4ISi5krxSauh6p/1P
nNxUOVAg/l43O6aSzV/4DZxiZnzH1D8ECIzHfww34RvPUZtd2ppM1xOTbh4+0WtO
aAm5CTe4Ge+HaVxjYq4AKCXy574XDDrjX5kF2mNa76jy1egarovmHXikbXjQayVq
P3YSDFpFD7XBVH+rvQHmfqsJmOPC/PEti3P8wyK89zBXvYBZfPAiv7v5KB4YqDsJ
rvFj0Tr6Bu2ym00WpoxLIkskp+/rPJc6gWNw9lwqdIM9IywTIC6FkLkt449htQ2P
Er/oNH7bgyUvS9jCZCu5ffOzW/GCbGMd9/FPL1ZIDvTtUSkg/R0EUqAjtJDXlAh9
2OzIjvZ9cw4C20dXx0M/
=R+25
-----END PGP SIGNATURE-----

--=-gCT1bM7wyGyKRD97ohmA--

