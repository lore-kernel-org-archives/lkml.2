Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2LJIUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:20:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54351 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2LJIUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:20:09 -0500
Date: Mon, 10 Dec 2012 19:20:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210192005.9328216d5dbaacc1f0fe6217@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_20_05_+1100_IjzR965W4Mf/A+pW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_20_05_+1100_IjzR965W4Mf/A+pW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/mempolicy.c between commit d9f1eb872704 ("numa, mempolicy: Improve
CONFIG_NUMA_BALANCING=3Dy OOM behavior") from the tip tree and commit "mm,
mempolicy: remove duplicate code" from the akpm tree.

I can't tell if the akpm tree patch is still relevant, so I dropped it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_19_20_05_+1100_IjzR965W4Mf/A+pW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZs1AAoJEECxmPOUX5FEohgQAI88AaA6dIljlWq2tYUVG3L2
QaCsZYaw3xSh6CaLZmwwLrenrTZFplTKtv/oQWB0DvZ6gba+b0ZThwPCllESDO1C
VFN1VzjaPWhknwjwpzHBb6d/bP+adrX8Qs5y6huMFJSzHgGVF6CnHgH/8QFNqEoq
O9iewAtQiAwbhwDwDDGSyXGeooaP62Cz9fIKxOJ+5N6e+mbi3c03tccWnHX+DjjA
j5IBrVOcdveBtkFc8TAq98boC8QOGgp0VKEhGyOiou+D5/bF+iMWQHZ9UWivNC9e
Z23SHDGZpNI4iuN2oFWIaiphep+I0k8LfgHu8Z06+ds495sg/3WwDicKDvBNXHIH
s0QVaniPXuz5w24Gaj4NswrU/VBf1Fr3pLT3OM05So8Gyz6cYOeNsHhoAHEMr+7x
6pJDQZmMjVuzGJ4Jt7AUpM4SHv/tadlgV8liwA+phX8ZiutE6r+g85+jEO3NnYuJ
IuqIYByqbG3c9KcTY8xfrwqdQLtx1dJvwWkTfFV02jrB4OJR/gB0iwOxUg30ByPX
ShNWbJyQ2V6/Z2HC3PXP2+hXIA+2lEZJN0XOdpJTcjSeIuRqA0kFpGCdIPDoq+XZ
3GTnn/RI+sIJX6nCepaQ8qzQqRvkhwP6UJdlzr3eBFAHEbbrUBnfjhbpcD/w2tBP
w7d9w5I3dh7Dzu8n0E+8
=w56o
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_20_05_+1100_IjzR965W4Mf/A+pW--
