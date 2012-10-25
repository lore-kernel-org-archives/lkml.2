Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab2JYDf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:35:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33905 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812Ab2JYDf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:35:56 -0400
Date: Thu, 25 Oct 2012 14:35:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>
Subject: linux-next: build warning after merge of the akpm tree
Message-Id: <20121025143554.5633fd6d70fe9320e29bac8e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__25_Oct_2012_14_35_54_+1100_q_/v89cgco/9J5Bw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__25_Oct_2012_14_35_54_+1100_q_/v89cgco/9J5Bw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

mm/rmap.c: In function 'try_to_unmap_cluster':
mm/rmap.c:1364:9: warning: unused variable 'pud' [-Wunused-variable]
mm/rmap.c:1363:9: warning: unused variable 'pgd' [-Wunused-variable]

Introduced by commit "mm: introduce mm_find_pmd()".
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__25_Oct_2012_14_35_54_+1100_q_/v89cgco/9J5Bw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQiLOaAAoJEECxmPOUX5FE5dUP/03oTnUlbDR5r7tgQLn9Bbig
i/TCFBBUz7vHeHDIJvavApgKWW3e3kRkrEoGYYU7tCN+o9JQ940LG7H58XsAR+AV
ijwDpy3qvA6bCvsU1LJU9OYWTQTj/l81hhOE1V3/Cn24v6ffNXKImbUsqdBf4nRU
QL1TBEquL2lEsvkAjz4gCoPynL3Iin1AP4Cl4m3mGn93SdwBVBI3a0T9le+qoWCO
sImni7cO83qlKasKaFKnDZ2rf75Sqtr84f49x8/ziCB5Xd6Kryu0l5k2wUZQF9px
WA3ybRb1huuob0qL9RPzwxNcN6aBDOvV55gebNSK82yyRx84vbCAQKm7clFVBSOn
AjT0S+0yjdaWQkeHONjmlN2kpQo7S8tXBlIIutGd952nS4N6OyGM9wBGkC5H0Od7
v2OPizjcLADKhs3ZRxlp6CKsxpYrm+jr2dOfbuGPeVkXgTWfyr+RtC+W+8Q5/PcQ
DntOwmIcCsG4yDv5zrV4jyl6Nf3Jesg2FG7S3rn0AV0ICnHSaN6lB1SYZeb7j4Ua
kCo8M8iBlXGmLFmRJVYLg+6n6GX97pknJ5I1RB8UjQvMHEFLfDl0NIHpzhog9m+u
BgWK95qmHwiT+GjsRbTM8SPRdJUEQl0CLVWrmQvC5Bw3hoKlWHzmCHQFIq9F9QSa
zki+FLYXZu1yVCh7pY01
=AXaH
-----END PGP SIGNATURE-----

--Signature=_Thu__25_Oct_2012_14_35_54_+1100_q_/v89cgco/9J5Bw--
