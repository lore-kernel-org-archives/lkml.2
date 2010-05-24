Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0EXAkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:40:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52354 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab0EXAkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:40:19 -0400
Date: Mon, 24 May 2010 10:40:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sage Weil <sage@newdream.net>
Subject: linux-next: build failure in Linus'  tree
Message-Id: <20100524104012.67dd6acb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_May_2010_10_40_12_+1000_X3v_M8CxAjKR0Q2d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_May_2010_10_40_12_+1000_X3v_M8CxAjKR0Q2d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the  tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/ceph/msgpool.c: In function 'ceph_msgpool_put':
fs/ceph/msgpool.c:173: error: implicit declaration of function 'kref_set'

I cherry-picked the fix (commit f553069e5d7c6f53688ae4470173fcb1be97cbe7
"ceph: update for removal of kref_set") from the ceph tree.  I believe that=
 Sage has sent you a pull request that includes this fix.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_May_2010_10_40_12_+1000_X3v_M8CxAjKR0Q2d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv5yuwACgkQjjKRsyhoI8xzQQCgi6VktUP4n990ZnhMsIOQx5ek
1AQAoKOYCHGlpqUCJu7SLKoYHV+VbMGc
=HQ/g
-----END PGP SIGNATURE-----

--Signature=_Mon__24_May_2010_10_40_12_+1000_X3v_M8CxAjKR0Q2d--
