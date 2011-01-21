Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1AUBFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 20:05:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37519 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121Ab1AUBFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 20:05:42 -0500
Date: Fri, 21 Jan 2011 12:05:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>
Subject: linux-next: build warning after merge of the cifs tree
Message-Id: <20110121120524.23dcf86d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

fs/cifs/cifssmb.c: In function 'CIFSSMBEcho':
fs/cifs/cifssmb.c:740: warning: large integer implicitly truncated to unsig=
ned type

Introduced by commit 766fdbb57fdb1e53bc34c431103e95383d7f13ba ("cifs: add
ability to send an echo request").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNONvUAAoJEDMEi1NhKgbscaMH/3zBhJ22dWbfQms1Yc3o5yLb
cvzKHAcAALzde9zb2MHX1Dtgphzxg/Ud2nHUGmU9sQiOwC4P+RD50YaGu/Dds8uU
0oGO0GFZpHCXIf9QddZ1LsWhStxLSMEWr9pl1+H+6LmTZJ7BXWagPEaxE3k3zXPq
jUbcZ/M60kG21GBMLzpohW2wmFg/xTWBOol1lbEdg2KU4zIIveq6I/Uut3IY1/lX
TOq6BuRiPDi9bkjMIGPME35AtExkYx7IoL5zzmpb2PV988cLLvJlT9/phNyM5qvY
2Bv1zf+8kwAmjcUkxp3OWJLXrTiW171xXfqpj1uBnZrzLPbWkQtgH28ZryT4X3U=
=mcZp
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jan_2011_12_05_24_+1100_GjcL2gQO./gwcLLs--
