Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab1DHDUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 23:20:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49372 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411Ab1DHDUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 23:20:24 -0400
Date: Fri, 8 Apr 2011 13:20:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: linux-next: manual merge of the bjdooks-i2c tree with Linus' tree
Message-Id: <20110408132015.ef5da5aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_13_20_15_+1000_LeOiyEcTewIMrBVv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_13_20_15_+1000_LeOiyEcTewIMrBVv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next merge of the bjdooks-i2c tree got a conflict in
drivers/i2c/busses/i2c-intel-mid.c between commit 25985edcedea ("Fix
common misspellings") from Linus' tree and commit 5c7d3e377ddd
("i2c-intel-mid.c: Remove i2c-intel-mid.c") from the bjdooks-i2c tree.

The latter removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_13_20_15_+1000_LeOiyEcTewIMrBVv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnn7vAAoJEDMEi1NhKgbs+40H/RyQS52snTK9QO9ybmf3LPDE
VYYpVjCVnh2ccTC8r8IwwHA/e452liuGA69h/ZuTpfS1BzNqWnlrowCc+qOquHgk
dAmFi3jhk+kPRLbMAV8UX0iHVbKAoiGNbotPUgWI6dDg4VLOD6aFCFeH5YAHU8ku
RDD3VAt+Z4Ao20GQEA+weQyUKKL3t4DnWYncx5g0pbfslV2whp+351E1FvIANrSG
+KEhrDjijn3q8yBjmy3YRZ8eAIdr60HB5J3tghk/oNDg/rG3s9Td4pUjT1qX9PPK
fzz3Yi7XGnGoLjKbN0sIpRxflewy3Efk+dm5gFNxch3Cdh8CkF47PwZiS9Tri+A=
=8uel
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_13_20_15_+1000_LeOiyEcTewIMrBVv--
