Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047Ab1FABGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 21:06:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638Ab1FABGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 21:06:23 -0400
Date: Wed, 1 Jun 2011 11:06:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: clean up time (pass 1)
Message-Id: <20110601110616.861247de.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jun_2011_11_06_16_+1000_bSzZ/5+=_4iU.acN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jun_2011_11_06_16_+1000_bSzZ/5+=_4iU.acN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Looking through the trees currently included in linux-next, I get the
feeling that some of them may be obsolete.

Here is a list of tree that had no commits in them at the openning of the
previous two merge windows:

linux-spec
pxa
galak
ceph
configfs
jfs
squashfs
vfs-scale
kconfig
ide
powertools
swiotlb
input-mt
lsm
embedded
firmware
backlight
uclinux
hdlc
lblnet
bdev
cputime
jc_docs
nommu
audit
irda
i7300_edac
gpio
xen
sfi
asm-generic
hwpoison
sysctl
slabh
scsi-post-merge

I have no problem with including trees that are only used now and then,
but if any of the above have fullfilled their need, please let me know
and I will remove them.  (In some cases being in the above list may just
mean that the proicess is not working very well and things are not being
included in linux-next before the merge window opens.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jun_2011_11_06_16_+1000_bSzZ/5+=_4iU.acN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5ZCIAAoJEDMEi1NhKgbssvgIAJMgsqwAomRdPd0oz6cXyNRI
Iz08ewhG7+q6+XDaxHIadWv/tiMtEv3uRHSCUWMOZo9Ot3bY15IbQFzIUM1B+sIs
Olgqk9IJqNKwvoAvLu7NJ09RtjC+GoN2E9hKQTpYERL6WUJkwA6wxQrKHXwD3gpt
nsNq1GboZiG5+cfm3uCmD9k27fOxNLAAEJeUW2TEOTZAhuDixYGpxj9ZDvBfvfQ7
o+OfJNcjJG22/mW9nV9vJVbLdxdVnz/3ddU3u5jQtfYyZQVYobe34aCe59Ns4cnT
79+hpekCtfD2NPzDxpEnXTODuVFESiMjCp7tpawtaKYJfa6CrQadJ8YS8nSxzlA=
=x9B2
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jun_2011_11_06_16_+1000_bSzZ/5+=_4iU.acN--
