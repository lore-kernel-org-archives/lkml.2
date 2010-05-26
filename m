Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933885Ab0EZBx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:53:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55147 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759170Ab0EZBxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:53:54 -0400
Date: Wed, 26 May 2010 11:53:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       matt mooney <mfm@muteddisk.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kirill Smelkov <kirr@mns.spb.ru>
Subject: linux-next: manual merge of the kbuild tree with the kernel-doc
 tree
Message-Id: <20100526115346.da5a02aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_11_53_46_+1000_IM.Sp9/LYbNxzOel"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_11_53_46_+1000_IM.Sp9/LYbNxzOel
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

Today's linux-next merge of the kbuild tree got a conflict in
Documentation/kbuild/makefiles.txt between commit
74bb7003010ff0998e280a6ade09381168ff20ec
("docs-kbuild-make-examples-content2") from the kernel-doc tree and
commit e8d400a933fa44e2fba3849b084e1ae5814d7fca ("kbuild: fix a couple of
typos in Documentation") from the kbuild tree.

The former also fixed the typo, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_11_53_46_+1000_IM.Sp9/LYbNxzOel
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8fyoACgkQjjKRsyhoI8zA1QCglfMxECVcFG0fS3VacWMMUz/B
lEoAoLduDtPDk+G3TE84q5LjvO59bkHm
=ayRv
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_11_53_46_+1000_IM.Sp9/LYbNxzOel--
