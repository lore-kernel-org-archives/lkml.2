Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab1G2HJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:09:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51686 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1G2HJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:09:46 -0400
Date: Fri, 29 Jul 2011 17:09:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20110729170933.b7bfc24dcf48201928bd5890@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jul_2011_17_09_33_+1000_PGtOVRsH+u9=Hp_/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jul_2011_17_09_33_+1000_PGtOVRsH+u9=Hp_/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (sparc defconfig)
failed like this:

arch/sparc/mm/extable.c: In function 'trim_init_extable':
arch/sparc/mm/extable.c:74:19: error: dereferencing pointer to incomplete t=
ype
arch/sparc/mm/extable.c:75:12: error: dereferencing pointer to incomplete t=
ype
arch/sparc/mm/extable.c:77:3: error: implicit declaration of function 'with=
in_module_init'
arch/sparc/mm/extable.c:77:27: error: dereferencing pointer to incomplete t=
ype
arch/sparc/mm/extable.c:78:5: error: dereferencing pointer to incomplete ty=
pe
arch/sparc/mm/extable.c:80:6: error: dereferencing pointer to incomplete ty=
pe
arch/sparc/mm/extable.c: In function 'search_extables_range':
arch/sparc/mm/extable.c:93:2: error: implicit declaration of function 'sear=
ch_exception_tables'
cc1: warnings being treated as errors
arch/sparc/mm/extable.c:93:8: error: assignment makes pointer from integer =
without a cast
cc1: warnings being treated as errors
arch/sparc/mm/highmem.c:66:1: error: data definition has no type or storage=
 class
arch/sparc/mm/highmem.c:66:1: error: type defaults to 'int' in declaration =
of 'EXPORT_SYMBOL'
arch/sparc/mm/highmem.c:66:1: error: parameter names (without types) in fun=
ction declaration
arch/sparc/mm/highmem.c:111:1: error: data definition has no type or storag=
e class
arch/sparc/mm/highmem.c:111:1: error: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL'
arch/sparc/mm/highmem.c:111:1: error: parameter names (without types) in fu=
nction declaration
cc1: warnings being treated as errors
arch/sparc/kernel/traps_32.c:426:1: error: data definition has no type or s=
torage class
arch/sparc/kernel/traps_32.c:426:1: error: type defaults to 'int' in declar=
ation of 'EXPORT_SYMBOL'
arch/sparc/kernel/traps_32.c:426:1: error: parameter names (without types) =
in function declaration
cc1: warnings being treated as errors
arch/sparc/kernel/irq_32.c:53:1: error: data definition has no type or stor=
age class
arch/sparc/kernel/irq_32.c:53:1: error: type defaults to 'int' in declarati=
on of 'EXPORT_SYMBOL'
arch/sparc/kernel/irq_32.c:53:1: error: parameter names (without types) in =
function declaration
arch/sparc/kernel/irq_32.c:69:1: error: data definition has no type or stor=
age class
arch/sparc/kernel/irq_32.c:69:1: error: type defaults to 'int' in declarati=
on of 'EXPORT_SYMBOL'
arch/sparc/kernel/irq_32.c:69:1: error: parameter names (without types) in =
function declaration
arch/sparc/kernel/irq_32.c:86:1: error: data definition has no type or stor=
age class
arch/sparc/kernel/irq_32.c:86:1: error: type defaults to 'int' in declarati=
on of 'EXPORT_SYMBOL'
arch/sparc/kernel/irq_32.c:86:1: error: parameter names (without types) in =
function declaration
cc1: warnings being treated as errors
arch/sparc/kernel/setup_32.c:203:1: error: data definition has no type or s=
torage class
arch/sparc/kernel/setup_32.c:203:1: error: type defaults to 'int' in declar=
ation of 'EXPORT_SYMBOL'
arch/sparc/kernel/setup_32.c:203:1: error: parameter names (without types) =
in function declaration
arch/sparc/kernel/setup_32.c:332:1: error: data definition has no type or s=
torage class
arch/sparc/kernel/setup_32.c:332:1: error: type defaults to 'int' in declar=
ation of 'EXPORT_SYMBOL'
arch/sparc/kernel/setup_32.c:332:1: error: parameter names (without types) =
in function declaration
cc1: warnings being treated as errors
arch/sparc/mm/generic_32.c:98:1: error: data definition has no type or stor=
age class
arch/sparc/mm/generic_32.c:98:1: error: type defaults to 'int' in declarati=
on of 'EXPORT_SYMBOL'
arch/sparc/mm/generic_32.c:98:1: error: parameter names (without types) in =
function declaration

Again, I have left these unfixed in linux-next today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jul_2011_17_09_33_+1000_PGtOVRsH+u9=Hp_/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOMlytAAoJEDMEi1NhKgbs1hMH/0DUTZpQDF4re7iYtWgyRbyL
lh6Q0G5uR1i1fHMcX//gLDKl6MwfikZ4wTqKIbVbIGu0LpwrE83pVq1H5fDZ5JRj
HkwMxBYYISgJXeAKlP9jg8nT+3dV8qq9rr7j0Vfb37IWc60iKqUzz8lt5SH1WrLu
7BwQ9HqZUbpfYulmioi5P6K+xE0gQbqAtC/KB+FVcYnd/jBlwttga3fe436sIoc3
XpRKFtHualYl97oXC1+Ldf4iqvWAmkW7nkEJzGq7hFxkRrKevWi54vT+7g1HVJuh
yuW8ESdv2VcgeMPwjzC7dN304oV4noVem3TV1a2uvffJ0u/nStUkFcEB/hzMxtA=
=Q6Hp
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jul_2011_17_09_33_+1000_PGtOVRsH+u9=Hp_/--
