Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab3AAXyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 18:54:39 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56466 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3AAXyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 18:54:38 -0500
Date: Wed, 2 Jan 2013 10:54:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the s390 tree with the  tree
Message-Id: <20130102105428.38b1e9e8ecdb4563dcc825c1@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__2_Jan_2013_10_54_28_+1100_r.djLb3CjXTDWYoo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jan_2013_10_54_28_+1100_r.djLb3CjXTDWYoo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the s390 tree got a conflict in
arch/s390/kernel/smp.c between commit c8925a6e95b2 ("ARCH: drivers remove
__dev* attributes") from the driver-core.current tree and commit
5059e4342f93 ("s390/smp: fix section mismatch for smp_add_present_cpu()")
from the s390 tree.

I fixed it up (I used the s390 tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__2_Jan_2013_10_54_28_+1100_r.djLb3CjXTDWYoo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ43c0AAoJEECxmPOUX5FEy30QAKF7WUmTGXr+YO1zNzdp25RP
yu4aveuHnSeP3RLlb9cAp2jvXWcyFZTf1MWmXwps+Hb48THNcnrJj3P9r7q0uAEM
HcirLMbkizexy0b8mFlcGBh6FkkEsClpx1VcOZExgcF4so33pwMDMt+vC0CbjCa3
U730XzwBWEeQ83TjE+prpyViiPqNi5cVLIkxQUikpuaz21qGAP0tzbzwKxVHHz71
iiO3fur4SkGnp7m9cNDFctnDO230z4Opi2Efivz3R2VIrF465ugmYgih39kBjNkb
16p8rJhkNo6GGeO+iFlTvTk6yDE01ZqPovzgnMpQtAeLYuI+iDi8mz9HFF24bpwm
vpKAWMGbQBU77Z6maLRTfMQ5yRrhsZoUjK1xKm0zQaisQ5HmwxeMWm5LaS/caEya
gTVtzlp4wKFO7FAzmzraiCgAadKm+jK9yWyqsJOMgoPTSqMAexuUhIWibU+e5nSJ
DKsdXRa5bfPYiPWdhQO08zFArspnOQ58CpGSUlrCct8sXB/NsJ4Tdl+UJTa69BHp
XhJ1ggwA7VWmo77nU7otGoPXtFqQINwrOj0IzKf1fPwzkGYUWM8w2VIGDwdKdf8Z
AdmewYSwonoihbkfanmoZjSOXTIp1ldeIf2AIDUEeyi88Rsz9sUkLWiCSrPgCTnY
WYjiV0YBvKZchdlortti
=QWBq
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jan_2013_10_54_28_+1100_r.djLb3CjXTDWYoo--
