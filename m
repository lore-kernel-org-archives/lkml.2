Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab0LVXwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 18:52:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41382 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab0LVXwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 18:52:36 -0500
Date: Thu, 23 Dec 2010 10:52:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the vfs-scale tree
Message-Id: <20101223105227.5760a331.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Dec_2010_10_52_27_+1100_NMml1cNz5o6dNZ+g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Dec_2010_10_52_27_+1100_NMml1cNz5o6dNZ+g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nick,

After merging the vfs-scale tree, today's linux-next build (x86_64
allmodconfig) produced these warning:

fs/ceph/dir.c: In function 'ceph_init_dentry':
fs/ceph/dir.c:45: warning: passing argument 1 of 'd_set_d_op' from incompat=
ible pointer type
include/linux/dcache.h:235: note: expected 'struct dentry *' but argument i=
s of type 'const struct dentry_operations *'
fs/ceph/dir.c:47: warning: passing argument 1 of 'd_set_d_op' from incompat=
ible pointer type
include/linux/dcache.h:235: note: expected 'struct dentry *' but argument i=
s of type 'const struct dentry_operations *'
fs/ceph/dir.c:49: warning: passing argument 1 of 'd_set_d_op' from incompat=
ible pointer type
include/linux/dcache.h:235: note: expected 'struct dentry *' but argument i=
s of type 'const struct dentry_operations *'

Introduced by commit 08726ff2deede1a5ae5fdfd0092538f01f22eb19 ("fs:
dcache reduce branches in lookup path").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Dec_2010_10_52_27_+1100_NMml1cNz5o6dNZ+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEo87AAoJEDMEi1NhKgbswSEIAIqebDxWyIEC4AMPt1VAKzJ1
ZQanEuSP3o1rQ5dl8oQ98eAeWGAmMHUpQS8SRV+u8M2mU3ilyuGZJJC1+ubPnOlf
RR7YO2eAY8PuptutxJqL7GPU1bQMoOnoUoTzez2lqBlF7guGiGLrE+g3hooOPXol
ZWn20PL95aFvV5/66qhQN89hNPWJm+Hxu3I9jrFzX+gk2DoKzw4KsBVtN8naXYP5
Qf0MWujq8LK2wZqQWgNabANUpa/L59pILXTOkT7AHatGs1tcLtfdsDOBwtvwYVBC
cuPbHHSRV1SbXKA/i/0wtl1p5n71ov0lmBfH/XKEyVBnMzEopMM9WQTH+shGRg8=
=soUB
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Dec_2010_10_52_27_+1100_NMml1cNz5o6dNZ+g--
