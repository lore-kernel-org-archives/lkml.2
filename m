Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab1LECiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:38:11 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52802 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1LECiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:38:10 -0500
Date: Mon, 5 Dec 2011 13:37:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the trivial tree with the wireless-next
 tree
Message-Id: <20111205133757.2b6cd1675543c7da26f663a5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_13_37_57_+1100_i.ZOMeC5xJ/1oPuf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_13_37_57_+1100_i.ZOMeC5xJ/1oPuf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
net/mac80211/work.c between commit e76aadc57228 ("mac80211: revert
on-channel work optimisations") from the wireless-next tree and commit
42b2aa86c667 ("treewide: Fix typos in various parts of the kernel, and
fix some comments") from the trivial tree.

The former removed the comment that was fixed in the latter, so I did
that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Dec_2011_13_37_57_+1100_i.ZOMeC5xJ/1oPuf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3C6FAAoJEECxmPOUX5FEWy0P/0xr/j4wGjTR7K9+j8XGcJsG
0kGuAkvzdF2uESyYvbJfZEUPkp3K7DjXditHnCvuMH1aOhnFWfbdMAGlOAwsp8ft
ZZ1ApLelAfX8D3QOEdueMRUqCTtUb4HIp4dkbXaTJm0YxpF/gQepinWn6EBG/+nI
/+81hX1wYQzbO/V1vyyYYsaKcOvi5SI2IK5ETTPO+dhZYOyX9DU6OQtYPPBa9j7B
D/kgcduKtiRUN5HMh/xQzubYysRx8l6f88dPDnFAKn2G3EfWfUrBqLgL3Cm/pDfj
0fQCMKioCmPhcPdACA5AK4rKM8LOpeFvaD+LBiHxwRgkgqAMQWA0ZUvlE35Fzxzv
dCyc3Tiv2mMKU2zd7+u7mT1v03a3hJ7Cg92thi/pBRD2Vzd/fmSnLKXzlWIVFpmx
OEV3WYeD5asqNB2VdjhrYvMDsS2g0QQWmoUnqJTH6yz1jcFrjsDdK2lEGWMtOFHA
Ha31+2Ivf+VERbeiaqF9A8ubnttfqdpFcnyuQBna06VIIOdmdoVxaIXq95biVd2T
/9GR436/qd+N5qmpNdQIAa/cffdc9a5jzmSX1a+HwmZk/RODP5+HuC8MR2Umlr6F
uw2SF9DnClf9lvbEHG47tYTuahXQz3eT7pC6w+dMTel7yS/pcl9WP/yZq2SL0W8D
AyM5EJsEi+1p6e4PVABK
=0g/B
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_13_37_57_+1100_i.ZOMeC5xJ/1oPuf--
