Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab0EZFPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:15:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32909 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab0EZFPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:15:41 -0400
Date: Wed, 26 May 2010 15:15:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus <torvalds@linux-foundation.org>,
       Ralph Campbell <ralph.campbell@qlogic.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20100526151534.504a74f7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

drivers/infiniband/hw/qib/qib_fs.c: In function 'portcntrs_2_read':
drivers/infiniband/hw/qib/qib_fs.c:203: warning: 'counters' is used uniniti=
alized in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'portcntrs_1_read':
drivers/infiniband/hw/qib/qib_fs.c:192: warning: 'counters' is used uniniti=
alized in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'portnames_read':
drivers/infiniband/hw/qib/qib_fs.c:181: warning: 'names' is used uninitiali=
zed in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'dev_names_read':
drivers/infiniband/hw/qib/qib_fs.c:160: warning: 'names' is used uninitiali=
zed in this function
drivers/infiniband/hw/qib/qib_fs.c: In function 'dev_counters_read':
drivers/infiniband/hw/qib/qib_fs.c:149: warning: 'counters' is used uniniti=
alized in this function

Introduced by commit f931551bafe1f10ded7f5282e2aa162c267a2e5d ("IB/qib:
Add new qib driver for QLogic PCIe InfiniBand adapters").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8rnYACgkQjjKRsyhoI8xEdgCfeIwhGUzl5BV3TyaZfgOUD2yv
REAAn14Xe95eJdOImF5og0gXNw/Fg/wz
=jf2m
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_15_15_34_+1000_iBQx9.0MHt0CNOER--
