Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab2ATAkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:40:53 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43077 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab2ATAkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:40:49 -0500
Date: Fri, 20 Jan 2012 11:40:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        <sfi-devel@simplefirmware.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Chris Wright <chrisw@sous-sol.org>,
        Chris Zankel <chris@zankel.net>, Christoph Hellwig <hch@lst.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Walker <dwalker@fifo99.com>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Krzysztof Halasa <khc@pm.waw.pl>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Nick Piggin <npiggin@kernel.dk>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Paul Mundt <lethal@linux-sh.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Samuel Ortiz <samuel@sortiz.org>, Thomas Renninger <trenn@suse.de>,
        <cpufreq@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
        <linux-omap@vger.kernel.org>
Subject: linux-next: dropping trees
Message-Id: <20120120114016.995d4f1af74eee173bef79d9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jan_2012_11_40_16_+1100_VwcUFg2VSWQERdZN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jan_2012_11_40_16_+1100_VwcUFg2VSWQERdZN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

The trees listed below were all hosted on git.kernel.org until the
breakin.  These have not been restored and I have not been given an
alternate location for them, so I will drop them all on Monday unless I
hear from their maintainers (all cc'd).  On the other hand, if your tree
is no longer needed, it would be good to know that as well.

Tree		URL
----		---
asm-generic	git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic#=
next
async_tx	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git#ne=
xt
audit-current	git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-curr=
ent.git#for-linus
audit		git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git=
#for-next
	(Al, should the above 2 be just "audit" (not "audit-current") in
	the URL?  But there is no for-next branch even in that repo)
bdev		git://git.kernel.org/pub/scm/linux/kernel/git/viro/bdev.git#master
bkl-config	git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git#config
cpupowerutils	git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupoweru=
tils.git#master
drivers-x86	git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-dr=
ivers-x86#linux-next
fatfs		git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git=
#master
hdlc		git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git#hdl=
c-next
hfsplus		git://git.kernel.org/pub/scm/linux/kernel/git/hch/hfsplus.git#for-=
next
input-mt	git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git=
#next
irda		git://git.kernel.org/pub/scm/linux/kernel/git/sameo/irda-2.6.git#for-=
next
jfs		git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git#next
linux-spec	http://git.kernel.org/pub/scm/linux/kernel/git/dwalker/linux-spe=
c#for-next
lsm		git://git.kernel.org/pub/scm/linux/kernel/git/chrisw/lsm-2.6.git#for-n=
ext
namespace	git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-=
nsfd.git#master
nilfs2		git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git#fo=
r-next
nommu		git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-2.6-nom=
mu.git#master
omap		git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.g=
it#for-next
pcmcia		git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6.git#=
master
pxa		git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git=
#for-next
rmobile-current	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6=
.git#rmobile-fixes-for-linus
rmobile		git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git#rm=
obile-latest
sfi		git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git#s=
fi-test
sh-current	git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git#=
sh-fixes-for-linus
sh		git://git.kernel.org/pub/scm/linux/kernel/git/lethal/sh-2.6.git#sh-late=
st
vfs-scale	git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npigg=
in.git#vfs-scale-working
xtensa		git://git.kernel.org/pub/scm/linux/kernel/git/czankel/xtensa-next.g=
it#master

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__20_Jan_2012_11_40_16_+1100_VwcUFg2VSWQERdZN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPGLfwAAoJEECxmPOUX5FEgfQP/j9mDEt4JUtQAkkyGDkvUC2q
W5zhOymDiNj9uFd/yG4VXVcoRN5T9dvq3HP97MfBWhMJhh19OsHVbe3B31trtKEW
zG8u97UKtpqjeKos5wpSvKQ5Gq5WodnenqlhKVzYGmhKqsagf8JmXJmYvUaz13FJ
CMIsDAaF9MaXN0YS72/Xl8S8Jlfs7v3FQ8G1G56qjekFySijuN322BHHLC8aNE11
kHptRpBswSot0IGTyRLXWSAhy04kZ0JV9QNG6utQ8SytVSt9oN5ajrh7l9+mrH5+
c4LRc/w/ekWeRsQcdONmMPR/L0ivepKWECtZpBgjTJv5jmdbogAZ4dC8gxdOdWrK
xzZra4c4FFF7xrRhG1AEgXncCgVWM66OWuon0eHMrcR2MYvp1Y4voEWQeUuPmgXY
vx1p0eIS7v7crAUhMuyPNq+AGMjJQlSZxG2NyeLUo5SmBP+DQU0eYIdQlqMJayM8
iZgF3i969VGpwS9sxyZIkA4NB/mDCX7E7pxUojNJhE1wOMQ2N8dd7cEeAyiWgrHb
41gFVZF3QGs+KAerYarN4+EaF8VT7cE7I0DM1gPp40OIwyDO86jw9jA1A9gTCo0I
UT1jWF6Y4bXIx1yF6TqRSmCCXoulYogRQ++e1OCUScMnPs2A7W6u1RsZsdPDePbS
o+nSM86L0K+kdAm9li06
=05D0
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jan_2012_11_40_16_+1100_VwcUFg2VSWQERdZN--
