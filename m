Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2LSALK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:11:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59952 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2LSALD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:11:03 -0500
Date: Wed, 19 Dec 2012 11:10:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>, Takashi Iwai <tiwai@suse.de>
Subject: linux-next: manual merge of the modules tree with Linus' tree
Message-Id: <20121219111053.345900e0b35ee8f4def990a7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Dec_2012_11_10_53_+1100_BCRepUOoIc.soa7u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Dec_2012_11_10_53_+1100_BCRepUOoIc.soa7u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the modules tree got a conflict in
kernel/modsign_pubkey.c between commit 84ecfd15f554 ("modsign: add symbol
prefix to certificate list") from Linus' tree and commit bb8f5966421d
("MODSIGN: Avoid using .incbin in C source") from the modules tree.

I fixed it up (I just used the modules tree version as it removed the
section of code modified by the former) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Dec_2012_11_10_53_+1100_BCRepUOoIc.soa7u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0QYNAAoJEECxmPOUX5FEyt8P/jZJxKDH8CwKakFUZG63XCPg
5yMAXmSPiNG9wbfbEf61V13fJHApVb2FGtQ/gDzc2dHWtayPFGsxDP6/+VnkxcUO
iqj1nfZzxzLQAgQ5HhyjYr5GmskA9HygetwTVHRpMEImfI+7P7ytrxFz0NI0/czE
C6wqhX1+mc11XxFIGU5qtdquOYy8hJetE4z12u23rJZLXHnQYne6EQFKikYhBe21
TFvWCxWZ24YxGeV5sjwi4qgtIsF6hvBUNdg52zzSRWbJlWuIiN2PWHkwbDP0Cf3m
98SmSmO+7DNGjCLBLstvUpMJ2xFQSnuqSCJDSR7azdmZj53O/cdHdquWk6MTa9qM
YLW3L2StsJVkZI6N+sf5IHdWNd/noZmQBxh8vRiS2DOZGSastGxkLHy64kbi9SCx
JTgM2x0DMA7749y2cAB1BtDxMMCM+2OPKZJVhJKgG7rwBcOXSrzAr6k+NWpar04M
WWRl+jjC50QOlF8sUhwy7PAyvR/Sbhym1kh9e54KHNYZ3gxkDlqh4JxscLLxTDHf
w5rVqHBk1l0XeWDsoqUltR6CQDckGEaid5yUUQ4JPlXS0nZdY4qa2xvUiSX57dE8
3iYBGWfcLt9HRC9qts2sWWYXXnB10ojcQNavuB6ZLFlE1kMS02PmqSl/9blIXWia
hmwoy43+lViH2sfayrOb
=5vxX
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Dec_2012_11_10_53_+1100_BCRepUOoIc.soa7u--
