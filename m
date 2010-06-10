Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0FJBPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:15:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58478 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab0FJBPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:15:21 -0400
Date: Thu, 10 Jun 2010 11:15:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kbuid-current tree
Message-Id: <20100610111517.3a4ed458.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Jun_2010_11_15_17_+1000_X74L7HcsqHpLQERK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Jun_2010_11_15_17_+1000_X74L7HcsqHpLQERK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild-current tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

/bin/sh: line 1: init/modules.builtin: No such file or directory
make[2]: *** [init/modules.builtin] Error 1
make[1]: *** [init/modules.builtin] Error 2

Caused by commit 2da30e703c5a56e27249fa8b8607708123fa52f5 ("kbuild:
Generate modules.builtin in make modules").

I started with a completely empty separate object directory ...

I have used the version of the kbuild-current tree from next-20100609 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Jun_2010_11_15_17_+1000_X74L7HcsqHpLQERK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwQPKUACgkQjjKRsyhoI8y7NwCgphClbe4mSyXHmNj8/l3Qu9WC
iswAoJeC+hjbBTw2eWf9YMs/hZhZcWnK
=j65q
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Jun_2010_11_15_17_+1000_X74L7HcsqHpLQERK--
