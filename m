Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab0HDDNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 23:13:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47649 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757957Ab0HDDNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 23:13:09 -0400
Date: Wed, 4 Aug 2010 13:13:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: linux-next: build warning after merge of the scsi tree
Message-Id: <20100804131300.8570fe77.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Aug_2010_13_13_00_+1000_gkjS+vD3cs9/D/PB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Aug_2010_13_13_00_+1000_gkjS+vD3cs9/D/PB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/scsi/scsi_sysfs.c:384: warning: dereferencing 'void *' pointer

Introduced by commit db5bd1e0b505c54ff492172ce4abc245cf6cd639 ("[SCSI]
convert to the new PM framework").  This build does not have
CONFIG_PM_OPS set.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Aug_2010_13_13_00_+1000_gkjS+vD3cs9/D/PB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMWNq8AAoJEDMEi1NhKgbs9acIAITbCHXGDwOTZRj63wqyw5El
f+VqpRlmXboHeF/wkVB3Snq5alElv/8sOyvYODUe/5Dy/8xH21HvEaOaOPENGndu
KZ1y9GXKEb14pFZuQfpAd5RZjJdnoGRUV7w7DiiT+8iuWTYBIN7msi1xAwpPFoQL
E3kK/bX0d4HvvKfbTyVnZvJyQfuW/DUBYVCxWqFVnrJiGxF+n9sZdfg2ZqE8QNGF
aDJP+3KjZNDx+yL4jrJPhTdu7xLpr01FSppMG8pl67SM5gF3/7U9+hJVOUkDJuDE
WkRy7pKxiLP7qVJpTF0rVArvrmgLlt1SKpP/D0SLlACYnTiNepKpzI9owPo4SVk=
=YRjD
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Aug_2010_13_13_00_+1000_gkjS+vD3cs9/D/PB--
