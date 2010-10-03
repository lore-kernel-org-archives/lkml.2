Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163Ab0JCXbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 19:31:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58976 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab0JCXbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 19:31:01 -0400
Date: Mon, 4 Oct 2010 10:30:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20101004103054.faaf2ef9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Oct_2010_10_30_54_+1100_yD/TlIDcyTV=hHQp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Oct_2010_10_30_54_+1100_yD/TlIDcyTV=hHQp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_gem.c between commit
39b4d07aa3583ceefe73622841303a0a3e942ca1 ("drm: Hold the mutex when
dropping the last GEM reference (v2)") from Linus' tree and commit
fd2e7931cdefa8e9acf63f0a4efd61ae0f89e77b ("drm: kill
gem_free_object_unlocked driver callback") from the drm tree.

It looks like the former supercedes the latter, so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Oct_2010_10_30_54_+1100_yD/TlIDcyTV=hHQp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMqRIuAAoJEDMEi1NhKgbs78sIAKCMfOwX/5UMqPzVC1dSL/Jz
uHm5EC2vNwkkG0o05T92uiNIplMQS/rleXLQ3Uw0w5jKW8LSDijKZxq2zqNIrwkb
MOmHGfOqaGDDHogmJN/Dsab0HEnEWq4/pSq16JH/5+hQWMt3+4VfzRBYB7SJ8wyw
rqkyaUhBe1e4viRTYsjHiU+MIm7nATIOSPHQmLkQeGz1j8+jSC+Ygknxkgjsdyzh
pbev5s0TXVfQPMt+iY9g8VYxD/Rwpk9qbKYffK05QrAltVe1jWK4aYTMF4VKblT4
HIfOUQlRuED9n4imkyI7xlFtTmU8nf2abTuYkYIi42K0I3eKKKQ+8JQtMHTeLrI=
=nr74
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Oct_2010_10_30_54_+1100_yD/TlIDcyTV=hHQp--
