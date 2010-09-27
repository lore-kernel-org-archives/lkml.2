Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0I0F2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 01:28:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41782 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0I0F2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 01:28:13 -0400
Date: Mon, 27 Sep 2010 15:28:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: linux-next: build warning after merge of the final tree (hwpoison
 tree related)
Message-Id: <20100927152804.57c2d66e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Sep_2010_15_28_04_+1000_f2+Jr80TXOF8=to9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Sep_2010_15_28_04_+1000_f2+Jr80TXOF8=to9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

After merging the final tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

mm/hugetlb.c:2950: warning: 'is_hugepage_on_freelist' defined but not used

Introduced by commit 19b31e29073e272e49a3d38972c132c49383d5d4 ("HWPOISON,
hugetlb: add free check to dequeue_hwpoison_huge_page()").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Sep_2010_15_28_04_+1000_f2+Jr80TXOF8=to9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMoCtkAAoJEDMEi1NhKgbsmAQH/ihHTGfIkXmMwXQXIQ5W/avZ
2YWz0NF999CgiuggbjEFGcwof/W16Lrr1t6qsBBIyeoWV3j8J7GU8JUbjntXY2SE
Ss+NMsZ2yp92FBBTMkwcOy3PcIZeRG93XfQsVCJYAHUBmMfjePovwyXaRQEU/Axr
MYiUtFOd8lm3Mol+uCGIXda0vnM/WCvn0AUoTD+ulQOK83F2SBAGFcMzsCNmtosD
r4ZFkoCohXWaBGABPVRC0I0hByXLJGcTHZ9k+tZSWI/ALGfL//+9SjwvHvlq5KCV
xIalrlgy/MMiiW6CGeCV2pFQKGr5Jvc5REoWJwzTMZd/Bic4HQQN8STumm1eanU=
=j+Wl
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Sep_2010_15_28_04_+1000_f2+Jr80TXOF8=to9--
