Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2EGHDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 03:03:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40019 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab2EGHDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 03:03:31 -0400
Date: Mon, 7 May 2012 17:03:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: linux-next: build failure after merge of the final tree (kbuild
 tree related)
Message-Id: <20120507170319.03aa2fe980a39669c393a956@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_May_2012_17_03_19_+1000_y8jUCdMEavhyaK.u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_May_2012_17_03_19_+1000_y8jUCdMEavhyaK.u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allnoconfig) failed like this:

scripts/kconfig/conf --allnoconfig Kconfig
*** KCONFIG_ALLCONFIG set, but no "allno.config" or "all.config" file found

I did not have KCONFIG_ALLCONFIG set in the environment and was building
with an external object directory ...

Presumably caused by commit 5efe241eac80 ("kconfig: Add error handling to
KCONFIG_ALLCONFIG").  I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__7_May_2012_17_03_19_+1000_y8jUCdMEavhyaK.u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPp3O3AAoJEECxmPOUX5FE6moQAKRShpMKpyJQIWyp43LrnWR5
fgn6nRvxkCdbrGEFWM95O2mD73ZEuBs/siCNjUj2DnEI9sLPpCh6N+nf3rKmUbOM
khverzgTfE33qdFLdvEVkK5Pp0b4v7P8YkX0pNBCiXhWUakFvfXOsihjOk4ClpIv
ZuAnFqQlNxnikrYeH1bfmvxlyTLKLjtmNVMbJE5Nmje60LIewnLqIl63wG0id6JT
Cf2N9BgTWMrJLYTvqwEEXhnAVuBpwX8q/UypEbe9qLxpQIXzCOT8GxBf9xrx528d
yM2BGhgVUoOLVuYq9dbnLCS8zAf9mjZDg4IiVIPMvrfvYqQiOaZKFYpH2SvQ1U8s
g9oX2PrJm1LwgYcKR7VqWqiylGmXQbCW9hJqOZbGiuEZcO2LIu4U5jw7WQQp4MuN
aegACBbm6Vyccd7tI2ob51A3cIL92HZxpoL298lTABuTuaw0ZqD/MuMoJDSdJ3ct
Qeqh56YwHdARQ64FR5Gk3xP5jQqlPvQU8R4bRF60MwALtynGVIW0UO9CgQ5i9xI6
t0AMJA5SypN4ufrh2ylCfmWpYdnwxJXE3AKyl/MMnkJUsf2b196bEVwxEoFUCx/W
0YyUquHPL5q0laWkDbq6I6u2tWZqdgdgw2qPULShkOeeub39S212PUvr2KWYSVnO
IMtDk89qH2lQCZshwIMC
=irXj
-----END PGP SIGNATURE-----

--Signature=_Mon__7_May_2012_17_03_19_+1000_y8jUCdMEavhyaK.u--
