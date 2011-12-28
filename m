Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1L1ERd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 23:17:33 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:33947 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1L1ERc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 23:17:32 -0500
Date: Wed, 28 Dec 2011 15:17:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the kvm tree with the rr tree
Message-Id: <20111228151721.ceff9dc7d7e1c1ab56518aa4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_15_17_21_+1100_Jy38hWvT0cWM9VY1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_15_17_21_+1100_Jy38hWvT0cWM9VY1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/kvm/mmu.c between commit d6e5215aba76 ("module_param: make bool
parameters really bool (arch)") from the rr tree and commit d750ea28865d
("KVM: MMU: remove oos_shadow parameter") from the kvm tree.

The latter just removed the code modified by the former, so I did that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_15_17_21_+1100_Jy38hWvT0cWM9VY1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+phRAAoJEECxmPOUX5FEvjcQAKiTFAbrsni3Ew+pT4fEry3x
OGv/XXQuNBHIdcg0LXdec0u/24SjR+KFlACZQ4rDr06o5L8tbVZ89chntnf4algx
8kKLxdmDktrc0NQFHCLom0216AMUSqpthEq12i6N8rbI+XbmeR73fOAS8otqW4YQ
AzbgkQZ/0hphSISp7S+lu3pwIIxXns0Ok/M5SAUcfCA3X43Eit50ILBoeV5zcFmD
5s01ZDZQo5x9EUDKwgeJCUgqy+P9DGpTDv/3zQJoqoMJyZMsuz1FKSddC6M313E1
fwg/YhnWz/kpqklBuohoeC6BgdxCy7ryE4NDBwrUOgp3ZzQUWJzJWCSFAxuG3Vab
UKWWzUDrIpyhMlPT9nXmJFMSFxyU8b4jQhu441eyiS5hS9vLA8whMKAf0E9oxWvo
zCyw5Eank1Bv+AXj4cq9WK1jAs14grClTQMR0y+6j6IKg2OdEhHvIcIkk82GmrQI
UDirUeBUJ4pqm8bLn80PsFrYIPPS5MkDKkx9FH8YrwGuyZKmGmvz++Dqu4KWPYrd
DWGvvo8KMxjtv9mhiTIJf97+UQNPZ0AjHaE6fTup7fIK9Pbp14hh9GkEV+91LgdQ
8xs2kQcRTldLF6d9gdAiT409fPyUpz+sgoERChiPWI1VEwbUjbUKas5JAFqOnYOb
K4TrTjFp3sJ/lBgmx/MP
=yXEs
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_15_17_21_+1100_Jy38hWvT0cWM9VY1--
