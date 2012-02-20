Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2BTECd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 23:02:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:41149 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445Ab2BTECc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 23:02:32 -0500
Date: Mon, 20 Feb 2012 15:02:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: linux-next: manual merge of the remoteproc tree with the scsi tree
Message-Id: <20120220150215.68e88ae1bf96e5790ecd19fd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Feb_2012_15_02_15_+1100_M5V7eJ59ClSwVIct"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Feb_2012_15_02_15_+1100_M5V7eJ59ClSwVIct
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

Today's linux-next merge of the remoteproc tree got a conflict in
include/linux/virtio_ids.h between commit 4fe74b1cb051 ("[SCSI]
virtio-scsi: SCSI driver for QEMU based virtual machines") from the scsi
tree and commit bcabbccabffe ("rpmsg: add virtio-based remote processor
messaging bus") from the remoteproc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/virtio_ids.h
index c5d8455,b37c521..0000000
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@@ -34,7 -34,7 +34,8 @@@
  #define VIRTIO_ID_CONSOLE	3 /* virtio console */
  #define VIRTIO_ID_RNG		4 /* virtio ring */
  #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
+ #define VIRTIO_ID_RPMSG		7 /* virtio remote processor messaging */
 +#define VIRTIO_ID_SCSI		8 /* virtio scsi */
  #define VIRTIO_ID_9P		9 /* 9p virtio console */
 =20
  #endif /* _LINUX_VIRTIO_IDS_H */

--Signature=_Mon__20_Feb_2012_15_02_15_+1100_M5V7eJ59ClSwVIct
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQcXHAAoJEECxmPOUX5FEgrUP/3UB2jBABH30nX7MLx+CsbSd
76Odk14DkcaVvUe4eRSSLpnYuypSs9PK882H6aganaSiglBkJA1YMPuSy70Pj1uG
DhcjCWEVWtPPKAyJt+fsOXroFn33ihB0oa8bboiV9G0dBjNuP31EqIgYMZj/9yx7
OwoptEAZamz88cWOrbRUDKsbCOZVoyQOdZJACdobQ39DgXJ24Vl9jwkF99hb93kP
ROUklHW3nYjr3CCyKzuhBAeSyFxy1gTJZQlq6eTz05G2vnT0U+DjcFCwCy6pGd6t
XR+EPxgoJcK++E1tO15TQrBfzb5dP+l9I/gAUjcFcmSY9moAKxSdvg1h4XQroQ6K
lFd++ZnWff03tAvPVltCBriv6s+80GbRLnNhqcZsMKnbA7rHDL81iKQP94bggyeC
WSqUfWImUwwMutt4tC+DzVC+C7jxNS4kL7PUCRpMOrv+f90Mcalw7ig2yKAcuXtz
fl7G3jbpXMDCxeUMLDL8oG/ctaayameTMIQ7b/a0L9HJt2C4oH0Y80Mg3w2u/ux6
rGG2W12jgwfGDeJdYbN1/KW2JjkaSJwtWGxhEYzu3Wvie8nZbvX5c8fil3feychk
s/gTs9URgX+goy9YX6tBxPOv8JqfjU4RM23QMbl/bUDbqcsSoIJlXWU/yh/4SLRE
ULDIs9dznWMf/InK08op
=t+fT
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Feb_2012_15_02_15_+1100_M5V7eJ59ClSwVIct--
