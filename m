Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934420Ab1CYB45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 21:56:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38604 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933857Ab1CYB4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 21:56:53 -0400
Date: Fri, 25 Mar 2011 12:56:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingming Cao <cmm@us.ibm.com>, Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the ext4 tree with Linus' tree
Message-Id: <20110325125643.91510e0e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Mar_2011_12_56_43_+1100_g9Vbag9zgkR+G2c6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Mar_2011_12_56_43_+1100_g9Vbag9zgkR+G2c6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next merge of the ext4 tree got a conflict in
fs/ext4/super.c between commit fd89d5f2030a ("ext4: convert to
alloc_workqueue()") from Linus' tree and commit 198868f35de9 ("ext4: Use
single thread to perform DIO unwritten convertion") from the ext4 tree.

I just used the ext4 tree version.

P.S. Ted, that ext4 tree commit has no SOB from you even though you are
the committer ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Mar_2011_12_56_43_+1100_g9Vbag9zgkR+G2c6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNi/ZbAAoJEDMEi1NhKgbsLAAH/A3ESk24dNt/MufzJ2UKM1Mm
bhPQUnD5F9nuDISZT4pIAJvYRagAUInWkMZHcAxWWvi2r6Y39MkpdKELLjpFdWxp
ZqmxoKk/NQSlTIw3BS2Kjyz19ELrrgmpPQHcvBPyJNE3BqbGATvHgQuJQ80Azw1B
cASftQbj/YWfv6bCFGAafRl5ip4mUmaULoN57lNzrcInI1CncPaXRludNRxTTeY/
FLoINBAbT2IqphPuwHl7wsuuWl7yQ2AtCAP9bAcThYgxtqqKPOM+wS8UkE+HStcT
X0+nN1CHNseUtbXoItb1+mKq3qEaq2BOkrEKZgaZ8R+iUQrZ1UvriN7Yemh3m5Q=
=3mB3
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Mar_2011_12_56_43_+1100_g9Vbag9zgkR+G2c6--
