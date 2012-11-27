Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab2K0X2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 18:28:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60529 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2K0X2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 18:28:15 -0500
Date: Wed, 28 Nov 2012 10:28:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: unusual update of the security tree
Message-Id: <20121128102800.97a1a4d895f0bfaf72b80272@canb.auug.org.au>
In-Reply-To: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_10_28_00_+1100_F_BFlzfGO68Eq_B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_10_28_00_+1100_F_BFlzfGO68Eq_B8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Wed, 28 Nov 2012 10:16:35 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> The security tree
> (git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git=
#next)
> looks a bit strange today ... It appears to have been created by Casey
> Schaufler (cc'd) and contains some quite old commits and back merges of
> your tree.  I *guess* you have merged in Casey's tree after he merged in
> your tree from yesterday.

If that is what happened, it may be worth always using the --no-ff flag
to git merge/pull to make sure that the top commit on your tree always
has you as the committer (and maybe SOB).

Linus, does that make sense in general for maintainers?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_10_28_00_+1100_F_BFlzfGO68Eq_B8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtUyAAAoJEECxmPOUX5FE7qQP+gORigVM9Hkv9RgdAQ1oKRi5
Pvj3yGt7LU+qLvBuEpC73zhLVyhK6hmAPtzSe0bpV55q9RUwaQmTyUqMQrMhrEiw
iUNqvawfdkv9yuLCSXvF2pzrudDUOIKXDgbdCO1qPLyzUIes0S4rK8wkHx5d3cxi
+jKH2p51x56WLpty9Huhv1z7xDdYFSz4z9ZH5aZzNL9JQeBPO6LXZXdFoWfCMIl3
//efmhXfTn7Isj8ebVzLbNYvgNjDz8RmcfME0GhcoSGhgVCNFj7zRKFYIlLSiCC7
PQLCg0Qg/c0ReUYfnahNnT4LzMeMgMB8UFsQobe6TAoCDW1H6NSaRwRv8MIIkoON
8rAkAvh6/T8KUVR+dATN72A11UvtwS8ogbdCKpadbWrDrvaMkwsggvqYc8JHZsa9
F7lJSPok+XYCM0u1+2/XJHgyj2D813ArUq/dIr1YjbZjfR9nJof3QfQvQgSt3RIv
y+ebK5L8LxONzyaFSUuyF+hdt9Df4o54pESiNehdGeCQ70FcrGqtruL/7g2ep0V9
5Bu9zdfHiLzjJ0LATYMXRq94mI1KdAuQyqLnRt1+V7RhwFz/+9nVUbUHz96m08JC
b1+L5Rg9ryWdbo0S6WeioaXryLrwz968PvkeQO25bnb4CViKUyNmu7uHHDyYw9BT
gpXMdSTa6D4TlFK/QKH8
=EGBE
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_10_28_00_+1100_F_BFlzfGO68Eq_B8--
