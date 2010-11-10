Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0KJBxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 20:53:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60675 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KJBxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 20:53:32 -0500
Date: Wed, 10 Nov 2010 12:53:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the fsnotify tree
Message-Id: <20101110125321.79c5c8a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Nov_2010_12_53_21_+1100_15_WvkKBcFSRqpda"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Nov_2010_12_53_21_+1100_15_WvkKBcFSRqpda
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the fsnotify tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/notify/mark.c: In function 'fsnotify_add_mark':
fs/notify/mark.c:230: error: 'struct fsnotify_group' has no member named 'f=
anotify_data'

Caused by commit 0ed64ab6b338e4269c9f25de83781619ecd624f1 ("fsnotify:
code and error path cleanup in fsnotify_add_mark").  This build has
CONFIG_FANOTIFY not set.

I have used the fsnotify tree from next-20101109 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Nov_2010_12_53_21_+1100_15_WvkKBcFSRqpda
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2fsRAAoJEDMEi1NhKgbsOsEH/2uC44+zUVtli9D0Ucxj5e8x
BLwSkYPSExW57uZDdbLwJGTQfPzFFuAiEJ1/GgefTqKb/KlMB8SWld9is0IiOq6Y
AIo6iy27uVy1WFNQuWoLnFWrnUeLv+3sQvyoXg4WvB4jb1Bk0spJP4Xop9bW3Uro
WhSE2TugnJWSouWf0hC63Cn4RvTj7ijtlFk0KZZRIjLsX34YlsmVrSPj2I+IEgUf
MVqsZMp4GVpF7Mo2fjkzXGuwmp1g3WucB7zOMAMvFU2MNZAjG9egm2Uhr9YW6fTk
bfO7lcxGESsRmnsd8fVr7cDOmXbTzfQmZckH438dY7OaU5fCVreU6Bw6UkRSEBg=
=B3rN
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Nov_2010_12_53_21_+1100_15_WvkKBcFSRqpda--
