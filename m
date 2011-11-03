Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1KCBxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:53:34 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:58895 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1KCBxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:53:30 -0400
Date: Thu, 3 Nov 2011 12:53:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: linux-next: build failure after merge of the pci-current tree
Message-Id: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_12_53_25_+1100_Mvdu9EM_GG.a6b64"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_12_53_25_+1100_Mvdu9EM_GG.a6b64
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

After merging the pci-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/pci/ats.c:13:26: fatal error: linux/export.h: No such file or direc=
tory

Caused by commit 571eba1b8aa9 ("PCI: Fix compile errors with PCI_ATS and !
PCI_IOV").

You didn't build this, right? :-(  linux/export.h does not yet exist in
Linus' tree ...  I have used the pci-current tree from next-20111102 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_12_53_25_+1100_Mvdu9EM_GG.a6b64
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsfQVAAoJEECxmPOUX5FEYkcP/2tMq2R+LjyKUhPFNyMA4RGp
ZsqU0nkSuC9roWGex452L8I3+C5yQm5n255EzHMeE5d2+00PYnQmtQd7gEL56yGN
R0OQ40/IDMVC6iaddjVIw6CtcpeFNsFhcUD20tjgxiaao8HOB+r2dD00LlPt373v
cL8nzNAQwy34759qUNLAvEnFaSn7TSbWh6+pBqCf9j6dN6UhAM86DdqilImW7k0f
IRlmN5qWujIQt72n5NsU6kGWUtbREqS4PGoXlEIB+BO1bxqLoZlzfr2uS6cD0S1e
/cxZedzhYhhb3/e/WwiWU75FA/5A50j4mrPc8xnzO3jRZIwln2yUpEMFSoPXrIGa
T3VVI1iOc3EQQQx31xFMHeXSpi8+tSEERA4+MMdEOAk/I9csruSTpf/K8ZDk3Ir3
E8BQL3BElhlhJ93CLRxyLb1v+c9NetfZGnXIEKnqexVbyjLtzzzobdVRU/RTAqO3
0xKEk9nw6esj4Jp/LWOuJIDEdmQMRZ2Q1ICmgeJ5qII4Jzme8/eMRrm3O3bQWzna
t3B2By403mbydzSbZ/ButjTv6vorO6vAz0MAmegDz9EX4uABCoickiNyoPeEEKtg
6QcX4fOEPkJVY/MW4YSgLZs7onJSRTU54x2RJEWEPgWUO4L5v/BAljsbjTQKzS14
JGk8iWad6LpdyiJxSUMX
=GkdP
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_12_53_25_+1100_Mvdu9EM_GG.a6b64--
