Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab2KID6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 22:58:42 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58617 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab2KID6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 22:58:41 -0500
Date: Fri, 9 Nov 2012 14:58:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20121109145832.dfdc4985b490290f5e4f185c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Nov_2012_14_58_32_+1100_gV4qBXsezaOX2H5+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Nov_2012_14_58_32_+1100_gV4qBXsezaOX2H5+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (i386 defconfig)
failed like this:

arch/x86/mm/hugetlbpage.c: In function 'hugetlb_get_unmapped_area_topdown':
arch/x86/mm/hugetlbpage.c:299:20: error: 'mm' undeclared (first use in this=
 function)
arch/x86/mm/hugetlbpage.c:299:20: note: each undeclared identifier is repor=
ted only once for each function it appears in

Caused by commit "mm: use vm_unmapped_area() in hugetlbfs on i386
architecture".

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Nov_2012_14_58_32_+1100_gV4qBXsezaOX2H5+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQnH9oAAoJEECxmPOUX5FE5JkP/jgXXh9Goiv9HOFNoQkFTZru
iIVZJPs/RHam5e4SmmSlm0UOgDaHAopdC2W0eCV5xbNhys6InUU4F+2rXWFi9paj
Ae8LlWWOlDwpylEhR5fVvxAys85AXRx2ZvLomkf9LB9PVksH6y3JyMX78bckuE15
QpqUC79EaPRDGqx6yNOaU6TLjOI9CbmdInV26UUWR8tdCwOzmCJQBLrtFD9x2op9
Ym0aswzdc8tRAEFo6lPiNKsI5asTdqTyL/HvGd52iG+3U1oG4LPLusgFBkUD7Usa
yNsbAAWZ8lzXPWYWLvjwIgvkqhWw2gRvKDgGcGo6GbqehiLxrf647UJmEX6hbJc6
e9LUv+S6QeHSIv1ry0QwjlUZllh7SEcTZI7QsbgJThrauk477e+4nS2R49fjWexi
qq99ZvT/+z85f1PT2VBWu5lAG7euxbmMzNnYMiDxtNRmq/DaH8KIloM0EKTN6sOt
aleAWfTGNMUjcBcOJYXWYzF8f3lwFxm/K13LDiIaIESLe5uAA50ppb2J1XLilQ2P
chtFAWGYSuhUy9xfv3R+1GZbUCyGBYTzNgVOBod8azd/dq6WENaUYS7EXG2eg+P7
t7gB65cDamKGqCp64no0lOG8RZ5IKHqbsnSlmdK2h23fPQQc1SSFDwZLym4+pbKK
8jWoPlm7llqm3VMpRuSV
=E/fl
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Nov_2012_14_58_32_+1100_gV4qBXsezaOX2H5+--
