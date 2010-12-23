Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0LWABH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:01:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36490 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab0LWABF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:01:05 -0500
Date: Thu, 23 Dec 2010 11:00:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaud Lacombe <lacombar@gmail.com>
Subject: linux-next: build warning after merge of the kbuild tree
Message-Id: <20101223110048.09ff9f40.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Dec_2010_11_00_48_+1100_PF5e8DQFeM4u/F7i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Dec_2010_11_00_48_+1100_PF5e8DQFeM4u/F7i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

In file included from scripts/kconfig/zconf.tab.c:2502:
scripts/kconfig/expr.c:1033: warning: no previous prototype for 'expr_simpl=
ify_unmet_dep'

Introduced by commit 1137c56b7420c801147e0863845c03b07554721a ("kconfig:
simplify select-with-unmet-direct-dependency warning").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__23_Dec_2010_11_00_48_+1100_PF5e8DQFeM4u/F7i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNEpEwAAoJEDMEi1NhKgbs9EEIAKMumuD1o0ZmG04Xb6LeymVS
ApbQbpA2Mdh6kqX0dJNYw5g3SE5gFlomT/iwGQqDGsr4py5Uar4HvElXA2YJ51Bv
60ZwIJiMcxm27O7Hz6T2Mxr8TKc1036SwkH2siRKO0GBgjWj9XImbKALh5i73HSL
97DzNvqU6rh+fwDM1n4a8+wtYoWFkFv/CEE/0AHOA3DO6hm2buP/4cSpEVB5BUHp
T0K/ibsxeSJYsn/J824bNh6N09cmjY5I7GMshSL+COcE7jP+Mz90xsUIN1dxG8q8
RhGkHhFiLw0B0ZS+ZWiXAO4s7eVRRI0xCDmQSi2JxO0L/Tralz+bL1uiPAFVSlE=
=ZuVQ
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Dec_2010_11_00_48_+1100_PF5e8DQFeM4u/F7i--
