Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1GRFj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 01:39:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38482 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab1GRFj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 01:39:57 -0400
Date: Mon, 18 Jul 2011 15:39:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: linux-next: manual merge of the security-testing tree with the vfs
 tree
Message-Id: <20110718153917.4aa9a18b80c0933cee4e638b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_15_39_17_+1000_Cz0i/5F9Z4m_4+1O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_15_39_17_+1000_Cz0i/5F9Z4m_4+1O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security-testing tree got a conflict in
security/tomoyo/realpath.c between commit 6ef0dd885ce8 ("get rid of
pointless checks for dentry->sb =3D=3D NULL") from the vfs tree and commit
5625f2e32663 ("TOMOYO: Change pathname for non-rename()able filesystems")
from the security-testing tree.

The latter includes the change from the former, so I just used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_15_39_17_+1000_Cz0i/5F9Z4m_4+1O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI8cFAAoJEDMEi1NhKgbsHpYH/A9OxML+oKzFwSm34u5/QuFe
n6wfa3nXRK1LA4jW55ReaK6mv69tfuhq413Lwtk9FYuAg0P6xPJ4TYgQ7FAxYgOU
57mv1S55DHW7XuSRvokU6WE3s4oqrn+IFYUlLABpS/a/2N0B0OuH68G8pAjxXX/Y
uSCQOGXblVgZD+mjvqC7lWKFHdc3d00h83NijM2ZTv4O9BvR2YNbySe8VtsXMXeW
gpHVYmu4bEeuyTDE3Z5rkz+ug0nobbwR1ip9wo1PKzoY2CFuQW2S8iGetWYwSPdU
ykBA/wu6RrKhsTu9lbDWDmfllY76niJm2JOIgpH1TTf0PAJkG2/mgt90pE6aOmU=
=vewd
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_15_39_17_+1000_Cz0i/5F9Z4m_4+1O--
