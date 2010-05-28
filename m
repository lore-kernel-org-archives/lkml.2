Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab0E1Cxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:53:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36256 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0E1Cxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:53:45 -0400
Date: Fri, 28 May 2010 12:53:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the idle-test tree
Message-Id: <20100528125338.b9a295ff.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_May_2010_12_53_38_+1000_y86GodFL/9/I4Lbh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_May_2010_12_53_38_+1000_y86GodFL/9/I4Lbh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the idle-test tree, today's linux-next build (x86_64
allmodconfig) produced these warning:

drivers/idle/intel_idle.c:115: warning: missing braces around initializer
drivers/idle/intel_idle.c:115: warning: (near initialization for 'nehalem_c=
states[0].name')
drivers/idle/intel_idle.c:115: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:115: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:125: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:125: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:126: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:126: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:127: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:127: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:128: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:128: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:132: warning: missing braces around initializer
drivers/idle/intel_idle.c:132: warning: (near initialization for 'atom_csta=
tes[0].name')
drivers/idle/intel_idle.c:132: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:132: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:139: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:139: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:145: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:145: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:147: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:147: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:153: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:153: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:155: warning: initialization makes integer from p=
ointer without a cast
drivers/idle/intel_idle.c:155: warning: initialization makes integer from p=
ointer without a cast

Introduced by commit dc81ce2e1b88c58e011971ab584ffb70a5caf887
("intel_idle: create a native cpuidle driver for select intel
processors").  You can't initialise a char[] with NULL ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_May_2010_12_53_38_+1000_y86GodFL/9/I4Lbh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv/MDIACgkQjjKRsyhoI8znbQCfbUEJ5AxlMEudyt5uNbHUSllh
lXIAn3+ZjZnuKqWWkfMY0ncKQ0VTi11S
=NUWj
-----END PGP SIGNATURE-----

--Signature=_Fri__28_May_2010_12_53_38_+1000_y86GodFL/9/I4Lbh--
