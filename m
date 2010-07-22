Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab0GVCMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 22:12:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50199 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755453Ab0GVCMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 22:12:02 -0400
Date: Thu, 22 Jul 2010 12:11:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the net tree
Message-Id: <20100722121157.344c8462.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Jul_2010_12_11_57_+1000_icAvp+NkShx5C8Su"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Jul_2010_12_11_57_+1000_icAvp+NkShx5C8Su
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/vhost/net.c: In function 'vhost_net_set_backend':
drivers/vhost/net.c:536: warning: label 'done' defined but not used

Introduced by commit 11fe883936980fe242869d671092a466cf1db3e3 ("Merge
branch 'master' of
master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6") which
kept the unneeded label.  Sorry if I misguided you.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Jul_2010_12_11_57_+1000_icAvp+NkShx5C8Su
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMR6jtAAoJEDMEi1NhKgbsnwQH/j4Fb9LUcVQ/+ST4FIvprO7G
TLE5keUqKQ55pe6Npl8u52SlG41wHzjjVmw16EFWy9zNcbOIWWkjIUFi3PlHuHEb
Crmqz/wiLlDbvwM7qARFE0uwpw6aJa2U4LNSO161lvucuMvk7HFYgMkpKHiGJSUe
gvyZQJbzN7zQeIzONpAU37vXfGdfH473FtwvqricN+P6+3lNOxE2ZyaUc33Xpnq3
GRKkGGKGTfODNV5creopqVU/wnGpFnYTOllGuQNtr+FDxYvb1H8KMAYPiRhkq4+i
w5cXjW02QkHcAuBn9X3ZuSRHEgYRMONgI0Nqzl+eE0sja8AkSyyLLYzGtqy1ySE=
=8Wxn
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Jul_2010_12_11_57_+1000_icAvp+NkShx5C8Su--
