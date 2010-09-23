Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab0IWBei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 21:34:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51299 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0IWBeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 21:34:37 -0400
Date: Thu, 23 Sep 2010 11:34:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: linux-next: build failure after merge of the nfsd tree
Message-Id: <20100923113429.88f865d2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Sep_2010_11_34_29_+1000_Sa_YJ8_FOmsEKYn6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Sep_2010_11_34_29_+1000_Sa_YJ8_FOmsEKYn6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Bruce,

After merging the nfsd tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".get_task_comm" [fs/nfsd/nfsd.ko] undefined!

Caused by commit c67874f942e30039442d925b03793e0a46ddcddd ("nfsd:
formally deprecate legacy nfsd syscall interface").

get_task_comm is not exported to modules.

I have used the version of the nfsd tree from next-20100921 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Sep_2010_11_34_29_+1000_Sa_YJ8_FOmsEKYn6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMmq6lAAoJEDMEi1NhKgbsdNAH/3z06fMB97UaSWCUfq9Db/rO
XBIhYRHKozn1TmkAkxWl+1NM/LLKDVMgGP1dFIaZUQI+ah4V7uyfKCvfc2xZgNrY
4JVVttb+O5dvaUy18/cnbaai+JJQmIKLi1lCwVKJ3UfY6sFTsVeOnNbL8Xq1BS5X
xSh0opZLd3jTMhX2ntYc+hMTF6rFccxOvDr2K0o42q3z2VTXdM+R9KB7/6OwXNs7
HV/BMbB2/ojH6J3OqM/GBSdDuXV2CU0GWg9mOTE30nXJXZX+VA2e/V6FbNcfgJVc
CrMde1o/cFsiE7CU2QnTr15Ipr5C/9hvDK8D3CXVObEYk0mGBQdVvPx8nmDdkCQ=
=M2ag
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Sep_2010_11_34_29_+1000_Sa_YJ8_FOmsEKYn6--
