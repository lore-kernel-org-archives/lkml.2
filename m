Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967Ab1GTEJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 00:09:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60054 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab1GTEJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 00:09:09 -0400
Date: Wed, 20 Jul 2011 14:08:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: linux-next: build warning after merge of the scsi tree
Message-Id: <20110720140859.b7d44a8c9aa20a43ec50f054@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__20_Jul_2011_14_08_59_+1000_VxJuSKTbK/Q1ElmT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Jul_2011_14_08_59_+1000_VxJuSKTbK/Q1ElmT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/scsi/mpt2sas/mpt2sas_scsih.c: In function '_scsih_sas_broadcast_pri=
mative_event':
drivers/scsi/mpt2sas/mpt2sas_scsih.c:5591:40: warning: unused variable 'eve=
nt_data'

Probably introduced by commit f93213de5c28 ("[SCSI] mpt2sas: fix
broadcast AEN and task management issue").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__20_Jul_2011_14_08_59_+1000_VxJuSKTbK/Q1ElmT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOJlTbAAoJEDMEi1NhKgbsFs0H/3wHCw7u7hu2vnnBQ7efxyF1
yXp7MM5uhf1ugY1/wsuYqp/KSEVyy0gvAQ92U0sBV5XZ9bT1gq0mWTsZRbV5Ngzu
5DGzQ1nSNi31sdRCI1tvxknCWpvKDN780nXs59O98CObjT2DyM7WOF8OCGzYecmb
/DKY3cAj1s+qUsJ8MF+2Iq3RGY3Lbayfcxn2IdjcQF9cL/CGr+uz7th+IR6YEMBx
M2F6P6yH8fqleWQUN/AQsmJ5DIlTwQ7S+mnwVGxqWywxVmwz/qdSxzD8wCRuMmVs
nTj8zmrtp65nhdaauXra5z3s1V6R8TJK8WNVKFW9p837b4rexnWUtjeaeoYEFvQ=
=kYFM
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Jul_2011_14_08_59_+1000_VxJuSKTbK/Q1ElmT--
