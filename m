Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab0JKFEo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 01:04:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38236 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab0JKFEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 01:04:43 -0400
Date: Mon, 11 Oct 2010 16:04:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: build warning after merge of the final tree (tip tree
 related)
Message-Id: <20101011160429.81483d01.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Oct_2010_16_04_29_+1100_rMBA4OkWerpIvzGB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Oct_2010_16_04_29_+1100_rMBA4OkWerpIvzGB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) produced this warning:

WARNING: mm/built-in.o(.text+0x25ab8): Section mismatch in reference from t=
he function memblock_find_base() to the function .init.text:memblock_find_r=
egion()
The function memblock_find_base() references
the function __init memblock_find_region().
This is often because memblock_find_base lacks a __init=20
annotation or the annotation of memblock_find_region is wrong.

Introduced by commit 3661ca66a42e306aaf53246fb75aec1ea01be0f0 ("memblock:
Fix section mismatch warnings").

Sorry, I seem to have missed this before.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__11_Oct_2010_16_04_29_+1100_rMBA4OkWerpIvzGB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMsprdAAoJEDMEi1NhKgbs3F4H/3ABEr2j31jdcwt+JVXYErLD
30xbEhTbt/XqGczDd8dRv7wnRSKQD6vBfdGZ1rJgWCA5+/l+8tgWWZMYCf9pc7OX
CHXZlbFG32BSJwgKyXu9RVxtPEuMiHMMnLVFykmraKqa60GXQxughLoiKQfTNEv6
1QH1beowOb67M8e8gl3StC9aiBW+KWBVlM8zH1Fn02HbcuWLmy1LoQ9LXSiRMyRJ
+9zeMDtkBkf5fVXX7p9lgrPdPuzc/htESz8LlZQiK8HUS/GKO7PgsIDNRlHhx7iI
1cbTv6armvg1NxJoTjhEN/DnFM/MSo43hv83bFE8aGwQMrO85+o1dcKgpSLYy8k=
=pS7A
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Oct_2010_16_04_29_+1100_rMBA4OkWerpIvzGB--
