Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab2LJHsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:48:04 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36882 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LJHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:48:01 -0500
Date: Mon, 10 Dec 2012 18:47:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20121210184749.b1902056a8b20a543f5b54ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_18_47_49_+1100_7lGkDvsh5IDTnGSd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_18_47_49_+1100_7lGkDvsh5IDTnGSd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
mm/huge_memory.c between various commits from the tip tree and commit
"thp: fix update_mmu_cache_pmd() calls" from the akpm tree.

It appears that the shed/numa patches in the tip tree have been changed
in today's version of the tip tree and this akpm tree patch no longer
applies.

I dropped the akpm tree patch and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_18_47_49_+1100_7lGkDvsh5IDTnGSd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxZOlAAoJEECxmPOUX5FEI3MP/3EJg/s0jf5nAoNvY77XMJ1q
3VFpST9659mDqIGkVwC5tSVCaoreMcxho+S/xIUDWMp4CGcgQN1A/pSa0moYiMCU
A8MB+VqxHLnRqZwE7+CcMAa6b68TDX1smERSJQcz3jNy+hS5IIwmfeweIub//Ki+
X2L7e7/Qb7ESWL6ArGTYgKOdd4vaq1GBiqcgWtVkGFj9HwQRPol9eYan3bHhv0GT
mh7pD6hSV+mqcZUq39bdYGr6twI3s4Bm2SqfNWufM1iQVYoi3ubyrP2d2w8kCwa2
33aAEAJcQnyoLpuE3E4L/ytNfo8DkuDbLI/741v+cLgfjJxMNYyn9ajCVjCJKogJ
MwpfJKZlH2Rnunk/EnGWFOO4uhnnFmZyS8C/qwe+Do+eqiyZXk2Rs3dOcNcfx/EZ
ukmRhehYfvfAjoCmPBLt4EPCzJZUDbDYJj1BBpHwz1DGPJMH088nVNUlS01d58fS
Jr/ZeV+9kFeapGbNFqcYCRgcosI/rZ+ZN6+7ukIbivobDGYgFDCQudIVviMjMtYK
2VZjGgUZOU66dBZENtMeq8dhX/0+eiBjA2/JrAqGUaZjzX942jOf7/hFGpUm7sZ/
M0p255r8TudKtHYFGh1pBMnRjRMWGTb8yoOewDVQ5UpTKdF1JFpf1jM4ncYI7NYm
aNdTJk1kw7aCW75BE9B3
=T9Eo
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_18_47_49_+1100_7lGkDvsh5IDTnGSd--
