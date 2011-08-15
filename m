Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab1HOFU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:20:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40235 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab1HOFU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:20:57 -0400
Date: Mon, 15 Aug 2011 15:20:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the final tree (net tree
 related)
Message-Id: <20110815152048.3b8f8484faf1891ef2fce266@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Aug_2011_15_20_48_+1000_sj.gc6QjjrsJyLO7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Aug_2011_15_20_48_+1000_sj.gc6QjjrsJyLO7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

make[5]: *** No rule to make target `drivers/net/ethernet/toshiba/ethernet/=
sun/sungem_phy.o', needed by `drivers/net/ethernet/toshiba/built-in.o'.
In file included from drivers/net/ethernet/toshiba/spider_net_ethtool.c:28:=
0:
drivers/net/ethernet/toshiba/spider_net.h:30:39: fatal error: ./ethernet/su=
n/sungem_phy.h: No such file or directory
In file included from drivers/net/ethernet/toshiba/spider_net.c:54:0:
drivers/net/ethernet/toshiba/spider_net.h:30:39: fatal error: ./ethernet/su=
n/sungem_phy.h: No such file or directory

Caused by commit 8df158ac36fa ("toshiba: Move the Toshiba drivers") or
the surrounding commits.

I have just left this failure for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Aug_2011_15_20_48_+1000_sj.gc6QjjrsJyLO7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSKywAAoJEDMEi1NhKgbs9oAIAJMNG3nRuYhoE8dw1BxFhW2S
rkbXMrScxhCURomXgX+Gx/hKwhtiEGFfFaHh1lD5PSe95CBH5WUDHRojvJITk/ns
g4xQk00LKZvwKihgGPKOpnvG1wIDcKVC0Gu3XdHVxf3eAR4chbPLSh7pjn13xys9
c1sjd5d2mywPol8s/0eCrBo9U6iUfAX0293KKlZDaOGdygF+DriC5VpZQChmNrQz
RC9orrMEb5dZ8dxMwJdSl+dznIwF1igyN5jHqJPQqZL5AdupJxif50jcF/j8eVIb
ljZpCqScvSgE9LphES2RnXFbIPe0tLDWZQPS93t9TRiG14m2RfIIgxoJT5KEWiA=
=8biw
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Aug_2011_15_20_48_+1000_sj.gc6QjjrsJyLO7--
