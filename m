Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1GYDpb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 23:45:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57446 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497Ab1GYDpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 23:45:25 -0400
Date: Mon, 25 Jul 2011 13:45:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the iscsi-target tree
Message-Id: <20110725134509.3a1c59c07eb7a5608a8712f7@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jul_2011_13_45_09_+1000__9k53olz_UJ=p91p"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jul_2011_13_45_09_+1000__9k53olz_UJ=p91p
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the iscsi-target tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/bnx2i/bnx2i_iscsi.c: In function 'bnx2i_task_xmit':
drivers/scsi/bnx2i/bnx2i_iscsi.c:1233:20: error: dereferencing pointer to i=
ncomplete type

Caused by commit 5dd46e6560d4 ("iscsi: Resolve iscsi_proto.h naming
conflicts with drivers/target/iscsi").

I have dropped the iscsi-target tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jul_2011_13_45_09_+1000__9k53olz_UJ=p91p
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOLObFAAoJEDMEi1NhKgbsQwsH+wbb55/1/BYUWHPjzGh+ImdB
xOq7xkZFm2/oa6rj698QcrfceJ6Lji5O3oOGcXftw5UprVAvhudCHksuLZ7SKyDK
M2sLAQvQPp+5TlGi5yBshXs28xyFmiKo34uDtnOXwAHDUi4Z9IRI/tp0ieiPtGy4
jVim9wmiSsYdQg0JHQknt6rFUqJokzK/FgT3PYDQyL3gEo1tOorDF0YfFF9mzkhm
amoYUx1boi1e1H2kevY95LtrvFx2TNb/0f7qKRxLPKo+87tbQr03bfMXufdxynqf
osJT7v00pJqhoxdXYXEDkOQIGONs6UdTjRl+8iGrWsp9ql3k8BGimXIQjPyVQ70=
=bUx2
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jul_2011_13_45_09_+1000__9k53olz_UJ=p91p--
