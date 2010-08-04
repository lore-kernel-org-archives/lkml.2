Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0HDBcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:32:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34731 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757956Ab0HDBcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:32:21 -0400
Date: Wed, 4 Aug 2010 11:32:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the nfs tree
Message-Id: <20100804113214.62913199.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Aug_2010_11_32_14_+1000_0W/C=q.m31.J5a=T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Aug_2010_11_32_14_+1000_0W/C=q.m31.J5a=T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/nfs/file.c: In function 'nfs_file_flush':
fs/nfs/file.c:211: warning: unused variable 'ctx'

Introduced by commit 7f09dcf61bc211b0a71a5caa15ceb9b7bbec2126 ("NFS: Fix
up the fsync code").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Aug_2010_11_32_14_+1000_0W/C=q.m31.J5a=T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWMMeAAoJEDMEi1NhKgbsHTwIAIFsvrLpFY5EdaCFBScljgCs
ajkMei30epReL+p2w42p15B3nNLJMa1xJyWW4OyKoz9/IKXDtUSBbbzROnKptq4/
yuhZBB4mFE3M/ZsMUzIbv+HsEi49M8mcrMebzhR63NfT2d/iW95hDPrfADV3k9/o
bMxZDPVJ+pNRyy7gBZzXiTkQQ5vgREXuRSizbwG71ZGbC4CjUubtpmyuummZ8Gfi
uGrIRHx2QKFG5CFrrgvIAXsxIiRUSQVIXCzQ0mjD8NrAM2v0LMIrbg8HKI0SzLru
iuCCQq2QiAvEaa+Mn8jyGXEtMLgXsK9xkCg+IBeVUruVrbglOcjemrDww1DufSk=
=Ek3P
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Aug_2010_11_32_14_+1000_0W/C=q.m31.J5a=T--
