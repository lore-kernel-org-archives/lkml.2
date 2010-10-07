Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0JGCk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:40:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40659 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0JGCkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:40:25 -0400
Date: Thu, 7 Oct 2010 13:40:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jean Delvare <khali@linux-fr.org>
Subject: linux-next: manual merge of the drm tree with the i2c tree
Message-Id: <20101007134015.2f8f4a97.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Oct_2010_13_40_15_+1100_Gud3yioUvm0kK8Xn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Oct_2010_13_40_15_+1100_Gud3yioUvm0kK8Xn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/intel_drv.h between commit
2d3e8209c9d3abf6e831158e9814f50c57275487 ("i2c: Remove unneeded
inclusions of <linux/i2c-id.h>") from the i2c tree and commit
f899fc64cda8569d0529452aafc0da31c042df2e ("drm/i915: use GMBUS to manage
i2c links") from the drm tree.

I fixed it up (both commits removed linux/i2c-id.h, so I used the drm
tree version).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Oct_2010_13_40_15_+1100_Gud3yioUvm0kK8Xn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMrTMPAAoJEDMEi1NhKgbsEOsH/1qhX7+6p6qEvDEEuBoHP9xa
AmjsrXSGOVSUEwS7555QX1bLHv60L5H6iyDiazkjfEETEXvyQMUYQOkLYbnogB6c
mjAbnL8So+kd1qjA6lFIsbsizxosuWyJ++9a2eRnvzLvcNLZh5oxy1h27hzLAgoW
QY7t4xidEgstfV+5P6Bk9lUTypAifQYJt+btdm24Y8ZkAncW8sWId+BdgsPdaY0a
DhNmSxx4Img2bRHVNvijKIRBRE+MQWQCOTg6DcvTuCCCPZr6NH01D9MfsOC0K2YJ
FzoLCUzjmAgXc3PVyQRR/QSKI39GaDaZPxTgzAQ1YmQ6pu/Frs9+nVahgtIyw9k=
=tQKj
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Oct_2010_13_40_15_+1100_Gud3yioUvm0kK8Xn--
