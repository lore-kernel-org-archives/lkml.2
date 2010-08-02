Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab0HBES3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 00:18:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50439 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0HBES1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 00:18:27 -0400
Date: Mon, 2 Aug 2010 14:18:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: linux-next: build warning after merge of the final tree (usb tree
 related)
Message-Id: <20100802141823.143b2a36.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_14_18_23_+1000_3k1TGobrxsBdi4CE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_14_18_23_+1000_3k1TGobrxsBdi4CE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced these warnings:

/scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_sh=
ow_nofua' defined but not used
/scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_st=
ore_nofua' defined but not used
/scratch/sfr/next/drivers/usb/gadget/storage_common.c:718: warning: 'fsg_sh=
ow_nofua' defined but not used
/scratch/sfr/next/drivers/usb/gadget/storage_common.c:782: warning: 'fsg_st=
ore_nofua' defined but not used

Introduced by commit ed4825f7332669779540be27cb263daf22af3b1c ("USB:
gadget: storage: optional SCSI WRITE FUA bit") from the usb tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_14_18_23_+1000_3k1TGobrxsBdi4CE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVkcPAAoJEDMEi1NhKgbsXEwH/08+Gh+wpscjwsZ+26SnJj39
nNC6BLzhLXE39sFKomD75W62qHApGtyx1rM7H+35nli1MGvJb6UVRYhydSEfBJPE
62CbDgxg94I8pbEjRYzUDw6oXqmbi2uW0ZIx/yUfqwGwBmCyIBRjsUnFZN1Mbh9B
kgUZUIRQUJAaoaT3Iq18XffAwJVrwq+jcPpcaQsTlh1+T8sl4DhyAqAL2XC90zZQ
egM/GkyAo4wsD2XcmlR8Gnqq279uEvvUK8+uXv1uFShl0ThzulMWmRYS5qdobTPp
HSgyfUuM8pIN5C8/4G17qkYWmCHhK9lb6N4vjU5501QUqyrY9IGmJPd0VKqmjW4=
=A1T8
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_14_18_23_+1000_3k1TGobrxsBdi4CE--
