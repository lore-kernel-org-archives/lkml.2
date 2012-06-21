Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab2FUMZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 08:25:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:48125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759225Ab2FUMZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 08:25:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="asc'?scan'208";a="160663157"
Message-ID: <1340281745.13910.211.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] exofs: stop using s_dirt
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Boaz Harrosh <bharrosh@panasas.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Benny Halevy <bhalevy@tonian.com>, osd-dev@open-osd.org
Date: Thu, 21 Jun 2012 15:29:05 +0300
In-Reply-To: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
References: <1338810507-26539-1-git-send-email-dedekind1@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9Lk6sav+TbYG/sneFGSB"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9Lk6sav+TbYG/sneFGSB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-06-04 at 14:48 +0300, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
>=20
> Exofs has the '->write_super()' handler and makes some use of the '->s_di=
rt'
> superblock flag, but it really needs neither of them because it never set=
s
> 's_dirt' to one which means the VFS never calls its '->write_super()' han=
dler.
> Thus, remove both.
>=20
> Note, I am trying to remove both 's_dirt' and 'write_super()' from VFS
> altogether once all users are gone.
>=20
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Al or Boaz, would you please consider picking this patch?

--=20
Best Regards,
Artem Bityutskiy

--=-9Lk6sav+TbYG/sneFGSB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP4xORAAoJECmIfjd9wqK05hIP/0jPbhmm0w4vGKT1jiBQp20D
s0iyaKvbZh+FUJLzvpJX2c37I5BSYdYEHlWwpCui6oS2/bp8QwEPqH6w8dhlfn+y
HaVJWY005Wnhfg506arW0fH5Evyu95re0MoLxXWbe0/vmAXI8StQ3YE7PEzU4EVh
oVant2AdpWKOqJGWvZzQ3Cctd95GEhTR6KUhwSwSrqDV18h9/8DHVENIgPnlBbj8
R1Yaw25t1dP2oXmqCZhRafDDduas/PJciVRqt4bvZ6q7xbRpbnz9dtHMzs0LOzOx
PRrX+on0utFMZ22m5HTmahiJ5HbJaBEwdWTGJ8jTfn8MgUM7ZYzJC7bTVssHm8ov
2DHqbDc8t3ykFfxgMCusPRQK0Z0GNRBKrYJf75nayKSOCyPALiNmNPQAeSZ1sZLQ
4kAmYQjDXuPmIdHoHedb5BmmnjCbg9TsCz5PwityiZ2y13lUc8OuHvJzb2a45prU
kVInU0XOWj1FaIPv2vuULGvlZHbtczyLBn/7F1x+DsloR6MVeG3/KI2U7UfIdo/H
n/6KH9usRh48UBfUfHCIDbfkuMXxDJSM6uGCHiS2QqUkJQzTWQ9+ok9/aPFC6Ldo
D/KDJWKLJYRIYsi16Ke2QY3KdXkbctuq5nnJMnILicZ00HSxO0kF44KlXr8PS2ft
p55K6k9zatv5ccwKE9at
=X+k9
-----END PGP SIGNATURE-----

--=-9Lk6sav+TbYG/sneFGSB--

