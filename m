Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0G0HAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:00:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46299 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab0G0HAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:00:46 -0400
Date: Tue, 27 Jul 2010 17:00:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100727170039.9e01f690.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Jul_2010_17_00_39_+1000_fdcbLCbK2oBszJpS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Jul_2010_17_00_39_+1000_fdcbLCbK2oBszJpS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the final tree, today's linux-next build (all the arm config
builds) failed like this:

arch/arm/kernel/process.c: In function 'arm_machine_restart':
arch/arm/kernel/process.c:106: error: implicit declaration of function 'flu=
sh_cache_all'

Caused by commit 287f6bfbe760fe580d939657fc1341d6c0059f78 ("ARM: Factor
out common code from cpu_proc_fin()").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Jul_2010_17_00_39_+1000_fdcbLCbK2oBszJpS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMToQXAAoJEDMEi1NhKgbsc2MH/0WQNkA8mrnSa9YnmFbd/9Tz
dDOS55Kq1oAu6LaZZvoKNUZsmCvanmI67Nzjf3p4McE6k6+na1G8l/gmiyQRVYRA
+wzuLLNcRkrYnl5qs9sJQphux6OTKh5yXbiwpJO+IpHASJWdaRwYMwebHxsiXpHC
beTeji6idFQ0hrNHEELVOSH4/9dVnMSoXSAvW6h4XqdM4dNLF82NNODyYMHDsP8N
c21DB7eR+s3Hrp9qgr2gVtVFOUk9lTYJERQlPZJswZAdhVr5DUxxogvg03o2NxdC
yzfz8Ci/scAXGc7KvIWx/ERJ73AzGLcuJwLOvaruPxlS/hsHu8vDFmGIpVDvxbA=
=lQf0
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Jul_2010_17_00_39_+1000_fdcbLCbK2oBszJpS--
