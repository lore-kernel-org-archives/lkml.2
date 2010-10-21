Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab0JUDxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 23:53:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35377 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab0JUDxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 23:53:34 -0400
Date: Thu, 21 Oct 2010 14:53:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (xen tree
 related)
Message-Id: <20101021145326.9f133f40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Oct_2010_14_53_26_+1100_ccG7/drdQyNXLWDE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Oct_2010_14_53_26_+1100_ccG7/drdQyNXLWDE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

After merging the final tree, today's linux-next build (i386 defconfig)
produced this warning:

arch/x86/mm/fault.c: In function 'vmalloc_sync_all':
arch/x86/mm/fault.c:244: warning: assignment makes integer from pointer wit=
hout a cast

Introduced by commit aef8b70e5c4b7753fc4bf20dbb01e93fc8883027 ("x86: hold
mm->page_table_lock while doing vmalloc_sync").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Oct_2010_14_53_26_+1100_ccG7/drdQyNXLWDE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMv7k2AAoJEDMEi1NhKgbsxqoH/A+BsmjjZH9leDEPyfquiFAd
uaMjNLi0/GuzGBHhxoDXqiynqb8KYI30WY+MqyZ0wui29Prlbna1p3eIP8w6XC7n
3DVKw5mUBCFiQ2ugh8t+uluUQlEm01H41oAO12inz9Ga+Zk7hDQydL3zZIIbdjW5
oN/U6XV0/hJYGm0ejctTgBjzxXTFiilB9jT+xSLTrroumfhwspEj/a1iGfxiHxUb
phnLrxai1JmcC7gmRHJsi5PYVtJT0CUn39pK/2hIDJ6Zywrjpo7zgjcQgMpWza5J
qU9F4y7M+zF2e88BB1llCj+6yKj+xWpVHbPaN+euIT3P9jpJBzXgdNtJsIxytb4=
=0+Yt
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Oct_2010_14_53_26_+1100_ccG7/drdQyNXLWDE--
