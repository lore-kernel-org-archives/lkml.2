Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab1EKPrx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:47:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58081 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab1EKPrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:47:51 -0400
Date: Wed, 11 May 2011 14:02:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: manual merge of the namespace tree with the m68k tree
Message-Id: <20110511140225.2c7e300f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_May_2011_14_02_25_+1000_tbRhS_JalEuqWY52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_May_2011_14_02_25_+1000_tbRhS_JalEuqWY52
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the namespace tree got a conflict in
arch/m68k/kernel/entry_mm.S between commit 55e1af1ab184 ("m68k: Merge mmu
and non-mmu versions of sys_call_table") from the m68k tree and commit
e975ee91dcc1 ("ns: Wire up the setns system call") from the namespace
tree.

I just used the m68k version of that file and that should be all that is
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_May_2011_14_02_25_+1000_tbRhS_JalEuqWY52
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNygpRAAoJEDMEi1NhKgbsXJcH/3ALR6TK2FpcJgH7Y6Lny/wk
MRM0uvE7nVe/SRNtBXWzXXNB5oSWBW/Rig9vaFwVRx6eoOX5A82ESEkmz9tHXXrf
WtLfmSkurHAmcZm+TBBL2Jw3yp+g+kDf5lu/pJFQAXwhTyvnmg6KyviI5xlaKT8n
Hbis5sz4J8u2CldYN3K4PChRZj2t68LlSaUabGMaFDoAQcbyMX1SHTepBXzRusGu
bfJJ3xOzjFzrWSkfMZsppMNVmWc2ZE2IWeOHn22vKufYanRvvensPGj+B3ofyILL
YL0UCZjr9sczoqMyJ8SVCdgaEgZ4HqvYr8vjNmSltjo3JNu9TGlt0RDnEhZ4s6w=
=erwE
-----END PGP SIGNATURE-----

--Signature=_Wed__11_May_2011_14_02_25_+1000_tbRhS_JalEuqWY52--
