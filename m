Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090Ab0HGCV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 22:21:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46338 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab0HGCVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 22:21:24 -0400
Date: Sat, 7 Aug 2010 12:21:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Karen Higgins <karen.higgins@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: linux-next: build warnings in Linus'  tree
Message-Id: <20100807122116.e6421ea0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__7_Aug_2010_12_21_16_+1000_b4Bn5By3RW2..scu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__7_Aug_2010_12_21_16_+1000_b4Bn5By3RW2..scu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

today's linux-next build (x86_64 allmodconfig) of Linus' tree produced
these warnings:

drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_get_flash_info':
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'mid' may be used uninitialize=
d in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'mid' was declared here
drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'fid' may be used uninitialize=
d in this function
drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'fid' was declared here

Introduced by commit f4f5df23bf72208d0c2f1d8be629839924c2f4c2 ("[SCSI]
qla4xxx: Added support for ISP82XX").  I don't think that these are false
positives.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__7_Aug_2010_12_21_16_+1000_b4Bn5By3RW2..scu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMXMMcAAoJEDMEi1NhKgbsrlgIAIXsQM88aiKKZaZrVOYmOXz+
GxSFwnkWOxcGFIsRpsRdUPJyBv5w0RN0jxf4VBHbdx6TRyAyBVn8OFkRu8zjk7KY
A4DBzyiC/ZrJkwMb+YqE6x6QkxPKD4iEobtqRHsWuO4zJXDyXTKamPZZH3UksLuS
GQNTgn86yplClb+w6ffYip5rXlEJ7o68MWiKR0Nm7g3AF7EfPW/if4/wLY++Rzyh
CXO+wbh6BR57X6wvOew5PsjhSY21PUdNJXXh6MwMIF0lOWrBWZ5Cwrf4hi3RTTmE
dOBfE9jZFuB2R3e+cc8UoPnHm9Zh7LmMPt46Afy25Sf3d50zSuPRQ136JA23bDc=
=+H9c
-----END PGP SIGNATURE-----

--Signature=_Sat__7_Aug_2010_12_21_16_+1000_b4Bn5By3RW2..scu--
