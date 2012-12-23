Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637Ab2LWWEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 17:04:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42874 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2LWWEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 17:04:38 -0500
Date: Mon, 24 Dec 2012 09:04:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: linux-next stats (Was: Linux 3.8-rc1)
Message-Id: <20121224090426.99ba9400c9097f5567dfae0d@canb.auug.org.au>
In-Reply-To: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
References: <CA+55aFyd0Wk=hPqiRmk5MMnrwPhse5k1Aih9P-j-Badr7kwhbw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Dec_2012_09_04_26_+1100_1XZER.hy_ggNzuzL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2012_09_04_26_+1100_1XZER.hy_ggNzuzL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 21 Dec 2012 18:00:58 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> The longest night of the year is upon us (*), and what better thing to
> do than get yourself some nice mulled wine, sit back, relax, and play
> with the most recent rc kernel?
>=20
> This has been a big merge window: we've got more commits than any
> other kernel in the v3.x kernel series (although v3.2-rc1 was *almost*
> as big). It's been a rather busy merge window, in other words.

Well here are this merge windows' stats:

(No merge commits counted, next-20121211 is the last linux-next before
v3.7)

Commits in v3.8-rc1 (relative to v3.7): 10901
Commits in next-20121211:		11857
Commits with the same SHA1:		 9322
Commits with the same patch_id:		  492	(1)
Commits with the same subject line:	   99	(1)

(1) not counting those in the lines above.

So commits in -rc1 that were "in" next-20121211:	9913	90.9%
						(up from 83.5% last time)
Commits in -rc1 that were not in next-20120722:		988	9.1%

Pretty good, but it would be still nice to figure out where the last lot
came from.  I have the "git log --oneline --no-walk" list if someone wants =
them.

Some break down of the onelines list:
	grep for drm gives 100
		 btrfs gives 117
Quite a few of the rest appear to be bug fixes.

As for the 1944 commits left in linux-next ... 1303 are in the kvmtool
tree (most of these are in the tip tree as well - this has been pending a
merge to Linus since before 3.2 ...).  There are another 254 commits in
the tip tree (maybe pending fixes), 118 in the xen-two tree and 81 in the
drop-experimental tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Dec_2012_09_04_26_+1100_1XZER.hy_ggNzuzL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ13/qAAoJEECxmPOUX5FE3G8P/0+GH3eUcMS0ja2I9/FIGSrg
5p46w20Bwsyq+LqQ+U4Jiupq8Do2yoPeJweTN4d7HIYohzE1+MsGzG72EC8DUkgD
+Q1cf9/AnXWkvaNcorpB8I3k7H7tWNByAbHBaGHkfi7cHj70ucN5kiMViBdWfImF
kPc7Fgh1Itwtl1eXhcBjSZhpVpJKOmf8Eg2+xvXBB2nC255o4SC7K7ZYyW08USou
rvLqSPSnoZeWeKCF/kO7CSe+7SEjfXI4rTySCVozYIQHdXFdXP64m/HpSaF6nsP5
gOs3fGkbEKHEMAQUXYyyyikfiVnTecfNYpacMwVgZKxe8+zMVsF5f2ISMEqbMSVU
aSjGWqlPjV6ydKjzb/iPh3l+HS9cqbAKun0Z8TTh1rNnpvy3Z8N5Oxi3O3quAcJO
gZFhvynq+yJTcinzw3KQk6efTYlDYxnohCNC4N7EoOTxfPKy3ycU5O7r9UvXBgAi
Fx186Mzrl2wmlgKJJKOZgCfUXOjLoU3ozNPgBXOYXHZFaQE7sr9TGnQULWiK7LeH
Q7iQXCmfFe1yGwhfgJ5zc1kHfzZCSJsIaPOQHAbgyEJWHB10qyo5vyWETCF4hMSx
y3O6s9xFxaHSEE+d8a/b5Mq3PLBxvoYtMHt1gPRZAdoet8u8rPyU/ytGXXphkBbO
/1KekHRnj3MCmdMTQtZZ
=uupe
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2012_09_04_26_+1100_1XZER.hy_ggNzuzL--
