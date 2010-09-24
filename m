Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0IXDzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 23:55:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34652 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0IXDzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 23:55:38 -0400
Date: Fri, 24 Sep 2010 13:55:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the irqflags tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/sess.c: In function 'CIFS_SessSetup':
fs/cifs/sess.c:595: warning: unused variable 'blob_len'

Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
CONFIG_CIFS_UPCALL is not set in this build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnCEzAAoJEDMEi1NhKgbswIUH/32Piz4jPU/U+02C1zsmr1+Y
qxR6qLiPlgs60MbbwpCoIASsDR+1rcby7n1dyVTphpHRIjAWwx6LsGvKLrITZ4Wy
4vP4aPvL2fBxEtZPUZlkivyNgUdAU7+fzYa4pEQyIoraVmX6Xq7GvvwCQYsRJF7j
ZYcu1Zar5DoR5IPkOG5uDbEGDa+dTFooAMisgYK9owybFIpye7QZmC12531Pm4Vu
qmu8jzDa8FwTs4U9CQobdXveImJR1gRuCuypEQRiqOx/zvqmlAPbgJJvLpGUqrdU
dgytTQssDyCJMfzLeYZmYcymnkkg2rqZ+DkQlZovpEwF483pzjz1SvA+uzBqWdI=
=9jLj
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Sep_2010_13_55_31_+1000_d3jqRQNbsDsMnVps--
