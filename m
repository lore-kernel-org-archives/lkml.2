Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2CHGxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:53:21 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58949 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2CHGxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:53:18 -0500
Date: Thu, 8 Mar 2012 17:53:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20120308175307.b295b1013728a5666fe4571a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_53_07_+1100_oSzT.1M0ZZWoifDo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_53_07_+1100_oSzT.1M0ZZWoifDo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/mm/hugetlbpage.c between commit 097d59106a8e ("vm: avoid using
find_vma_prev() unnecessarily") from Linus' tree and commit "hugetlb:
drop prev_vma in hugetlb_get_unmapped_area_topdown()" from the akpm tree.

I think the latter is a superset of the former, so I just dropped the
changes from the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__8_Mar_2012_17_53_07_+1100_oSzT.1M0ZZWoifDo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWFdTAAoJEECxmPOUX5FEQzEP/3+TkcxhKJQqi6E5TVvJElJ9
cGTV0I1VmzAJpaES5piZKEMBvZgErEBVis7xCL22xSdXmPuwy3vWM2kPoGBCrfY7
IcaIzlFORi1vb2tdUczBlJqEfLoLPyrw5pu9YuWZbr3S/kQibCCXmnhoICkRI8f+
qRQwAyX6AUoXEYYqWviRqq+PvjfkxCFAqn8Ljz9sBFbaHdWH2XVwa/QFRxIpfXcL
MUuLsP9sfH+JGIHk2k2B1+uG/MxoUIE9CQYQMWHFKThQ0/J67PSuaSKnXrhBiSaA
QwvCAUgjo6y6VDTIhXntPIz9aXRos7O7f99CMDcDt9yOtiLeX8ZE3Z/R7E7lhQ/t
6R0Slbb+ZCSchJGM5FM7iC6uO6bS/jcD+mWv8r5WyyYAPNyF15BUzpcXKIB6sITT
Zy9E7I7LprhIx+nbEZAvnfXZo0erVkY9gyL4Qpc3tDFCep/FICtGQLXAXp4RcRFx
q9wY8+H7jCIfhsBcQlVJJgFk812NGwIJjG5B5p83InmCdc8fZ3XwkorQ0M/Mbe0N
x/JZ9UlJQQpe2aHL0FJ+b89mE78HeHhqH+WPPXoM6xIg7uOfEgSMXdYwa0yN1Djt
43gsXgHR1q/SWeqmYXJFJxuPtdKWy8HiHsjCNf/763tkjcifeGGVhON74a/21u18
9feerNRAbSb08l/MArpm
=k4Ci
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_53_07_+1100_oSzT.1M0ZZWoifDo--
