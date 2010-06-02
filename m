Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab0FBCDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 22:03:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38662 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756312Ab0FBCDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 22:03:52 -0400
Date: Wed, 2 Jun 2010 12:03:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the rr tree
Message-Id: <20100602120345.e530c53b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Jun_2010_12_03_45_+1000_z/Kb8XemOpJ9tjpI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jun_2010_12_03_45_+1000_z/Kb8XemOpJ9tjpI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

kernel/debug/kdb/kdb_main.c: In function 'kdb_lsmod':
kernel/debug/kdb/kdb_main.c:1897: error: 'struct module' has no member name=
d 'modules_which_use_me'
kernel/debug/kdb/kdb_main.c:1897: error: 'struct module' has no member name=
d 'modules_which_use_me'

I have used the rr tree from next-20100531 again for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Jun_2010_12_03_45_+1000_z/Kb8XemOpJ9tjpI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwFvAEACgkQjjKRsyhoI8yJsACdGW3o06xftpv76GBns9TTHeg/
xl0AnR/b6m0SCt7RAYXiR9RVElgnhjm+
=XYLr
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jun_2010_12_03_45_+1000_z/Kb8XemOpJ9tjpI--
