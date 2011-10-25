Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1JYJCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:02:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33255 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1JYJCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:02:24 -0400
Date: Tue, 25 Oct 2011 20:02:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Nathan Fontenot <nfont@austin.ibm.com>
Subject: linux-next: manual merge of the akpm with the criver-core tree
Message-Id: <20111025200200.e3137b6d51d20fdb00a3c051@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_20_02_00_+1100_=zvh.zm8SG6WVRoL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_20_02_00_+1100_=zvh.zm8SG6WVRoL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the scsi-post-merge tree got a conflict in
drivers/base/memory.c between commit de0ed36a3ecc ("Revert "memory
hotplug: Correct page reservation checking"") from the driver-core tree
and commit 587c3cc717df ("memory hotplug: release lock on an error path")
from the akpm tree.

The former commit reomved the code that is updated by the latter.  So I
did that.  Which means that I effectively dropped this patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_20_02_00_+1100_=zvh.zm8SG6WVRoL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpnsIAAoJEECxmPOUX5FE3vkP/i+uArq/SPFXA7Iljr5AtGQD
T5k1/+ZquH2MCV9qO9M1saSy2UK/+tJAFZXAysc5FcfHyohKSDvs5aWomZ5uuzhE
QAe3fS+l6c3Qi+eqUHiVjc/tzuWF5BHGhiHt8CAtLmdA6y1Uo98Mzb0hPuD3Q0f9
kfgDpI03Q+2TYukcSjFnKtxgw9Rq6YmK3MafdQR2PXaAUDzHQGApcrXJJVoc4nf7
5gpaTfgFM2OHZR2Mp9UpAcUcQbxyZ3rqWoJDN/6e3zl6A2JUa1J6deqko2g8Ko89
iWfuM3ssOJBBm3V3KzUThJf1L65rLyNjeefFggdMArgCib8bb+hJJTtPobzSgceC
91BTQVlTY9Y7fEBzfLmpzbCFTzVO0o3i623CaeEVfG655IgOwImpn2l9Z4hjb/PA
hqsafVgRIQRnrhDYaOqd6YpESk8bc7+YObWHJ6OjZlWDeN+qby351yQf2IMAvsTp
U0NGrg86b96opjV684wnUzUvBurXcaVAjP7Fu/b9UuLYjbJScG3qaJCA7835gu59
5BUhPd8M077vTevcwqgeTsYuCn+3eYdC52kiyWSgJwK7bO71fla4Gf40z2a/KQzx
c6xqRDte05OtuwX/d3rKGzQf9z2vgZ8ktsRI+EzkVZzjfE2V9B/pryYTIS9ru/ID
DrIG6+pY9xelRwb4RPGE
=G/If
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_20_02_00_+1100_=zvh.zm8SG6WVRoL--
