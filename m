Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab0LMCeO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 21:34:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49810 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab0LMCeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 21:34:12 -0500
Date: Mon, 13 Dec 2010 13:34:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build warnings after merge of the mfd tree
Message-Id: <20101213133404.074eb5df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Dec_2010_13_34_04_+1100_0liaiCmofSiixdmF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Dec_2010_13_34_04_+1100_0liaiCmofSiixdmF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

drivers/misc/cs5535-mfgpt.c: In function 'cs5535_mfgpt_probe':
drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigne=
d int', but argument 3 has type 'resource_size_t'
drivers/misc/cs5535-mfgpt.c:320: warning: format '%x' expects type 'unsigne=
d int', but argument 4 has type 'resource_size_t'

Introduced by commit 9ce4f5640c34ce4a468cfead9b848aef424c33ab ("misc:
Convert cs5535-mfgpt from pci device to platform device").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Dec_2010_13_34_04_+1100_0liaiCmofSiixdmF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBYYcAAoJEDMEi1NhKgbs6u4H/RF16in+odKsA4901V/mNQuU
l/c0JnlLX4XIeKFcNr2XcFuYgyJR1PQJYALYfv2Ds8mgwRgdIDESMynq11MOepYL
r1cVDyWjRyZ8/jUGSXM8CyKuoguA+36EyzV5qsN/DEkFDNJOANxCyhBAy7GDTKCa
hVTFTLkL0BwY5f4erNlQ85NufRot4D9rsKg34EaXJPCvdqrhEoXZatGTqa6k82pq
ijgzwpTw/tU8OPi53jacTp9bx4pgA8OW4ebEmip8ziIU3jKW07X0/LeTPIK2ilnj
WgiLhdVm/5gTIerK+8Dn4L8vkBsVr4UEZ3Mi9/uJolw0a8T/GtDMCMpSL7aA7bk=
=mIFt
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Dec_2010_13_34_04_+1100_0liaiCmofSiixdmF--
