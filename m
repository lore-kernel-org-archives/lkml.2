Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab1IVI0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 04:26:35 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47758 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab1IVI0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 04:26:32 -0400
Date: Thu, 22 Sep 2011 18:26:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Eric Miao <eric.miao@linaro.org>
Subject: linux-next: manual merge of the akpm with the block tree
Message-Id: <20110922182625.4a18ee494a0f3bf977fc8ea3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_18_26_25_+1000_0LA_R4uITtdB8+dF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_18_26_25_+1000_0LA_R4uITtdB8+dF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
drivers/block/brd.c between commit 5a7bbad27a41 ("block: remove support
for bio remapping from ->make_request") from the block tree and commit
4559c71773c5 ("brd_make_request() always returns 0, which doesn't make
much sense") from the akpm tree.

The former turns function brd_make_request() return void, so the latter
patch is no longer useful, so I dropped it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_18_26_25_+1000_0LA_R4uITtdB8+dF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOevExAAoJEDMEi1NhKgbsypMIAIVgrknYRAMlLRVugsY/A2DI
2Xe3gM4Gy1z0Bk6jBTIMt0HCgcEx5G7UwuLE0yr/0W8iQkYYYPnUKR2nqctGg3H1
8Vc8FuTm5ABqAdA2clRc1LnvEQ4zkZzBWZCCWk9Qe0MEA+XMACyah0yaAL9ecuHE
X/tAwBUY0d1nek7eM4lIX+lsj1W/I55G/JSzysf3Djm+poy4B1nzH6ONBIkxGn/Q
c3BUQTgglND3GYApaybc1ljDNxfeOA5Ij3lNXBGCWv+BJHVJaoDS6cxYHTLlOf56
cZup1MQ6x8+xTBQ9Vy/fNm5ZP1PPhTICgIe0CmZitOfLaol7y3cNiQoJ7L+T1eY=
=p9AY
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_18_26_25_+1000_0LA_R4uITtdB8+dF--
