Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab1EIDti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 23:49:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56399 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab1EIDte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 23:49:34 -0400
Date: Mon, 9 May 2011 13:49:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Ma <boyu.mt@taobao.com>
Subject: linux-next: build warning after merge of the block tree
Message-Id: <20110509134931.6d822e05.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_May_2011_13_49_31_+1000_lO1.8BjXEnbWjItp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_May_2011_13_49_31_+1000_lO1.8BjXEnbWjItp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

fs/partitions/check.c: In function 'part_discard_alignment_show':
fs/partitions/check.c:263: warning: format '%u' expects type 'unsigned int'=
, but argument 3 has type 'long long unsigned int'

Introduced by commit  ("block: Remove extra discard_alignment from
hd_struct")
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_May_2011_13_49_31_+1000_lO1.8BjXEnbWjItp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNx2RLAAoJEDMEi1NhKgbsf64H/3o53SDHXBG+ti6EiWpyfwhw
28gXCkX77uymw6A1erPovNcmDcVtSZgfySuBjk+2/XgSqm4wcgSJnm3E5tiAj5vp
Db65jrjUU/pUElZQtOiIHx0JT15X6o+uaGwxVYV3sA6iQT6uegHqCFP1uznPh7jY
95wkW2eZEhiEdyntMMO1bGXD+u5f+rXxh+bVv1GNSJXXVzge5Rqs9RNgcAqfoNu2
DAr4FL04Hl1qRUyz0k+R/SzvOwW0GrWf0pAcJhmJzjCLOZO2FQECL7TRYJOupdgv
Ws1M/xf7v+LDIwoO8+BK9mCv8z2+PZXsCxu83zmRxUOIQ59ax+ivuWOYmyYjOYc=
=DNMg
-----END PGP SIGNATURE-----

--Signature=_Mon__9_May_2011_13_49_31_+1000_lO1.8BjXEnbWjItp--
