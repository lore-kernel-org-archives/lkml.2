Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0ERFKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 01:10:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37989 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755540Ab0ERFKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 01:10:44 -0400
Date: Tue, 18 May 2010 15:10:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the fsnotify tree with the vfs tree
Message-Id: <20100518151037.69226b52.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_May_2010_15_10_37_+1000_sFPI=kA=aOR6ZLRk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_May_2010_15_10_37_+1000_sFPI=kA=aOR6ZLRk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the fsnotify tree got a conflict in
fs/notify/inotify/inotify.c between commits
f3ffc7acb6a6ebec0a9e660d9211ed048d7e90f5 ("get rid of S_BIAS") and
73b38e074b51e5d8d2801691dff6e403631e927f ("Saner locking around
deactivate_super()") from the vfs tree and commit
b6bacae18f2f7722df9e8e516ed77b2815bd1ac7 ("inotify: remove inotify in
kernel interface") from the fsnotify tree.

The latter just removed the file, so I did that as well.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_May_2010_15_10_37_+1000_sFPI=kA=aOR6ZLRk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvyIU0ACgkQjjKRsyhoI8zhGwCfY7+cjmAz9FbXt/MIWvb+i7V+
m74AoJOnehT3Fb/C6pJBqw14cTzV2ie2
=Qasd
-----END PGP SIGNATURE-----

--Signature=_Tue__18_May_2010_15_10_37_+1000_sFPI=kA=aOR6ZLRk--
