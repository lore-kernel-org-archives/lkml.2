Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab0D0EsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 00:48:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33430 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057Ab0D0EsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 00:48:17 -0400
Date: Tue, 27 Apr 2010 14:48:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IkZyw6lkw6lyaWMgV2Vpc2JlY2tlciI=?= <fweisbec@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vijay Kumar <vijaykumar@bravegnu.org>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the bkl-ioctl tree with the
 staging-next tree
Message-Id: <20100427144804.cbfa9564.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Apr_2010_14_48_04_+1000_jKdHnjIORDf7XFCN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Apr_2010_14_48_04_+1000_jKdHnjIORDf7XFCN
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fr=C3=A9d=C3=A9ric,

Today's linux-next merge of the bkl-ioctl tree got a conflict in
drivers/staging/poch/poch.c between commit
ba7d84da197c348efa2b2984a848e0fbccd4b9b0 ("Staging: Remove staging/poch")
from the staging-next tree and commit
1dd97d3d546aa14db7efa5366b21d1336b91379e ("Rename 'struct
file_operations' 'ioctl' fn pointer to 'bkl_ioctl'") from the bkl-ioctl
tree.

The former just removed the file, so I did as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Apr_2010_14_48_04_+1000_jKdHnjIORDf7XFCN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvWbIQACgkQjjKRsyhoI8zRugCgu22pMBWZAxbeBaa1/xieZ2L8
iXIAn1h7VO4mIKh35kPLJheZ5jvyjhIb
=ld8o
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Apr_2010_14_48_04_+1000_jKdHnjIORDf7XFCN--
