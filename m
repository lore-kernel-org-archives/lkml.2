Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906Ab0ESEDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 00:03:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51790 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab0ESEDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 00:03:17 -0400
Date: Wed, 19 May 2010 14:03:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rabin Vincent <rabin.vincent@stericsson.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20100519140310.e439960d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_May_2010_14_03_10_+1000_s7hN2be_3ssEQbxy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_May_2010_14_03_10_+1000_s7hN2be_3ssEQbxy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/ab8500-core.c: In function 'ab8500_irq_remove':
drivers/mfd/ab8500-core.c:302: error: implicit declaration of function 'set=
_irq_flags'

Caused by commit 16548223daf6b3b95b75cb961d772831a754e126 ("mfd: new
AB8500 driver").

I have used the mfd tree from next-20100518 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_May_2010_14_03_10_+1000_s7hN2be_3ssEQbxy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvzYv4ACgkQjjKRsyhoI8zbvQCfRlkvvFVwCZ3F/9nOYm4XcSnS
G6gAn3KBB1owAiHrzHvSFW4c49vsaUUE
=pjuQ
-----END PGP SIGNATURE-----

--Signature=_Wed__19_May_2010_14_03_10_+1000_s7hN2be_3ssEQbxy--
