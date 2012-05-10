Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab2EJIl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:41:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43552 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab2EJIlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:41:55 -0400
Date: Thu, 10 May 2012 18:41:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Ik3DoXJ0b24gTsOpbWV0aCI=?= <nm127@freemail.hu>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the  tree
Message-Id: <20120510184139.2d62758d8bc761c4327b9f99@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_18_41_39_+1000_NTpiR.Hg4bQsddoP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_18_41_39_+1000_NTpiR.Hg4bQsddoP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/kernel/apic/io_apic.c between commit d1ecad6eee86 ("x86/apic:
Only compile local function if used with !CONFIG_GENERIC_PENDING_IRQ")
from the tip tree and commit "arch/x86/kernel/apic/io_apic.c: move
io_apic_level_ack_pending() inside CONFIG_GENERIC_PENDING_IRQ" from the
akpm tree.

These are the same patch with different commit messages and authors.  I
dropped the one from the akpm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_18_41_39_+1000_NTpiR.Hg4bQsddoP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq39DAAoJEECxmPOUX5FE2CIP/REsX8yZOmf3gQikffXmXKkH
m608oTjbCr1Lg13DMIyjmhsXQipcN8jj84k+fDJw0T2no+Y56JmvF4ItYlq2Issm
bGukZofdd+NwUf9WV0hEBj/M29U2GwrtxmPhwnjXd4IJW04dN+0V/8aiMAAIR2ko
hUFes6A3vBBrh8vkF2ijrRuBrJNHLBPah6wFqp3fYqZq6Z2Q2w76ZKhXHsaHHLYn
Z/J+b2ZoEXAKOjQhCv0Y4d/1Dad3uSqYoUGzk5b+vDsjAh9WUTHfL1Kuzvk4yAJJ
4GSIOVIJXmXZSwtDSAU/XW0Zdz4YmS6BsJTrcO8g4Gzc4Q3UnC+IHV7N6E9hQYy3
b0j1DDduIC0RFnCGkK3RjXURHtaGBHJcFHTJ9Pn1KeC7/smKsyWTJfO6Wqxz7Bkr
weIvwgk81hDXqHHNkU5N6v/Ukqn5P3gY5DOrGuRPNcGNkl5UNx8Q6XV+lpbcWCiC
2PtD/zKkBmBasli659WUJLxOkDISJuLdCmUzMh6EtTQWm8UejUERlHaMWISDNpib
IrvhAjVW5dTfSzKWbozsKo+hT9aqsEGPU3aAp3+9Ii1xqH2ypSDxgkS0J7vMEIso
hXoDI+NVUBMKI0JoZkxR12Ye6gyntLR5mK3Dg3F2jGkdYgMK3mG3ufTFgY53VBHh
cHjPJlWk1mdQNBapcd+b
=MNI6
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_18_41_39_+1000_NTpiR.Hg4bQsddoP--
