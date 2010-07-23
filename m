Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750887Ab0GWEBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:01:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57191 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0GWEBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:01:15 -0400
Date: Fri, 23 Jul 2010 14:01:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xen tree
Message-Id: <20100723140107.2883b2d3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__23_Jul_2010_14_01_07_+1000_2FbpSyKIBOwZ5llc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__23_Jul_2010_14_01_07_+1000_2FbpSyKIBOwZ5llc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jeremy,

After merging the xen tree, today's linux-next build (86_64 allmodconfig)
failed like this:

arch/x86/xen/enlighten.c:71: error: __pcpu_scope_xen_vcpu causes a section =
type conflict
arch/x86/xen/enlighten.c:72: error: __pcpu_scope_xen_vcpu_info causes a sec=
tion type conflict
arch/x86/xen/enlighten.c:71: error: __pcpu_unique_xen_vcpu causes a section=
 type conflict
arch/x86/xen/enlighten.c:72: error: __pcpu_unique_xen_vcpu_info causes a se=
ction type conflict
arch/x86/xen/enlighten.c:558: error: __pcpu_unique_idt_desc causes a sectio=
n type conflict
arch/x86/xen/enlighten.c:760: error: __pcpu_unique_xen_cr0_value causes a s=
ection type conflict

Not sure what has caused this.  I have dropped the xen tree for today.

gcc version 4.4.4 binutils version 2.20.1.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__23_Jul_2010_14_01_07_+1000_2FbpSyKIBOwZ5llc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMSRQDAAoJEDMEi1NhKgbsHi4IAJyihaRtkN9vHpX7LDLUCkJF
7knQCqCqAKnzyHp1nNrQ6rpZuquyArxX/HVkZmPrNFB1iM3Nq9W6FJrqtVrfn0lz
lv1I0XRE0v5JOQuljMYvU1QcVX9OzHvk3mUCoHHPLqP4XfzfRinYdjVtRhG+6dy/
qAs81w8RCiB9LnrfOUK+ZCFhV3lRbsKKSJUKQdyzdBQf2+R4H1uRk3rEwzVKe+WQ
3Mgxz5tB1KDxzbqqmsKfxiXv7uLRV9HuE3R6rc38ilAfBrBPOaQxlPAqeBprfGqp
HJ2zwTMlZ8lHj0U9df5NOKVus++IzslMeaauKZS7Y0ZMBgn0Hd/2yLrM9ZFXQCU=
=G8n5
-----END PGP SIGNATURE-----

--Signature=_Fri__23_Jul_2010_14_01_07_+1000_2FbpSyKIBOwZ5llc--
