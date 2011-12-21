Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1LUAOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:14:04 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:50158 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1LUAN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:13:59 -0500
Date: Wed, 21 Dec 2011 11:13:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Boyer <jwboyer@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suzuki Poulose <suzuki@in.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build warnings after merge of the 4xx tree
Message-Id: <20111221111349.c9d73384a0a2c89cd211239e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_11_13_49_+1100_v28VHEAqYHF3mQu2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_11_13_49_+1100_v28VHEAqYHF3mQu2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

After merging the 4xx tree, today's linux-next build (powerpc ppc64_defconf=
ig)
produced these warnings:

WARN: Uncompressed kernel (size 0xe32858) overlaps the address of the wrapp=
er()
WARN: Fixing the link_address of wrapper to (0xf00000)
WARN: Uncompressed kernel (size 0xd6c9e8) overlaps the address of the wrapp=
er(0x400000)
WARN: Fixing the link_address of wrapper to (0xe00000)

Introduced by commit c55aef0e5bc6 ("powerpc/boot: Change the load address
for the wrapper to fit the kernel").   Maybe "WARN" is not the best
prefix for this.  To me it implies that something may go wrong and there
is something to be fixed ...  If this is purely informational, then maybe
"INFO" would be better.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Dec_2011_11_13_49_+1100_v28VHEAqYHF3mQu2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8SS9AAoJEECxmPOUX5FEAG8P/1U/McLvI066uiG1yqiIHkcy
WtOr0RLXtW76TVfubMhCU+XzrOebWR09zLbTmKu1dBhjN7mZvIyvRmvAMjHIVvo8
HSDEs7PT+HMIEg7ZS9BMAbXTJfwEaOILt2Yw46Xw0UOylsHopU77aOuKLJ6L4x2q
YxxtWMcJMSPrxFcFBd5yqL2sY5TCFflmrnZ40Tovj+oxX/Yjy0xG6KkmfZmOCbiX
XAsYxOlZZ0UTW4VjKkgjIKBNrbxr/fH151+/AixyGQAwfd0FxCMfjPrE1s6lnCeT
pfRdqBBU16XbsUUVria2snt+n6twqVgf2YVCa579ztEkdHdBp2owNGNHFD54EWr7
XGWnoiPmDKfvq5BlWOhlpeQX851mez5xXZli0msVLNC4SovQ8uRAJl0pGzcpxfKF
7M3yKiMDQjiSnblLMQ3LDYau9MkoRVafbIcgG11EVomv9Z7q16UKZwkvQh3uHM2g
ONu/IMoyCA4mkJVlh4sgJPyba694fUsoSM34+5/sODP8NmJfyuzacIjpBQT626ku
C6ucCl8wiZF/IOqXY6eioJqJnc1L8Zn28PpwwBCel7yUqt7dJjGQa9e+eNU06Rac
+UDdF7o8pThyr8G0eOdnMmoj17xCl1i3PlE6qbEUa2Ate1BmOURDUhbOWRYiAC0E
XGVOtCruXawgxFuqwfzm
=yhDc
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_11_13_49_+1100_v28VHEAqYHF3mQu2--
