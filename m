Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab1KYDVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 22:21:21 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43290 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1KYDVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 22:21:20 -0500
Date: Fri, 25 Nov 2011 14:21:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the cgroup tree with the pm tree
Message-Id: <20111125142111.ddfd48752425ddf79f194770@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Nov_2011_14_21_11_+1100_tOchpYrLVwXUezLa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Nov_2011_14_21_11_+1100_tOchpYrLVwXUezLa
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
kernel/cgroup_freezer.c between commit 22b4e111fa01 ("cgroup_freezer:
prepare for removal of TIF_FREEZE") from the pm tree and commit
cfb5ec210751 ("cgroup: don't use subsys->can_attach_task() or
->attach_task()") from the cgroup tree.

The latter removes the code modified by the latter, so I just removed it
(freezer_can_attach_task).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Nov_2011_14_21_11_+1100_tOchpYrLVwXUezLa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzwmnAAoJEECxmPOUX5FEuUkP/3AJMVuXZ3Q5TMplvPkDnVkW
WClekeoE9fy040Z9pfE/vNFtKpRKtaZyudpJuz3rSJd6dOSMWVHh056lWEO0A9ju
U2x8ahTz1IHWLsSmBrWfui8x4aVmodut+uHSGnS7F4hqwz/xgKgd57HLZQdrwtDx
f2BmIHvXYM0N4zCmdYVtjjAbdduBfErzzY/aFo2WpkEANT68cIDn9YYaD4F26fUY
7/HmmD2o/rDFvxLM3yVwGQG3dehz7TLe12KiuIPbVLzsf45v7VS4rjkTknMqy68V
brWi+4Dr9Juyp1pIDDlhcnNtyKD1tfFd3mgLnrWrodRMrK+mZv4O3GQnibbN+eMM
uj9myfC1n+2DQenwJbKW4K32UImbeu0TAbvp7vPUkXbC/RFpQ4U0TpxD3XpTK/p/
o5XBfg5gVCQnK2xd66WLvpS2lcpmtGk/NcsZShS+/igh8Hmz7r1P0Bbs0Iz2cDrj
KLY/L2PXYNBY64sHSNrhptBrtmklnTViGQ8eHyQzsDAixOIL4IILDTQGpGJ8tCQW
dU3GennAqIDD6Hs3XGAA3IOeFQohAUgoiWQNd4WpfB3Khd4ECrV3e+7VRsc4KegB
3glZ9qPHK08mtpCEgAU+3uAcl+v2Xo7I0hr5BUqRCpocD8qdCQniPVl8SntCUSU6
bm5MmloJMWO+IGqqUJJl
=cj90
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Nov_2011_14_21_11_+1100_tOchpYrLVwXUezLa--
