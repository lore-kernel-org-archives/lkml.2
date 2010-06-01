Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0FAGBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 02:01:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49741 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab0FAGA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 02:00:58 -0400
Date: Tue, 1 Jun 2010 16:00:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: linux-next: build failure after merge of the hwpoison tree
Message-Id: <20100601160050.91404d78.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Jun_2010_16_00_50_+1000_xsnyU_jkT4ionoZc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Jun_2010_16_00_50_+1000_xsnyU_jkT4ionoZc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

After merging the hwpoison tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "PageHuge" [mm/hwpoison-inject.ko] undefined!

Caused by commit 0bfc18afbf46bf2d93d55ec64501fff17067a1c2 ("HWPOISON,
hugetlb: support hwpoison injection for hugepage").

I have used the hwpoison tree from next-20100531 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Jun_2010_16_00_50_+1000_xsnyU_jkT4ionoZc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwEohIACgkQjjKRsyhoI8w0MwCfZjlGCblNEkwJrFVn1IMb4Cvy
RJgAoJBd4QRosd9D/OscBFohzZ6HCdC4
=GA01
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Jun_2010_16_00_50_+1000_xsnyU_jkT4ionoZc--
