Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1E3BhE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 21:37:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50220 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab1E3BhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 21:37:03 -0400
Date: Mon, 30 May 2011 11:36:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: linux-next: build warninga in Linus' tree
Message-Id: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used

I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
difference.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN4vS1AAoJEDMEi1NhKgbsj4cH/3Yhe1Yj2R3f9JVd+hvJOP+P
Uddnm7QkcbUOOJfUOZPI2gZJWX0ph3sjNLOkyZk4l3hmxiu/yaSKKE4brC2ZldyE
1uHUhGz43HsUc6HtOKF1j/K3cG9F3bigvt6zLKlwEY6OWGV6dGIs+RCf8WGt1wbQ
PUB7mdS3mh5nKHW3fI+H4saNJ71H/enzUhRJ2ZLsWYCqyri1gQZkMcxUpCangoHj
+0D2MbegjpFq2F9HHsWoHn9Q4DNFKxHPGZBlH2E+QhfGZCnJ48BpzGd7pCDu54nW
EFhvgf+cRjOVuzDOMNPB+ijifIylzwn6blWAIKwAiWLPgnzNTjK5SmFM9WaSszs=
=luuw
-----END PGP SIGNATURE-----

--Signature=_Mon__30_May_2011_11_36_53_+1000_o8uk4EXqcJcBbuII--
