Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2DBB7Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:59:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51148 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805Ab2DBB7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:59:17 -0400
Date: Mon, 2 Apr 2012 11:59:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Li Zefan <lizefan@huawei.com>, linux-kernel@vger.kernel.org,
        ctalbott@google.com, rni@google.com
Subject: Re: [GIT PULL] block/for-3.5/core: pull in cgroup/for-3.5
Message-Id: <20120402115905.cbca9c04113e543163bdb5f2@canb.auug.org.au>
In-Reply-To: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120401200306.GB9230@dhcp-172-17-108-109.mtv.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Apr_2012_11_59_05_+1000_LYv6o/9ZlFtAcREf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Apr_2012_11_59_05_+1000_LYv6o/9ZlFtAcREf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Sun, 1 Apr 2012 13:03:06 -0700 Tejun Heo <tj@kernel.org> wrote:
>
> cgroup/for-3.5 currently contains the following changes which
> blk-cgroup needs to proceed with the on-going cleanup.
>=20
> * Dynamic addition and removal of cftypes to make config/stat file
>   handling modular for policies.
>=20
> * cgroup removal update to not wait for css references to drain to fix
>   blkcg removal hang caused by cfq caching cfqgs.
>=20
> Due to the extensive changes in blk-cgroup.c, the pull results in some
> non-trivial conflicts which can be a bit tricky to resolve correctly.
>=20
> The following branch contains the merged commit.  Please feel free to
> pull in as-is or use it as reference.  Stephen, cgroup and block next
> branches will cause nasty conflicts until this merge happens, please
> use this commit as merge reference or skip cgroup/for-3.5 for the time
> being.

OK, I have moved the cgroup tree to before the block tree (just so we see
failures in that tree independently of failures in the block tree).
Currently the block tree contains nothing, so we have no conflicts
today.  The best way to proceed is for the parts of the cgroup tree that
the block tree will depend on (which may be the entire current cgroup
tree) should be in a separate, stable (i.e. non rebasing/rewriting)
branch that can be merged into both the cgroup and block trees.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Apr_2012_11_59_05_+1000_LYv6o/9ZlFtAcREf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPeQfpAAoJEECxmPOUX5FEa4YP/3s5lrTj/LlU2qnz6iUp0pwV
GkSzO7Uyl8NeKIO8lgLSXTJCL2cEYhHcn0LZb0c6+SYEaSPRsIxB+7wGCqKdAXeA
oM1z7/sjCgfEbkAOxM9KwnPJh+t1Q8P/+M9V/WXnpp56lDMake7ZTRpiWcp4Gs08
TRA6SyY4Sygf4F0DX6j3OsQvXLTpaji2n8RS96oH1SdHRwaMVR4EUXd61dDSkO/b
+8IH93mnBNa2JJ8RVdDrYWYWAAMIUIwhqOwoLkb3CNtXfrZw7mv2ZAFeW093a8O8
BIYKN40Yj27i5+85frbcqYgImp7MOT6n0gyO3CV+gT9q8Xtk3Rrs0mhJRF7n6aQp
/9v3VXbMpEcBF8WQ4Ns48iWuauSRsiYdlKQARMDK7SEZJomlIQzmGjmdbo8mtt4n
qQMudJp8148xxMQaXpxQRLyVcA8qnsNkDunmbGu0vXZozJuAZ9MQpbVQmCQjKO0a
anweOZia/Dom8lZvtFHAXAWx2mU8uPm02oGw6ZFkPcmGGAGlfGexyQTxA98UQCm2
MUrKWEfT7O3cKwcSkxTXiS9uGkkAuI8UZEp8V1rs2nVkrQmuPTT5FqDOFg3phDP7
HFLLsfrEXt5zUU3uJ6F6jvzIg6W97qTbwxIHr7kPejrcJqXZ3CQD/8s6iNGjhkxa
csP5GQR74hac23ftfitS
=DyJl
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Apr_2012_11_59_05_+1000_LYv6o/9ZlFtAcREf--
