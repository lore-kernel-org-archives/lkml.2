Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1BVDUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 22:20:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50262 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025Ab1BVDUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 22:20:14 -0500
Date: Tue, 22 Feb 2011 14:20:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20110222142005.946468ee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_14_20_05_+1100_uFx4c+j_aWkvfbkf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_14_20_05_+1100_uFx4c+j_aWkvfbkf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/ab8500-gpadc.c:20:36: error: linux/mfd/ab8500-gpadc.h: No such =
file or directory

Caused by commit 38a7f5349d3820b3603384733cd2f35913f923ea ("mfd: Add new
ab8500 GPADC driver"). Looks like an include file was forgotten.

I have used the mfd tree form next-20110221 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__22_Feb_2011_14_20_05_+1100_uFx4c+j_aWkvfbkf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYytlAAoJEDMEi1NhKgbs39AH/04gZg0jezwfB+ONHdWS+ao4
w+t3mkWqIh6VtFs+qHtvrUby7xmAketRhNgXuRxFQmSFvoWDnWHsK4qaEe+2O1Rz
zRPqedZrsyjiGAFHnY0vVaZDG0MC0N3ED9m7VifH+pvYGSZOEuXc2kMw892nulBO
lsHgPZkNBW8iZxe+d4etKNFab0W96kMACkmwCqTHdM/R90ze2gIRzuZ+7gCViT4F
J4W2BntpPk3c5wocvnFwx3FGBb/OjG0PpVwspQkXCYC5aZqeGY+f03ENZyKnGTcG
PGcuIWF8dR1SqUb3KqcbazOLH+QQKJIFY+tsQjXgTJralQ5eYnLOq5mC54DRMV8=
=AnHX
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_14_20_05_+1100_uFx4c+j_aWkvfbkf--
