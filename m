Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab0E0ElW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:41:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47048 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382Ab0E0ElU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:41:20 -0400
Date: Thu, 27 May 2010 14:41:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the acpi tree
Message-Id: <20100527144111.84b2e651.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__27_May_2010_14_41_11_+1000_jD28dIZwBzXe1gFx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_May_2010_14_41_11_+1000_jD28dIZwBzXe1gFx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

After merging the acpi tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/idle/intel_idle.c: In function 'intel_idle_cpuidle_devices_init':
drivers/idle/intel_idle.c:324: warning: unused variable 'cstate'
drivers/idle/intel_idle.c: At top level:
drivers/idle/intel_idle.c:141: warning: 'atom_cstates' defined but not used

Introduced by commit 7869a4e97e18b5c129ede0fca820d1ed3da8e18b
("intel_idle: create a native cpuidle driver for select intel
processors").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_May_2010_14_41_11_+1000_jD28dIZwBzXe1gFx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv99+cACgkQjjKRsyhoI8xW6ACgvGexyJBnQ+AQXmuyocAxEPkc
QvYAnAwg/7YSb8db1miUhqZR9/Dux/Fl
=rPsm
-----END PGP SIGNATURE-----

--Signature=_Thu__27_May_2010_14_41_11_+1000_jD28dIZwBzXe1gFx--
