Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab0JZATy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:19:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab0JZATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:19:53 -0400
Date: Tue, 26 Oct 2010 11:19:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Smart <james.smart@emulex.com>,
        Alex Iannicelli <alex.iannicelli@emulex.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-Id: <20101026111944.9139ee1b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Oct_2010_11_19_44_+1100_uchaXu7I6kw5gz_h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Oct_2010_11_19_44_+1100_uchaXu7I6kw5gz_h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/lpfc/lpfc_hbadisc.c: In function 'lpfc_mbx_cmpl_fcf_rr_read_fc=
f_rec':
drivers/scsi/lpfc/lpfc_hbadisc.c:2332: error: implicit declaration of funct=
ion 'msleep'

Caused by commit 2c09c56c0967ff6a0974ebe2b03da39b26073dd0 ("[SCSI] lpfc
8.3.18: Add logic to detect last devloss timeout").

I have used the scsi tree from next-20101025 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Oct_2010_11_19_44_+1100_uchaXu7I6kw5gz_h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxh6gAAoJEDMEi1NhKgbsVQYH/06ibO9YmfzS9fKVNT2R2wQn
UPTfQEbDbABHPE7t5jfILlkJSc2aaNM0+Offe3FxpXUJ4fDK7LgHGvHuqkfi5jdD
q6E6bkq3aJlDb4MALetN9hlTSz0e619O6tI3mOsRTbvElVyPLuqi35rT71pjBvVY
z272nSbQTu3xbfwYAUl9ipsY9ciR7HAZHTbosTB/ROAZEeHW/SiaTSnDfD8pQUVt
bT6lPuxWUpvD1d0D83V64k2QAfMGdbxF8CGQegpZLR1wIV7kKJyhS0Koq99Y5Afo
1t2lsmBE9yCCeDrz3ehXNN4AzVhF8NMpSiJ0clJDne/sKOC4njhkA5r5Oy0+4go=
=1dNA
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Oct_2010_11_19_44_+1100_uchaXu7I6kw5gz_h--
