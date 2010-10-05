Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0JEXY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:24:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42433 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757566Ab0JEXY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:24:26 -0400
Date: Wed, 6 Oct 2010 10:24:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed to fetch the ecryptfs tree
Message-Id: <20101006102418.f1962740.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_Oct_2010_10_24_18_+1100_vlGsiZXTzCy4Aq4O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Oct_2010_10_24_18_+1100_vlGsiZXTzCy4Aq4O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tyler,

Trying to fetch the ecryptfs tree today gave me this error:

fatal: Couldn't find remote ref refs/heads/next

I will use the ecryptfs tree from next-20101005 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_Oct_2010_10_24_18_+1100_vlGsiZXTzCy4Aq4O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMq7OiAAoJEDMEi1NhKgbsH9oIAIRrFfIO6z7Uve0x5nf0mt1K
317nE31+blaYMNG3KC74ajrz7oqzQvtcgVRdpqiPxcxxJmUPP2GNDRr+p1qI/2yG
6BytmSFVj24UoeeWl5gE0paKq9Yn0IqsgPkGSY63+W6SeWHuHzZC+fax8C6wLuCA
XOH+oeuYL9gctBcZ9majXTGHeYdNr3XM/ysV2h2g5w5ELbnKEJKxIrZCLSIHVUBU
0jZcoTHGRXn9WUyAdczs4V1equGSVROeTliK/QaTBZKL2N3Cit4DsW/rqlIF6LBH
zuM0rZl1x53roib1tQO3h7rmjSNcGRbVjD1fDlQiU6rZ3cXWIuso1jTIzXxA1uI=
=n25m
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Oct_2010_10_24_18_+1100_vlGsiZXTzCy4Aq4O--
