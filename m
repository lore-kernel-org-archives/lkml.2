Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559Ab2KADlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 23:41:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48463 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab2KADlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 23:41:18 -0400
Date: Thu, 1 Nov 2012 14:41:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20121101144117.19aa700248df82b512d8d00f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_Nov_2012_14_41_17_+1100_O9/mkIfTZVueUq39"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Nov_2012_14_41_17_+1100_O9/mkIfTZVueUq39
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

Today's linux-next merge of the tmem tree got a conflict in
arch/x86/xen/smp.c between commits 1ba23a0f2605 ("xen/smp: Move the
common CPU init code a bit to prep for PVH patch") and 6c6067f26388
("xen/pvh: Extend vcpu_guest_context, p2m, event, and XenBus") from the
xen-two tree and commit 7282a68f5aea ("PVH: Basic and preparatory
changes") from the tmem tree.

I fixed it up (using the xen-two tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__1_Nov_2012_14_41_17_+1100_O9/mkIfTZVueUq39
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQke9dAAoJEECxmPOUX5FEBqQP/RaXrrOUi45W2viBrfrBCzTF
Q3gF3t69YqeL72CH3lc0xp9Y15o4LtLtcC21rABH4X1DUzFjkerhhOaJhprT97eB
f22My2KXRqmhpdATS1ob+JaHv5SZEEEjLC180YVHXwb7CxsGZPxP3YFR6EWwcMD1
qLGzMx+ssvbQAXA8qQNgiyqGxmiRgIqaSbwWbeOrO8JO+Zt2eKkin/0d8pvNYemx
P6JUBgli234D9z3dyF4nJpIlmW7K6GsZxK2Ocxgc5LUSa/AJbYFGC/8dt8vNkZW+
q2f5n/08bKNfbi4SasszmkW7rcMKXItNir/mDhpfmSq/KkFkxYcaOyYS7K5mBNCW
1lFvu81zj1xKL7O96uEkXt2zNfCCrT4WuVOCVDrSlKYTWv6vg8D9jZ+ulxWmAHrS
GcMuBR1FVpoZfbue9cN7GiL6pkadrfpGgqv5REPb1hRQke5kp3rN122YDokQuKd4
yTpRQlaQ2Jr1MdZqQ3UtWkFX/gNh92hbma1WI4stM/3njmaJzEhzzUpueHqGMn9+
chFTDKghmKxLenFqm86r0HfcWLAvwZS892YUHhnSRmTucVBBSjJ+lz7/OvQJt1wa
9f18VhgJg97THAfaQgrnlw0z1+k4GgPEHw3ccyGsowcM5im9Z4Bof2YetMcCFd/G
hagVvn41J11ZzupJTK+G
=Qp/U
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Nov_2012_14_41_17_+1100_O9/mkIfTZVueUq39--
