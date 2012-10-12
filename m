Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2JLD5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:57:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59115 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab2JLD5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:57:02 -0400
Date: Fri, 12 Oct 2012 14:56:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Mark Salter <msalter@redhat.com>
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121012145652.be64beeb8fd068091ad89f52@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_14_56_52_+1100_ytzQzcZb9AL+/ZNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_14_56_52_+1100_ytzQzcZb9AL+/ZNA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/c6x/kernel/process.c between commit 2a5e5beb88c5 ("vfs: define
struct filename and have getname() return it") from the vfs tree and
commit 680a14535c33 ("c6x: switch to generic sys_execve") from the signal
tree.

The latter removes the function modified by the former so I did that and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_14_56_52_+1100_ytzQzcZb9AL+/ZNA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd5UEAAoJEECxmPOUX5FEXJAP/2BQzM5VFJtabi9l8UJSt0YW
YmHfZSKiGLr7Yg0ywDyHjJ5emSO9VmaFowfDUl0De3cmVJrJQYMjJE1uOXtP8nWo
t7/fRZ+LQImeIMWPPhzaiWW7No5UksiGXvRSh4dhgCbNpvWNCDkEaYY//Dsy5xdI
v8S3X96l3PLvWkNN1nkUbJn/APdTctfr2zHLuhTQAjIgTU1f03iXxlayiTYsio9Y
oWA8lhZv63HQYhfBSaUzC6DpazvKC876AFPILQB+12LvKEEFEcfVPJS+R+/vYgNK
GPrgYMTLS0DvNB1AcFeAY1Y/Q7/x0kSvF1h9Zc8LMybOlq2Kp24h3I8jKhJ7k0kV
0GqHGKJGdxXTlniCUPpiesB0ni+QVAHzxMkox9VEFVLm8cuSYKXGV++EYlyNxm8b
niNbvZqb71JQaVoVhyes32yhRm7XkFD7PhuaY0qPgzZxsPSn5Y4AewIgD71yBhGS
dScDbNJnlExCdM+pnyhDznRrI0QflqD27MRlVFZZBJhjLV0b8EokOsTWpqbrdHS/
86WYW7/m2PrOBKuyCctrKsMt7+8t/dW5zKH6JwVhR2jnWFtn1uKVCeOydao79Q4G
fxlrzNbOFoZeK0alYI6Q2WN8qzFjydZN6md57ZDuHNB4Pa+Fdyp2ZWZqk/3hltlA
GILNmEmyXJvlzdhXIVBK
=cD7l
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_14_56_52_+1100_ytzQzcZb9AL+/ZNA--
