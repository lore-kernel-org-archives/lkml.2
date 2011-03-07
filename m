Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1CGCUK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:20:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49224 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CGCUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:20:08 -0500
Date: Mon, 7 Mar 2011 13:19:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20110307131958.84a5d818.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Mar_2011_13_19_58_+1100_ndk+pu9uKp1Ld_J8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Mar_2011_13_19_58_+1100_ndk+pu9uKp1Ld_J8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
block/blk-flush.c between commit 255bb490c8c27eed484d538efe6ef6a7473bd3f6
("block: blk-flush shouldn't call directly into q->request_fn()
__blk_run_queue()") from the  tree and commit
ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae ("block: reimplement FLUSH/FUA
to support merge") from the block tree.

The latter rewrote a large part of the file, so I just used that.  If
this is not correct, please fix it up in the block tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Mar_2011_13_19_58_+1100_ndk+pu9uKp1Ld_J8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNdEDOAAoJEDMEi1NhKgbsM0oH/2W1MH9RcYzgOhzbvyS5DaG0
PYCfz0i6OkSnD9l5u/fWFEvokdILZXVEGaXxNAONrqJHPAnKCqqJiH69mXs4gqRm
/mEsAgGmVWk08ZOIZen5xrm8VqdEOS9oe5V3/yAvk/oNGglC4k+qog2epPzNTBZd
rbvffz6CoasntrM+9i+fxPDBWB8XfgSUT7tQ+pjU7xcbz1pNWxfiGgCWFZ++yv1Q
qqC5PIJ8wS5V3mARihqoIF6/+RtNMdY3VYdoLXQeLc0Doqtmq+5oSuQi+JwXVuzx
hdGAoeSS80J3kfHsbQhe+v0GoAneJTtibqo+vS/blAfTjW90fLRBtDb7s/bFphA=
=VPWc
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Mar_2011_13_19_58_+1100_ndk+pu9uKp1Ld_J8--
