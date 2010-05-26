Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab0EZBoN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 21:44:13 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47710 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933290Ab0EZBoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 21:44:11 -0400
Date: Wed, 26 May 2010 11:44:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the fuse tree
Message-Id: <20100526114406.d3a68d1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_May_2010_11_44_06_+1000_.B6LGE6o1NC4+zdp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_May_2010_11_44_06_+1000_.B6LGE6o1NC4+zdp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Miklos,

After merging the fuse tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: "generic_pipe_buf_map" [fs/fuse/fuse.ko] undefined!
ERROR: "generic_pipe_buf_confirm" [fs/fuse/fuse.ko] undefined!
ERROR: "generic_pipe_buf_get" [fs/fuse/fuse.ko] undefined!
ERROR: "generic_pipe_buf_unmap" [fs/fuse/fuse.ko] undefined!
ERROR: "generic_pipe_buf_release" [fs/fuse/fuse.ko] undefined!

Caused by commit c3021629a0d820247ee12b6c5192a1d5380e21c6 ("fuse: support
splice() reading from fuse device").

I have used the version of the fuse tree from next-20100525 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_May_2010_11_44_06_+1000_.B6LGE6o1NC4+zdp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkv8fOYACgkQjjKRsyhoI8xjdACeIslj5BnT2ox2XDesV4zY4DjV
mD4An2uEcV8k+N0mzqGp8LqwkjZh4UmS
=pcCH
-----END PGP SIGNATURE-----

--Signature=_Wed__26_May_2010_11_44_06_+1000_.B6LGE6o1NC4+zdp--
