Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab2IXWvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:51:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41721 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab2IXWvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:51:22 -0400
Date: Tue, 25 Sep 2012 08:51:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: bluetooth tree rewritten after being merged
Message-Id: <20120925085113.cd17b8e633f38b3f7deefd5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_08_51_13_+1000_lwWJSTcqid3KkFCK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_08_51_13_+1000_lwWJSTcqid3KkFCK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo, John,

The bluetooth tree has been merged into the wireless tree (which is its
normal path to Linus), but since that merge, the top four commits in the
bluetooth tree have been rewritten.   So now there will be two version of
those commits in linux-next (and eventually Linus' tree, if nothing
changes) and this will cause conflicts if there are further changes in
either tree affecting the files in those four commits.

Do *not* rewrite/rebase a tree once it has been merged "upstream".
Preferably do *not* rewrite/rebase a tree once it has been published
(unless it is specifically a tree that is never meant to be stable).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_08_51_13_+1000_lwWJSTcqid3KkFCK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYOPhAAoJEECxmPOUX5FEIFMP/j8uApVxAmniXLyM2tYtXGRi
ifR61Wawy92HDXe3EkqYFKWM+U81PwQgUszkcOP+2kyiK087EzhquTOOLLOf6F4A
7i3kCTljEuxbC1jjSi0m4T5fQt4pRDa3BwHlzsz2Zhu+9tu4l0lr1vz43tUDB3FP
FiNrElbqx/iM8XDZW5sXjyHQNv6DsCNn7X3mzxP2THDC+WCApXIj0TEJbAwbAQoB
i1/rNXUwrllo9OtUG74UN+NZjUxYOyGZvpuB4kUpLg+PLDE0j60q/9Hyx1TTHF3U
+DHrYZb/nKV6ecwMC7sVknVWsUF10lMMwfWmIj5Lw8hziQfzOKy6lLjfhZQk6Wd/
bSjLTVa4wvtGpEC2ItYlsq9Q+XSHacEpGV/k0yRHMWSKyb4xZG1SZvYuyg+gd6np
vQBYseiDzbDsYuR/JYZ1/82UQRUxnXOPlzuhuP4UYBVMU+QXDrpFjQ6ki7UTIa/p
KzIW+8GX0/D4l7gwKWvz/xJsHtmewyTIkF4Qo4QLjevxJ4kwxKrLld5FodDAWmga
Sys3/yOh7X/0+ojujdfbiKMdMDZGBQv5gTlnpm/cOpFRLMdII1/zo8rAlWNcq80L
9mNDxHUiKlF5aQ2/Ksj+6H2qQK3HR576AcU93BMMnYXklWMhrFSjZMzqOctFpdKo
qlMe4zWlNr0XWiXAvCTt
=BGG9
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_08_51_13_+1000_lwWJSTcqid3KkFCK--
