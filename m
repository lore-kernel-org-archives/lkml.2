Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab2ERGGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 02:06:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab2ERGGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 02:06:09 -0400
Date: Fri, 18 May 2012 16:06:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, David Mackey <tdmackey@twitter.com>
Subject: linux-next: manual merge of the edac tree with the trivial tree
Message-Id: <20120518160603.0eddece830f829d3b8570ac7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__18_May_2012_16_06_03_+1000_IRBnDf43jbRFUVkm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_May_2012_16_06_03_+1000_IRBnDf43jbRFUVkm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the edac tree got a conflict in
drivers/edac/edac_device.c between commit 15ed103a9800 ("edac: Fix
spelling errors") from the trivial tree and commit b9e889c84229 ("edac:
rewrite edac_align_ptr()") from the edac tree.

One of the comments fixed by the former is removed by the latter, so I
did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__18_May_2012_16_06_03_+1000_IRBnDf43jbRFUVkm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPtebLAAoJEECxmPOUX5FEnTUP/RBySZAvAOBxU2G5MZvcxBh6
6xXNRa0obL6kygqYdSi9lcntC3XjMBbtBY4gdoj/XIN0R6rAi4pgicXxb2jHl56Y
RrQzVFfRufww7QlvhpoCni2IekY8bsCq5DVfMxlTUyg36f7LrXLiNkpAKdGyKY75
rLoNgC8z2yfhY6rSg8VNKnNK++6yqb8Odb5Pf7wwVZyEM2ZfSq95znCuC6jf33Pw
Spf7reXioWlkyHDNra/pFccQDIxwOoyLPQxnaz/XTN/DwP+Jd7eO5n4wOvI86pZz
ZNxjYJ4h6YSbeIQtb+E22wkgHPVw7VspBfo6dOR+KHL6gfJqmpgyvcGu7mcxFZjJ
V42iAfLsfA2mimpa1D/GLhywrYb+trUvYLS37SUpcIDIgR3yC6VOJZWmA54Edgby
r5PUzt6V81u+YPYLWbADmoklgzgoOwNVaCGmV0nUo6JXf+IM1ya4fP9I4TKDCbKq
VRKnTztllPupaxmqdQ45iBnvephywURAWntDalHtqWJPblBTMlDBaCoiRjwUCPoZ
6C9VkD2ii7lDVsfBct0vfAtEP5fXSopu4HJJtx3YEIIZ0ig5YYeghtwmTVeCPdiI
JKyJkzKXJyV42O7k1+OBTyMmSR4OrnHgzQ8oDjWSAtTO9j8uB8ZxJWToENUH1R8n
rX3nCtN97MPBEjdHaiZ8
=M+WJ
-----END PGP SIGNATURE-----

--Signature=_Fri__18_May_2012_16_06_03_+1000_IRBnDf43jbRFUVkm--
