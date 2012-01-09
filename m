Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab2AIBLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 20:11:46 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:51041 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2AIBLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 20:11:44 -0500
Date: Mon, 9 Jan 2012 12:11:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the vfs tree with Linus' tree
Message-Id: <20120109121133.76f5b7c4a4780954c4562244@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jan_2012_12_11_33_+1100_WVVj/b32r=nPFVc5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jan_2012_12_11_33_+1100_WVVj/b32r=nPFVc5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in
fs/btrfs/super.c between commit 34c80b1d93e6 ("vfs: switch ->show_options
() to struct dentry *") from Linus' tree and commit 2ddeb2a58b11 ("vfs:
switch ->show_options() to struct dentry *") from the vfs tree.

I assume that you sent the correct version to Linus, so I used that.
Please, if you do change stuff just before sending it to Linus also update
your for-next branch.

Then again ... it looks like the vfs tree has other changes to the btrfs
code so that I need the version from the vfs tree, not Linus' tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Jan_2012_12_11_33_+1100_WVVj/b32r=nPFVc5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPCj7FAAoJEECxmPOUX5FEZ9UQAJyUDF+nlK+lo3aW4eSeZT2e
jCnvlqPbG3G89dW9aFq8XptZrguX6DjnreYkUaVA6UnhaCmVEYtgf82Dvja49qlJ
YlHtwB/04oYCQickkd3Tnq8EnKYHfuVc8dKWPy1k4TREHFYyq42SOQ34dY4s9YaP
/1BfsE9LKc8SqCB5Wz66U3Fnvhx6bFCzN06/llr+CyKP5B2TfsL7ZxRrd40qfCBn
PpvGyUA1LKZ08FiFe0Ey+Gp2ervZF+vVChe9CMFaHMa8wXN+p3wEJIJRw+WPeXx9
xkIEWkypm/7CkRBQeFBsLAfdSJkSY6sxR85mbzVJtZsu+/Ii6xGGDYl155KTU6tu
bY3GuHeCwW4C/d4fESXD4bFERFgqJ6v6SqoA012aiGQqvwOEQFmSlLbTfboRhSpj
e4GNvMlzCDckLHYp7lBDcvzKdOni0N0eEgKIPJ8+QcnGnc8Qo3+G6os1OdoYAEGX
7UqvnwFDaVlh/YWzvPBkII0wwroS2HzyFLw50qGYUXo+Fh6paTlfOWHSL4KzWQGl
CCSWi7EfP0x7DL8RjCVJ2nvatADbmgzrvGVh/lFkVxP1o1BQo+yn8ccwj8roA8l7
U/LU5xpzDSYv1su7DO8LAxqMfflkI9NhGsuYxTd27DoCWnDDNQnnBlrR8T1VhtWw
ESIBw5EH3dDTx4jbVkP9
=mf5q
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jan_2012_12_11_33_+1100_WVVj/b32r=nPFVc5--
