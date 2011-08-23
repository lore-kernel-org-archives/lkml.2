Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab1HWDwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:52:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53227 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab1HWDwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:52:46 -0400
Date: Tue, 23 Aug 2011 13:52:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tiger Yang <tiger.yang@oracle.com>, Joel Becker <jlbec@evilplan.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the security tree with the ocfs2 tree
Message-Id: <20110823135237.b2dcfdda5d3e0b6631997d36@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Aug_2011_13_52_37_+1000_RhvI1NDVh8.MZcWk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Aug_2011_13_52_37_+1000_RhvI1NDVh8.MZcWk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
fs/ocfs2/xattr.c between commit d27fb6a99c41 ("ocfs2: free memory
allocated by inode_init_security") from the ocfs2 tree and commit
9d8f13ba3f48 ("security: new security_inode_init_security API adds
function callback") from the security tree.

I assume that the latter supercedes the former, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Aug_2011_13_52_37_+1000_RhvI1NDVh8.MZcWk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUyQFAAoJEDMEi1NhKgbsqfoH/ihjDsDgZ4Q9+6CtSaLItDaB
q5nziJFMZTqO0uwKHApEq5FvUey1TdtCQ7XizItoymcMkbvcjPoqiYmG1dkB8ino
Z4uKjUOkXokfmed0f3hIewHI1JPb3jBmccP9KsagBXlyF4vO4OrZLIRcZUM6g59w
KjGtq2QLA/8fSzfFeEbRaDS4nOfD4XK+S4mqPeZsgvLJ0A9dNA+j6RVo0tgZ/Rh9
Z7YYSHSOZZKpoDzfhMk8C98k0hWJAAITmwH1zC67gcgfEQcN1Em7ShE8LSSjiJ8w
jUz5i0c6OC74cGKGksYJ9hpwO3CMoaPvQuy3UX35NQ9zixrKvR+lvmLcBsvOT24=
=FbCD
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Aug_2011_13_52_37_+1000_RhvI1NDVh8.MZcWk--
