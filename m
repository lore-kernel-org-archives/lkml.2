Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab1JKF36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 01:29:58 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:53561 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab1JKF34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 01:29:56 -0400
Date: Tue, 11 Oct 2011 16:29:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the md tree
Message-Id: <20111011162948.c3ca0fc8726a7d7b80e39744@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_16_29_48_+1100_QlV8u651g2m9QnOs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_16_29_48_+1100_QlV8u651g2m9QnOs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

After merging the md tree, today's linux-next build (x86_64_allmodconfig)
failed like this:

drivers/md/dm-raid.c:597:25: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:614:24: error: unknown type name 'mddev_t'
drivers/md/dm-raid.c:614:40: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:654:23: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:654:41: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:692:34: error: unknown type name 'mddev_t'
drivers/md/dm-raid.c:692:50: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:812:27: error: unknown type name 'mddev_t'
drivers/md/dm-raid.c:812:43: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c: In function 'analyse_superblocks':
drivers/md/dm-raid.c:852:2: error: unknown type name 'mdk_rdev_t'
drivers/md/dm-raid.c:853:2: error: unknown type name 'mddev_t'
drivers/md/dm-raid.c:853:19: warning: initialization from incompatible poin=
ter type [enabled by default]
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'disks' in something =
not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: warning: left-hand operand of comma expression =
has no effect [-Wunused-value]
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'disks' in something =
not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:856:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:857:12: error: request for member 'meta_bdev' in somet=
hing not a structure or union
drivers/md/dm-raid.c:860:3: error: implicit declaration of function 'super_=
load' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-raid.c:882:2: error: implicit declaration of function 'super_=
validate' [-Werror=3Dimplicit-function-declaration]
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'disks' in something =
not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: warning: left-hand operand of comma expression =
has no effect [-Wunused-value]
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'disks' in something =
not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c:885:2: error: request for member 'same_set' in somethi=
ng not a structure or union
drivers/md/dm-raid.c: In function 'raid_ctr':
drivers/md/dm-raid.c:965:22: error: 'super_sync' undeclared (first use in t=
his function)
drivers/md/dm-raid.c:965:22: note: each undeclared identifier is reported o=
nly once for each function it appears in
drivers/md/dm-raid.c: In function 'raid_status':
drivers/md/dm-raid.c:1100:4: error: unknown type name 'raid5_conf_t'
drivers/md/dm-raid.c:1103:4: error: request for member 'max_nr_stripes' in =
something not a structure or union
drivers/md/dm-raid.c: In function 'raid_io_hints':
drivers/md/dm-raid.c:1149:2: error: unknown type name 'raid5_conf_t'
drivers/md/dm-raid.c:1152:46: error: request for member 'raid_disks' in som=
ething not a structure or union
drivers/md/dm-raid.c:1152:65: error: request for member 'max_degraded' in s=
omething not a structure or union

Caused by commits 4251a3bcf0e1 ("md: removing typedefs:  mdk_rdev_t ->
struct md_rdev") and 724d5bc7708a ("md: remove typedefs: mddev_t ->
struct mddev").

Have you dropped better versions of these commits?  Please build test.

I have used the version of the tree from next-20111006 since
next-20111007 had another build problem.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__11_Oct_2011_16_29_48_+1100_QlV8u651g2m9QnOs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOk9RMAAoJEECxmPOUX5FEdJsP/iDJUcpuSTafHhlX874icwHk
+1HIJpp+wtRl25kjumw98dTsCk2m8lur4Q1grztTYoo8fen8mXFMVjw4iQHosVU0
jETgSWnAwKF6ZmtIyv2BAOWiMCQZ77a5dyg36toUr4JlvfS1kKqUhKh8BKzoo2Oy
aBJE3mc7VbDHVEF051ZVYPh92U2HlNQ9wtK0RuFT68nmAFmQJ4wuIxYonHj+FHrO
RMCVb3fla0Jb6Og9iLLUIOQwdALtww76z/H4cExcitfstadGsn1KZB1xqOP6NYU3
y/RdHAarMA/rWeQQ5XI53cmiEN67qd0x6yOrxumk9yS2dEwmnYf5jP+lUwTCSvn6
x9FU9CxGLjxHeRkwPa9XsR1zUVvMkWun0kLsrN+foZMjcTFYsrJ0hcYqiM3bUzsN
p8bN5Jj9flDEvol5KOH+TofT+fYqal7NXEMEXT1+62NWngcaNG4zSWj3RQiKPPix
DQZFvf4ymQaGqw8AAjoCkTqTjZGt9F8CDFhZeNIrO3RyagXRThebAFhXzghmOuVT
nY1YcONUmRvCtmXmA7XhupjNmm5TsKqXManKDoCRDcniOGEfy0kLt9t3STEaW87e
6ylf8tsWTUdvCN84hJeP7tI6PfHCwIMUC/cNfY4G532IntY+2lW1Ab+j7fCv2cim
HdNlqGfKdi5V6wEyKvnu
=k6r8
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_16_29_48_+1100_QlV8u651g2m9QnOs--
