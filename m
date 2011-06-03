Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab1FCDxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 23:53:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46389 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab1FCDxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 23:53:51 -0400
Date: Fri, 3 Jun 2011 13:53:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Hellstrom <daniel@gaisler.com>
Subject: linux-next: build failure after merge of the final tree
 (sparc-current tree related)
Message-Id: <20110603135347.a17e0b85.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jun_2011_13_53_47_+1000_bLj1=ofktQATebdC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Jun_2011_13_53_47_+1000_bLj1=ofktQATebdC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/kernel/pcic.c:38:0:
arch/sparc/kernel/irq.h:40:58: error: 'SUN4M_NCPUS' undeclared here (not in=
 a function)
arch/sparc/kernel/irq.h:55:14: error: conflicting types for 'irq_alloc'
arch/sparc/include/asm/irq_64.h:60:22: note: previous declaration of 'irq_a=
lloc' was here
arch/sparc/kernel/pcic.c: In function 'pdev_to_pnode':
arch/sparc/kernel/pcic.c:452:34: error: 'struct linux_prom_pci_registers' h=
as no member named 'which_io'
arch/sparc/kernel/pcic.c: In function 'pci_time_init':
arch/sparc/kernel/pcic.c:738:2: error: 'do_arch_gettimeoffset' undeclared (=
first use in this function)
arch/sparc/kernel/pcic.c:738:2: note: each undeclared identifier is reporte=
d only once for each function it appears in
arch/sparc/kernel/pcic.c: In function 'pcic_nmi':
arch/sparc/kernel/pcic.c:790:2: error: implicit declaration of function 'fl=
ip_dword'
arch/sparc/kernel/pcic.c:798:22: error: 'struct pt_regs' has no member name=
d 'pc'
arch/sparc/kernel/pcic.c:803:6: error: 'struct pt_regs' has no member named=
 'pc'
arch/sparc/kernel/pcic.c:803:17: error: 'struct pt_regs' has no member name=
d 'npc'
arch/sparc/kernel/pcic.c:804:6: error: 'struct pt_regs' has no member named=
 'npc'
cc1: warnings being treated as errors
arch/sparc/kernel/pcic.c: At top level:
arch/sparc/kernel/pcic.c:812:34: error: 'struct irq_data' declared inside p=
arameter list
arch/sparc/kernel/pcic.c:812:34: error: its scope is only this definition o=
r declaration, which is probably not what you want
arch/sparc/kernel/pcic.c: In function 'pcic_mask_irq':
arch/sparc/kernel/pcic.c:816:28: error: dereferencing pointer to incomplete=
 type
arch/sparc/kernel/pcic.c: At top level:
arch/sparc/kernel/pcic.c:822:36: error: 'struct irq_data' declared inside p=
arameter list
arch/sparc/kernel/pcic.c: In function 'pcic_unmask_irq':
arch/sparc/kernel/pcic.c:826:28: error: dereferencing pointer to incomplete=
 type
arch/sparc/kernel/pcic.c: At top level:
arch/sparc/kernel/pcic.c:832:45: error: 'struct irq_data' declared inside p=
arameter list
arch/sparc/kernel/pcic.c: In function 'pcic_startup_irq':
arch/sparc/kernel/pcic.c:834:15: error: dereferencing pointer to incomplete=
 type
arch/sparc/kernel/pcic.c:835:2: error: passing argument 1 of 'pcic_unmask_i=
rq' from incompatible pointer type
arch/sparc/kernel/pcic.c:822:13: note: expected 'struct irq_data *' but arg=
ument is of type 'struct irq_data *'
arch/sparc/kernel/pcic.c: At top level:
arch/sparc/kernel/pcic.c:839:15: error: variable 'pcic_irq' has initializer=
 but incomplete type
arch/sparc/kernel/pcic.c:840:2: error: unknown field 'name' specified in in=
itializer
arch/sparc/kernel/pcic.c:840:2: error: excess elements in struct initializer
arch/sparc/kernel/pcic.c:840:2: error: (near initialization for 'pcic_irq')
arch/sparc/kernel/pcic.c:841:2: error: unknown field 'irq_startup' specifie=
d in initializer
arch/sparc/kernel/pcic.c:841:2: error: excess elements in struct initializer
arch/sparc/kernel/pcic.c:841:2: error: (near initialization for 'pcic_irq')
arch/sparc/kernel/pcic.c:842:2: error: unknown field 'irq_mask' specified i=
n initializer
arch/sparc/kernel/pcic.c:842:2: error: excess elements in struct initializer
arch/sparc/kernel/pcic.c:842:2: error: (near initialization for 'pcic_irq')
arch/sparc/kernel/pcic.c:843:2: error: unknown field 'irq_unmask' specified=
 in initializer
arch/sparc/kernel/pcic.c:843:2: error: excess elements in struct initializer
arch/sparc/kernel/pcic.c:843:2: error: (near initialization for 'pcic_irq')
arch/sparc/kernel/pcic.c: In function 'pcic_build_device_irq':
arch/sparc/kernel/pcic.c:861:2: error: implicit declaration of function 'ir=
q_set_chip_and_handler_name'
arch/sparc/kernel/pcic.c:862:32: error: 'handle_level_irq' undeclared (firs=
t use in this function)
arch/sparc/kernel/pcic.c:863:2: error: implicit declaration of function 'ir=
q_set_chip_data'

Caused by commit cfe3af5dde34 ("sparc32: added CONFIG_PCIC_PCI Kconfig
setting") from the sparc-current tree.

I have reverted that commit (and the 2 following commits that depend on
it) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Jun_2011_13_53_47_+1000_bLj1=ofktQATebdC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN6FrLAAoJEDMEi1NhKgbsQAsH/3bgJS4wljloFbPwGBAf+nj+
FmTcW3/4e9RLNq2q1xkajdIKQeLEPPGmFeRUVMLPQNX7JWmLvrt7JbejIE27Nq6R
2rEqFFvwyOA+uDQXRxz3ziLEfMhtTw6+3QLQOHQWToL1unLJK13F7FQGOUZWTObS
7RbbVoO/MA08BDxUoLDcx/t9AmmU+YBnz2MYNEnLcmUtW1XyVrZjvUZMVwDHIUtT
/stKwjk4JxiuUgbWitz3r1t9RzOd6To6Kgq8I9poZzTNIegGlCl/11wRtQJ1lbPV
igyVJBQxEUkWHmzt622VoOS1G2wzJF3wn+hW3dXHThpWc8CB9PsXDCzf3D+Z/lw=
=XEFG
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jun_2011_13_53_47_+1000_bLj1=ofktQATebdC--
