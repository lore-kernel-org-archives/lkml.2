Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2BMF15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 00:27:57 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45361 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2BMF1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 00:27:55 -0500
Date: Mon, 13 Feb 2012 16:27:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the kmap_atomic tree with the staging
 tree
Message-Id: <20120213162752.b4207f13fb95d7e4db1b5ba2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_16_27_52_+1100_Y5NEprYJUKZgFg38"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Feb_2012_16_27_52_+1100_Y5NEprYJUKZgFg38
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Cong,

Today's linux-next merge of the kmap_atomic tree got a conflict in
drivers/staging/zram/xvmalloc.c between commit b154ff05e1b0 ("staging:
zram: remove xvmalloc") from the staging tree and commit ea81cfe7d7fb
("zram: remove the second argument of k[un]map_atomic()") from the
kmap_atomic tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__13_Feb_2012_16_27_52_+1100_Y5NEprYJUKZgFg38
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOJ9YAAoJEECxmPOUX5FEgR4P+QGnG4KbgKlqoSdDWvYxjFOY
cnXYvLWg203w3ohnfYvG9XIWQ37u6qUn3fGyuOjOOx19WucO1zjXSsJUJMugS9jT
VvM+w7yFs2OaTJtvn6I7FOLAdI7L5ihuBMdY9WLXFifYlN0zQyQUcYku4SVtCEuK
OXNHtXdPqSi5UwO+R8uIgVaF1vK6z/TtlAOGEet0FVOHwpwGESbSaMO8SPnML0x7
2g1+mCqxyMsNK7Ztg6MBVmuTI8rX48kl3zvzirIk5UjBXrmoLGAuNyXYW0KNzHv8
tj2HFdghoVDWe+AFcqNoAFHwgwc4xoyFYHycWQMDtjjUt7f38wovDU0s7foaKdHz
d0i05YKDr+o1O620pHpF/JimGjmk2KUKnHPzZBZW/H5tV0TQ6rEWMqmVyzWly/iE
0YquSQ9e5cDnBaLpUwTUs/+iDyHRUYr1h6+/vF87ldAsIUjug4iMYn4Vfgy1naT7
Rl/h5YCsW4M3hQfY0/hDgjIAPMWjwu+r1dLzR2vvI1kFkCluKorwrchvQdVudS8s
9DJnXM20O1/+VyZ+mwJ2p8HqZkoRLdeVkgQ+0HBCtMxhOBjCN+Tg+L4/0gJ0wX/l
3F6z3wBwLHRrhzbwtbL1WNY9YW2qx0pejGTYLlFNBywyYyj6T1ZWGU8GD5+/GQNj
herFsa88EYQxx0FFK8jx
=8m1w
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_16_27_52_+1100_Y5NEprYJUKZgFg38--
