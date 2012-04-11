Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175Ab2DKEN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 00:13:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48038 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab2DKEN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 00:13:56 -0400
Date: Wed, 11 Apr 2012 14:13:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: build failure after merge of the regmap tree
Message-Id: <20120411141346.3c4dd8e481d052b583ac95b6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__11_Apr_2012_14_13_46_+1000_=626Z7bRjxVNK7k6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Apr_2012_14_13_46_+1000_=626Z7bRjxVNK7k6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the regmap tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_sync_unlock':
drivers/base/regmap/regmap-irq.c:62:12: error: 'map' undeclared (first use =
in this function)
drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_enable':
drivers/base/regmap/regmap-irq.c:77:37: error: 'map' undeclared (first use =
in this function)
drivers/base/regmap/regmap-irq.c: In function 'regmap_irq_disable':
drivers/base/regmap/regmap-irq.c:85:37: error: 'map' undeclared (first use =
in this function)

Caused by commit f01ee60fffa4 ("regmap: implement register striding").
Please build test ...

I have used the regmap tree from next-20120410 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__11_Apr_2012_14_13_46_+1000_=626Z7bRjxVNK7k6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPhQT6AAoJEECxmPOUX5FEccMP/38lNwLyngQ6EYYOO/b5tXXw
HcMr7jyInvwEzNLQKWQ/gi8ZCNq17j3sudhkWxWq8fk96mgp0Mdca44NDRKR41t9
MzdmCQCNtnkmcmjYXZ31UsnCf2OQqR8Ea032hp7cOiFBM6TLs6Tjc6dDJm9bCzOY
SP3uBGGn93EHnHo351bpR+ScmLBdqhwZafvTjsQytQc3eazAy7o0K5i1eUSYpWiq
OU7BQsJpSAKQGNJrJCmRI0Dh9+jUktuvlvOrkxZ+FUjovBBfUBjc8QEFNfrR5giT
VZAwWJgVET8H7UKeZ+Fyu4oyquZ6QZIyZsKbNIvhyBx8CT1lgnmkyJxJffQHx+pr
nSoR+NlpjREdw20bD+5Ceag9RCf/OoYQmcUY2hxRs9KCpu5TQ4CfRGMjWoNuqgMK
41GKWT66RbwGm9tYQnBZs+Shapwj/4ng/9XSexGg6hfdZVLIwWxVDPekyk1aCRW4
XsXfr5fcfa06vp3qBGiw48wpn7Q/KMsC/160h0jwsDvHlncU7dLOVbpITfBbLM4m
Dax9kwpBxC1zoDcdA0PpwSu42+J+lQdxlK9p5VUnCaBDDfMdbZNaowTKK66Yf9oO
TEJ5NsUg1zRYI0HfnYfh2t/OYWfYaNlJjPKWBTrkewARnuBmom6WdWSS1WK4lCIv
XkMyni2zgcZqexLZ0W4i
=yexU
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Apr_2012_14_13_46_+1000_=626Z7bRjxVNK7k6--
