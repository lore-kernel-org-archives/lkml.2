Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1JMGoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:44:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41686 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab1JMGoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:44:06 -0400
Date: Thu, 13 Oct 2011 17:43:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: currently missing kernel devel trees
Message-Id: <20111013174358.b20fedb97c7b53db2ba82ff6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_17_43_58_+1100_QgoXl.BhHOLcJ4Ow"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_17_43_58_+1100_QgoXl.BhHOLcJ4Ow
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

With the mrege window approaching (sometime) I thought I would see how
many of the 200 odd trees that are included in linux-next are actually
currently inaccessible.  The list below (of 63 trees) is a couple of days
out of date.  These are the trees that were hosted on git.kernel.org that
have not popped up anywhere else (or, at least I have not been informed
is they have) nor been resurrected on kernel.org.

Some of these may be no longer useful (please tell me).  Some may have no
commits for v3.2.  But I bet that at leaset some do.

linux-spec
omap
pxa
blackfin
m68k
4xx
galak
sh
rmobile
tile
unicore32
xtensa
configfs
ecryptfs
ext3
fatfs
fuse
gfs2
hfsplus
jfs
logfs
nilfs2
omfs
squashfs
udf
vfs
vfs-scale
pci
i2c
jdelvare-hwmon
docs
kconfig
idle-test
powertools
cpupowerutils
dlm
swiotlb
ibft
iscsi-target
async_tx
bluetooth
cpufreq
input-mt
lsm
pcmcia
kgdb
uclinux
hdlc
drm
agp
watchdog
bdev
nommu
audit
irda
ptrace
sfi
asm-generic
drivers-x86
hwpoison
sysctl
namespace
bkl-config

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Oct_2011_17_43_58_+1100_QgoXl.BhHOLcJ4Ow
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOloiuAAoJEECxmPOUX5FEsF4P/1IMluJ9rHPjBob/7j2egJOx
PYQr9OoyPT6C3Xyjzb0l6z79jC1ThC7GTuP0GQGmHdeNZNHbUM/I6HfTTNkWxKay
4hgD2rtOw1OqlkF4RutcXFQ7EPmS15jidafLieS9Sej18WezJP91Wz9Jes/G4/Og
kAGY2U1TBJkizA3fdIRUoc9zAO1UQNMglz1ywp8vjjnKolBWYpkkLN0TcwulTz8d
7Q+Zri7JZWbVh5XwYmRegglIRmK+xg9GUdiLP/K22nNBufsGqUSoFu7HnYM4lblb
5dcsOv7Fwdh9xoRXMNJpdlsCiXpZPfD4868JbCjTbgG9NQ8bJNfWRVPBLVckOruG
xXQ+UYTRjAHyZ60ttRtad9Agtwn94skK1hzphKcA29/1Xgvp+Aqsfd5lsEknnouo
RX9DRvEIv5V+MmaTgnUKuGOrS2weeeDSYUytCLlgoWEJ+VFsusn6JPFkRtDGxup5
7E4KNVQRXADAs7Sy+uAMrvDI88q+HkjwVNrMLUS/zm1M9o3nrtHGTe/1I67VZErI
kQfpU9sfbFAWQSK4wpgbsE0p7ZNDwtckIEsXGmIkjoCYMZEn/UBeXji6MxewXuhJ
z6cIuH0M+wWZPg0lMEBpbglDU2bautj/QidkH0mWDWPj40r3T4F8rTT2GE4Nokq2
NcryfWi6pyq1VcJVTnbs
=MoCo
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_17_43_58_+1100_QgoXl.BhHOLcJ4Ow--
