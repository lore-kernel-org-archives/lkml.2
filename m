Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964Ab1HDE3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 00:29:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51927 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722Ab1HDE3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 00:29:07 -0400
Date: Thu, 4 Aug 2011 14:28:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: linux-next: build failure after merge of the final tree (devicetree
 tree related)
Message-Id: <20110804142858.f7f2f128e5a038beb20aa87b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Aug_2011_14_28_58_+1000_QyBWkUB4CFNM4Sgv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Aug_2011_14_28_58_+1000_QyBWkUB4CFNM4Sgv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

drivers/built-in.o: In function `of_alias_scan':
(.init.text+0x6074): undefined reference to `early_init_dt_alloc_memory_arc=
h'

Caused by commit 750f463a749e ("dt: add of_alias_scan and of_alias_get_id").

I have reverted that patch for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Aug_2011_14_28_58_+1000_QyBWkUB4CFNM4Sgv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOiAKAAoJEDMEi1NhKgbsrBAH+wZkpYjN9+0MZ9ahPtdU1iGC
N2Kxwl8+Q+QRh53wWT3Afvp96Bjg146Uxz6/BsTX8Ks9g3+scCFZ0BMBDltmbobB
zD7o4/NnIaNazJwL4QB0gYMZjWMTjpINAyZyrfECn4HyuA+rwydg65Nrmt8B3r3n
YMh+GNth54ZwtKj3eDLyJCtHhEQ/56Xmy2OLRa/zcrIqnOB3mDR3Bo4YdRrFw+cZ
dn1eBzVXOH2aNDVKVgcn5rUBXTLBxmlLlIJr6IPgMvbxsMeHMHtduCcoSmoU8vUE
0yA3Vc1cXoPMTEGaTcLKPJ3C9zL+fc5v5lIBuiNozgVPMMrxR2Sr8IZi0NnsnUE=
=eKyt
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Aug_2011_14_28_58_+1000_QyBWkUB4CFNM4Sgv--
