Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2AaDZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 22:25:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57512 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161Ab2AaDZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 22:25:31 -0500
Date: Tue, 31 Jan 2012 14:25:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Allyn <mark.a.allyn@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warnings after merge of the staging tree
Message-Id: <20120131142521.852ecb04b07f7174c179b3c8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__31_Jan_2012_14_25_21_+1100_Pz9Fci8mZrb.+VqJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__31_Jan_2012_14_25_21_+1100_Pz9Fci8mZrb.+VqJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/staging/sep/sep_main.c: In function 'sep_allocate_dmatables_region':
drivers/staging/sep/sep_main.c:217:2: warning: format '%X' expects argument=
 of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c: In function 'sep_activate_msgarea_context':
drivers/staging/sep/sep_main.c:3348:5: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c: In function 'sep_create_msgarea_context':
drivers/staging/sep/sep_main.c:3380:5: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c: In function 'sep_read':
drivers/staging/sep/sep_main.c:3466:2: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c: In function 'sep_fastcall_args_get':
drivers/staging/sep/sep_main.c:3526:5: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c:3567:5: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 4 has type 'size_t' [-Wformat]
drivers/staging/sep/sep_main.c:3567:5: warning: format '%X' expects argumen=
t of type 'unsigned int', but argument 5 has type 'size_t' [-Wformat]

Introduced by commit ff3d9c3c90c6 ("staging: sep: SEP update").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__31_Jan_2012_14_25_21_+1100_Pz9Fci8mZrb.+VqJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPJ18hAAoJEECxmPOUX5FEWucP/ReTXZgdvThIwegeKscKi6Qn
fdkiL4DrlShChtV1cSaW7hv/bm+p7R3jU0ccDul/E3grFB+yU2nYwvQOFXtM+C2k
5rID4VrSxBaUIbKyRQ1KzHjOF9qMZEudJpfnnlr33YqRMkH5fJH6ko0x8YIGPD3s
q+TRgcJxnREWWgwwnLuw8yhfvOCobsYxNKxlS0EemjyHjyXPMzQg5LgIxRapz3/T
hdot+TNR7JKgC5DBdoTdHEtSaEP3CNYaK+yzQHC1XsLpD9si/HOOO0WBK+u0KcdU
zasoic3TtD0z3fnOuRKhfu1igzJ7sMRM3dwnErtUnWCbkPyALlv6FvksmruWlTfu
gnZPZfbB2VW/kXsgg3uyDTMSEEzZP8G0j6FRft9RCMrr2xLhvlYN2TDhq99KvCGv
LQICSAAdfUJFvYtJjzDMbAXH+Vp36qvUkiLHC3ddgvChVcpHHenL4h+2gEwaVFSm
9l0Zh0vxHSpFKYTGzs2ZbGpAVSfRsy73Aph9x0G02Zp3cNuhUWUx4mAPPQa/YRyG
M8SQA/9a2sMyDIbioNvAzwrL/RcdlnM+DC99dCXvPVRZkjK8YhKWvoc9ILYrFW4Q
E8z2fNlDKkmZqypkSUtmjU3PnO+cvN9UTN3mh8dEV5ktpMK9dwWS7lQhvT0Aa9+E
4Tvsu/xJoj5IyEaSsnOG
=1ECR
-----END PGP SIGNATURE-----

--Signature=_Tue__31_Jan_2012_14_25_21_+1100_Pz9Fci8mZrb.+VqJ--
