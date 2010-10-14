Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0JNFte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 01:49:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56762 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0JNFtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 01:49:33 -0400
Date: Thu, 14 Oct 2010 16:49:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20101014164925.4fa16b75.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Oct_2010_16_49_25_+1100_v2p.AZJ3C2GEzfUS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Oct_2010_16_49_25_+1100_v2p.AZJ3C2GEzfUS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, linux-next builds (arm corgi_defconfig,
spitz_defconfig) fail like this:

arch/arm/kernel/perf_event.c: In function 'armpmu_event_init':
arch/arm/kernel/perf_event.c:543: error: request for member 'num_events' in=
 something not a structure or union

Caused by commit 15ac9a395a753cb28c674e7ea80386ffdff21785 ("perf: Remove
the sysfs bits").

This seems to have broken in next-20100913 and noone has noticed/bothered
to fix it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Oct_2010_16_49_25_+1100_v2p.AZJ3C2GEzfUS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMtpnlAAoJEDMEi1NhKgbsDusH/0DBlElSziYImTliMAkLXVI1
zc+Lg4HkJzLLE3xCc4wN4u4QJAycOegJtsBZUX/b5VSAw8fwZ4Qwuyhanawi/fET
GztvZVXtBhOfCqoup/tXMmhme6TxrPu+Iqk4Cy6EKQeXHfSCtisxMdQxUT4aqNWj
7aypT5VMu8K+vsP7bPrEwrlJ7ZECyYpV+HAQr1ruOzbgg81oXnFCn2M9i0eHNXpz
zLYO7LuqnLBQYyJuEEFwxRr4eue6pQnWs+ac2hYNfY4MNal4/0jLvJZg3o3GFwIc
1+MsGLVHsFGI1UtoPZPR2vG3+rhMvNalbfrndQ4+jMXfGEZ/AYMo975mgiAPg9Q=
=wvLZ
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Oct_2010_16_49_25_+1100_v2p.AZJ3C2GEzfUS--
