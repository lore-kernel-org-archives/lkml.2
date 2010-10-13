Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab0JMCNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 22:13:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55257 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab0JMCNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 22:13:14 -0400
Date: Wed, 13 Oct 2010 13:13:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the drm tree with the kgdb tree
Message-Id: <20101013131303.c044aa88.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Oct_2010_13_13_03_+1100_QfHr4E4JwGsNJ4qk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Oct_2010_13_13_03_+1100_QfHr4E4JwGsNJ4qk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got conflicts in
drivers/gpu/drm/drm_fb_helper.c, drivers/gpu/drm/i915/intel_display.c,
drivers/gpu/drm/nouveau/nv04_crtc.c, drivers/gpu/drm/nouveau/nv50_crtc.c,
drivers/gpu/drm/radeon/atombios_crtc.c,
drivers/gpu/drm/radeon/radeon_legacy_crtc.c,
drivers/gpu/drm/radeon/radeon_mode.h and include/drm/drm_crtc_helper.h
between commit 92b182171492dc1ac626e6f24ff3a7c917217aa0 ("drm,kdb,kms:
Add an enter argument to mode_set_base_atomic() API") from the kgdb tree
and commit 413d45d3627be4748058dea697718ed6fb88bd01 ("drm, kdb, kms: Add
an enter argument to mode_set_base_atomic() API") from the drm tree.

Supposedly the same patch, but not :-(.  I fixed it up by using the
version from the drm tree (since that has slightly later author date).
Hope I got it right :-)

Please sort this out.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Oct_2010_13_13_03_+1100_QfHr4E4JwGsNJ4qk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMtRWvAAoJEDMEi1NhKgbs0D8H/ix1uLfFX1Fr+XJRUEEJPmTC
VULTLiL6wSej58j1puKVJekYAbO7tu4T8Eqg3lkJhL58ZCAJ5A9byvA9742lWjsA
6oMGUYaZqmqsmk8I2QpLAb7/1PlocdAyHAKcJpSsGxfa4DnfrMi5WtNybttY0whq
4X015ZTh3ZmViv/gffOk0Ra/atJ3gHSygGFd+JMncjKgAarU0k1hm0XmX15vwbE3
TjYRuq/idPFQ13VySX+8cmuY2fTgJiHJ5lo2+AwzR6vBAElQhv3EBqHyIe0bCQRJ
jcsBTnL5PIVlBClJ7ZY95Ui4Y9qjvX1gV1vW+XtRTxnbFFQbvEKBK9IE6Hrw0wI=
=Vtcl
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Oct_2010_13_13_03_+1100_QfHr4E4JwGsNJ4qk--
