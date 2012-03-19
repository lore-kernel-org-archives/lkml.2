Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab2CSFmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:42:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54604 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab2CSFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:42:40 -0400
Date: Mon, 19 Mar 2012 16:42:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: linux-next: manual merge of the moduleh tree with the vfs tree
Message-Id: <20120319164226.47a03eac5ab3ff9365714208@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__19_Mar_2012_16_42_26_+1100_=jSW.98qObSeO9h6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__19_Mar_2012_16_42_26_+1100_=jSW.98qObSeO9h6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in fs/inode.c
between commit 8bf58c2aaafb ("trim includes in inode.c") from the vfs
tree and commit 630d9c47274a ("fs: reduce the use of module.h wherever
possible") from the moduleh tree.

The former makes the latter patch unneeded (it also replaces module.h
with export.h).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__19_Mar_2012_16_42_26_+1100_=jSW.98qObSeO9h6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPZsdCAAoJEECxmPOUX5FEtZQP/0wNxXNcO85OdkxfgRJWmf8o
OkfPVXXtjsLbQX4n4StmiKTnodsI2Ws2ZHvJ1N6LRegvWFgf9XGat0JlmjqtUDns
Fjf79MuhFlMm0FyW2CfQJzYdCcef7A3GhosVTwzggBxOtoeGL7xgkAhD9dqgaO/3
/h37YfhOi/QySO2iDLp/9lU8uTOTXB4u65N9OQOS3bYIv9pyPCec0uyRu0jz4aVL
pyQfHiCFa5d2izPxpcINmUp9qBNDPeV+KCvb+msJPU4tFodoA4v15sKujRR0Nz/9
/TYZATq2WMcoI6PMqweCwKucvXhq3WRhsjFbcbMAAa5m5NSlaaIdbhxmQmYPjnDm
27vCyGWTVsXmV3v58Z2WhIEuJ75+AH/xTMI6c+6RqOia5ws4Fixn6cTLHMk5r6YB
Io4ZC9NVWNEn7Xz01ND0fVDkmSdJ26Kln2hl6silUreKkkdmENUgifJsooOJeixM
CWz9kEa8R4dthYqgSPFTTmkxqSePefiUxCfAbl1mgVUKdEPANdzD7SLdkjZ5I+1p
YRx+KNiyCFNc1E27W92Djb03ygjDYvEACFgWDCgRbLYJIdSpz+xDPw/aoUiXJrqq
JWor217zyTyTWo2Y+CNG63O8qiF8P2rn3HqqxjCO9AmP92Vie4MSHOEjBS5K3qst
SLlpXWErSGxL4P3vLtbk
=5kuq
-----END PGP SIGNATURE-----

--Signature=_Mon__19_Mar_2012_16_42_26_+1100_=jSW.98qObSeO9h6--
