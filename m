Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2INDRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 23:17:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58406 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab2INDRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 23:17:14 -0400
Date: Fri, 14 Sep 2012 13:17:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Li Zefan <lizefan@huawei.com>, Neil Horman <nhorman@tuxdriver.com>
Subject: linux-next: build failure after merge of the cgroup tree
Message-Id: <20120914131700.dd3d01a7d17b78082a9bcd55@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Sep_2012_13_17_00_+1000_lrjVWCpy/jwbQFRT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Sep_2012_13_17_00_+1000_lrjVWCpy/jwbQFRT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

After merging the cgroup tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/net/tun.c: In function 'tun_alloc_skb':
drivers/net/tun.c:589:2: error: implicit declaration of function 'sock_upda=
te_classid' [-Werror=3Dimplicit-function-declaration]

Caused by commit 1f66c0a8833c ("cgroup: net_cls: Move sock_update_classid()
declaration to cls_cgroup.h").  Grep is your friend ...

I have used the cgroup tree from next-20120913 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__14_Sep_2012_13_17_00_+1000_lrjVWCpy/jwbQFRT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUqGsAAoJEECxmPOUX5FE5MkP/0n25LEdHNaBoBEab3Rf+1sB
JyfkOtfVj/M6/EVX7+6PJRnbGLq53+jEOh+YV5NBL/AgPMg0nKcTNcohYQJPwomM
CmKfy34AHHVcZJVACx3heeS4FIUIBqx/4ZmzyC2uY2Q6htV66tSO0EVQu/TX9jQz
Vo2VIkmf/8bCUhwqQ64pUzcE8nd1Og0FOVcSPt/aUNOin95PEc6Gg6scO80ugs7V
elDeWpPivywYUIyycQOO6MVaBBJq6+qhRaW6RKIxywOJPMrlaR4kFLv7JM41pFpF
hns80TFulMaxSMvZPTu2zfoYiUGg3WvRnNlq8gTYRGsm8A9PLEJm7Lb91Afl1Vnm
7jmPW41sV6IHlQEsevfzYH/k6K8T/G2qT8LU0jcMdy4JhOtwZ2IBCbGbSLUQA8qK
ImKbAJ6+/dqreS+ZehHc3GcA2Yi2mB7zqy8uZCETty+oPEHFLtURfNmlfKGDb7er
HVukfF/VM1kcfoaZSdgzttD2OFyM9dkTCSpIZLYvDfou8UNmDBl1MKNbqxLWePQm
ilQcEIMzjIpvr2o/Kj8WMzt15Vl3/RZcvjvoph10Lx7xL2k2suv/oLfIjBqCszny
Zjqde0/3ecxLN+4uC1OyjLQccqmcm/n5PP4XhpgfZl1iAtnI+HtcPfGqR9PZfveL
2sFEgj455TMe6qFdT0az
=pj1z
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Sep_2012_13_17_00_+1000_lrjVWCpy/jwbQFRT--
