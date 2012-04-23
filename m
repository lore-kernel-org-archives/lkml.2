Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2DWDmX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 23:42:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45628 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2DWDmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 23:42:21 -0400
Date: Mon, 23 Apr 2012 13:42:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20120423134211.3456f8acf83dfb3d38d44905@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Apr_2012_13_42_11_+1000_3mNhX1g.A42QCeez"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Apr_2012_13_42_11_+1000_3mNhX1g.A42QCeez
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "vga_default_device" [arch/x86/video/fbdev.ko] undefined!

Caused by commit 49c33b97c5f4 ("x86: Use vga_default_device() when
determining whether an fb is primary").

I have used the drm tree from next-20120420 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__23_Apr_2012_13_42_11_+1000_3mNhX1g.A42QCeez
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPlM+TAAoJEECxmPOUX5FE6IsP/3Nr5KyV0OC+ze15XkhyWqQ9
g2e+fQWjQCNkKg0vN8FYk1vi17RCWRleI0fEqts2KYhiLJK2tfaGvzrVqDPspR/8
hr3MlHCF4xM+rrpy44rkuH98Pb2U61VcQyxM8HocjYWoqSZhZrrQRseJf794DDyH
L+RGlxQcHpNCeTnOr/A6PgyX9+nt1LkEBFenAhqUk+cjFoPgzL9NOTqEkYayXo9w
FuorZ/ZSXEZfOO/l4L7EXnHY83qBGM61V+SJtZjTewg5oNSEZ3JaiOjnfLvR904h
Qo8fHJ6FngVE7ZrU9CD1lVt53QZ35GSQr0j67VwERf4eKAoqOTdBC1og4UJclQUn
Y4WTk2diIo2zFb9qJ/mar7oCJt9cuvxCk+1tnxvcS2GZ9195S9PsACxdGd/7Jxab
GEt1qzVr8pTDNMTLjPLjo+fmwfwT+vqgN1H65oKip0n3n+AhLYaQazgtmeaTAiI2
BXjYIS3F93gXyNgtCCTuvv0ILyfa4r0KGB6N1K/cbUI30eycWZc2yg0ENuLBUkcn
gX85dH+jKAlXhr/HV0exryivfFc1OwbWYmvWVL3CExPT+s4ktDwWlm8LKPksn7yZ
tAr4+ZjeSSRrcF+9vSNNYDHRNSGishKLU4Lf3iTpwR8SXLDi0xF1hDQualnxhorf
jiD3iM0B80T+eGGdD/am
=Sj0f
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Apr_2012_13_42_11_+1000_3mNhX1g.A42QCeez--
