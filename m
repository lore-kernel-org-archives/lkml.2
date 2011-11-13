Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab1KMNh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 08:37:27 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40648 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab1KMNh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 08:37:26 -0500
Date: Mon, 14 Nov 2011 00:37:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org
Subject: linux-next: missing trees
Message-Id: <20111114003716.40787de80a8b2925aa76ca32@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_Nov_2011_00_37_16_+1100_+vNQSFqYAUuuAhEq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Nov_2011_00_37_16_+1100_+vNQSFqYAUuuAhEq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The trees below are still missing from linux-next.  The URL column is
relative to git://git.kernel.org/pub/scm/linux/kernel/git/ .

Tree		URL				branch
----		---				------
audit-current	viro/audit-current.git		for-linus
sh-current	lethal/sh-2.6.git		sh-fixes-for-linus
rmobile-current	lethal/sh-2.6.git		rmobile-fixes-for-linus
linux-spec	dwalker/linux-spec		for-next
omap		tmlind/linux-omap-2.6.git	for-next
pxa		ycmiao/pxa-linux-2.6.git	for-next
4xx		jwboyer/powerpc-4xx.git		next
sh		lethal/sh-2.6.git		sh-latest
rmobile		lethal/sh-2.6.git		rmobile-latest
unicore32	epip/linux-unicore.git		unicore32
xtensa		czankel/xtensa-next.git		master
configfs	jlbec/configfs.git		linux-next
ecryptfs	ecryptfs/ecryptfs-2.6.git	next
fatfs		hirofumi/fatfs-2.6.git		master
fuse		mszeredi/fuse.git		for-next
hfsplus		hch/hfsplus.git			for-next
jfs		shaggy/jfs-2.6.git		next
nilfs2		ryusuke/nilfs2.git		for-next
vfs		viro/vfs-2.6.git		for-next
vfs-scale	npiggin/linux-npiggin.git	vfs-scale-working
kconfig		rostedt/linux-2.6-kconfig.git	for-next
cpupowerutils	brodo/cpupowerutils.git		master
swiotlb		konrad/swiotlb-2.6.git		master
ibft		konrad/ibft-2.6.git		master
async_tx	djbw/async_tx.git		next
cpufreq		davej/cpufreq.git		next
input-mt	rydberg/input-mt.git		next
lsm		chrisw/lsm-2.6.git		for-next
pcmcia		brodo/pcmcia-2.6.git		master
hdlc		chris/linux-2.6.git		hdlc-next
bdev		viro/bdev.git			master
nommu		dhowells/linux-2.6-nommu.git	master
sfi		lenb/linux-sfi-2.6.git		sfi-test
asm-generic	arnd/asm-generic		next
drivers-x86	mjg59/platform-drivers-x86	linux-next
hwpoison	ak/linux-mce-2.6.git		hwpoison
namespace	ebiederm/linux-2.6-nsfd.git	master
bkl-config	arnd/bkl.git			config

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Nov_2011_00_37_16_+1100_+vNQSFqYAUuuAhEq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOv8gMAAoJEECxmPOUX5FEuOMP/16v1L/mi5+fO1SHu7TMoGxO
VpLErbcvfE91zelv2e9QsSX7DlPJGV4CVapreE4aME+okaIF4cTRiEUU7NZN51JF
4jPN0L28E3+kyLq3TNoMrffqwBcnPld26+5mSqjuAkUNcBU1HFBtEl62yk/9U70L
SlNNytFulYLcwsNKW3CLyjv8wAU1p7dDKFvCRzLWZqCtr8KIaRIwSjgEwdZpovvO
mi5SQYp8TdEXHMmEIOOeaLvvgXMpCNgYH7fPOLxUZ5dB2Pdh16/yZXHFiZ4bxp6L
k0yWvHS6lWqmii0PJpY9CmIyw7fAhqIhDj8c1yv+M/c/zHuay1PZFxzvUyOVI0eU
PVZj2eQa07nt3oBjrirmt2mKFRm3z0rTBVqtBQvi3mh2CcD3KibvEVHlRos3/EzG
JnGqjSj6r+muih+kYF3oB/2Jbv9qP7l7QjCwkEaBaWagSwIqyGy8xHIU1tIgq98x
Wb43I+ZwQUC5XWwVP2aBYQ2TvRG5InmRtGTYDHXfiz+4XgzWmlBExD44JzVBIVmI
5qqMIDPFDdZNOjd9r9cxPPAE1YIporkxuhQpxXBe4s05hsBxWB0Qw7E1htx8oqL7
cqnC7++nxtmJTYOMB/jWN5naddCZEYsXLwRsmwExK9C9mQBUzPVVWX5alX+/Y20V
Krd/Z+518bwl88RBwHsu
=2fvr
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Nov_2011_00_37_16_+1100_+vNQSFqYAUuuAhEq--
