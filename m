Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab0LTBdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:33:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35835 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab0LTBdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:33:41 -0500
Date: Mon, 20 Dec 2010 12:33:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>
Subject: linux-next: manual merge of the rmobile tree with the
 rmobile-current tree
Message-Id: <20101220123329.be4093ad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_12_33_29_+1100_ef1ooMg3phHIL/rj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_12_33_29_+1100_ef1ooMg3phHIL/rj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the rmobile tree got a conflict in
arch/arm/mach-shmobile/include/mach/entry-macro.S between commit
1cf215a5b43950d1a304373037828158057ff9fc ("ARM: mach-shmobile: INTC
interrupt priority level demux fix") from the rmobile-current tree and
commits 6d9598e24d50a8c72f48a3864327484a30aaee44 ("ARM: mach-shmobile:
Initial AG5 and AG5EVM support") and
45bbaae0dcddc275594e23f108cb68869eae7433 ("ARM: mach-shmobile: Split out
entry-macros in to GIC and INTC variants") from the rmobile tree.

I just used the version from the rmobile tree and will leave any fixup to
you.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_12_33_29_+1100_ef1ooMg3phHIL/rj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDrJpAAoJEDMEi1NhKgbsdXIH/1hRT9phmUbtA39NHu9uuXdx
WJiYn2ZTyY3NAXDKCCqnEEkpz7hm/sFe+VqANfYjcsPTqPR1MH8MhHxuOsbCQ9Kq
YltKSYVAv9bajBhmYoyqn0bakLZ5iB3WZYvQlNXGna1ijKdSduNG+l8OT0J9IJJp
Z9VI1jqw6lXrmwUz/lPVenvJX59VgxSw6yGIXhe56fN7rljgkVR8MYKmmARVqWNI
0S8BbIzRW2mKspGAKCMHYsBug7FJyqcQR9u1/k9l1fu+vfigwhSh6YSA29nBxMc9
HTtr/DKVUZko9Ax0YAWylvM/3t6l3GRMnIr3RS6KuGbgXMiy62JZ/INXgs3guDM=
=uNTy
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_12_33_29_+1100_ef1ooMg3phHIL/rj--
