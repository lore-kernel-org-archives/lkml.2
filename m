Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1CQAeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 20:34:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab1CQAeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 20:34:02 -0400
Date: Thu, 17 Mar 2011 11:33:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Igor M. Liplianin" <liplianin@me.by>
Subject: linux-next: build warnings after merge of the v4l-dvb tree
Message-Id: <20110317113351.9cd177e0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__17_Mar_2011_11_33_51_+1100_byjG=F8QQUC_XSu4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Mar_2011_11_33_51_+1100_byjG=F8QQUC_XSu4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/media/video/cx23885/altera-ci.c: In function 'altera_hw_filt_init':
drivers/media/video/cx23885/altera-ci.c:671: warning: cast from pointer to =
integer of different size
drivers/media/video/cx23885/altera-ci.c: In function 'altera_ci_init':
drivers/media/video/cx23885/altera-ci.c:739: warning: cast from pointer to =
integer of different size

Introduced by commit 1b47d80abafb ("[media] Altera FPGA based CI driver
module").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__17_Mar_2011_11_33_51_+1100_byjG=F8QQUC_XSu4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNgVbvAAoJEDMEi1NhKgbskiUH/it56jlSCJpkeNTZTyKwjzFH
zoZ3dV7jw72fIp+TwmMh/TXcd6eGe1rQrI2w9oL7ijmMQBSMzFWl9Nodot+06z7a
xMYVRLE6uxI3mevQ4r/PerdopmzYdOMgZWw0yzJDv3g8jUypYjL6IaKWMmDWomEj
241ayCCPUIkVvMZmzxYNnJG1KoURE7kalmFWvk23iiRWHh1a6NZ7tpkqHLyvIjCw
RFUW27CGmWziwDnCHQQ5vxJcO15WhLBC3J8M8FJo8mo3wG8DmwpBc/xF++goM/Fg
v+gHq6fzD05Yo9mDeecfcw53CJ1EowZ85jHqMqG1Z+4ivEhWBqACYuXlD0LGX+Y=
=xmf2
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Mar_2011_11_33_51_+1100_byjG=F8QQUC_XSu4--
