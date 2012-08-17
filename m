Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2HQBKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:10:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38004 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2HQBKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:10:22 -0400
Date: Fri, 17 Aug 2012 11:10:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20120817111013.28c2f0b0ef72631968007d9a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__17_Aug_2012_11_10_13_+1000_IqHcACf7uskDD6qf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Aug_2012_11_10_13_+1000_IqHcACf7uskDD6qf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "usb_cypress_load_firmware" [drivers/staging/media/go7007/s2250-load=
er.ko] undefined!
ERROR: "b2c2_flexcop_debug" [drivers/media/pci/b2c2/b2c2-flexcop-pci.ko] un=
defined!

Given the major reorganisation going on, I have just used the v4l-dvb
tree from next-20120816 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__17_Aug_2012_11_10_13_+1000_IqHcACf7uskDD6qf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQLZn1AAoJEECxmPOUX5FEM5gP/2Sq4KO8w0+GGMMQ1PVcaILx
PFb3I7oMGQfJ6fSqsnNfwa22orsmKrEqVwXJqpcQsvStf0oxRznI3hBrkLn/3gFh
ane2zhd6La/M6gmls8dIUf0rdACmnUtH5kpiaSfMoEAjUs9drmWqrDUcuiI0ovIO
CJXlK6pmoIpGH3zy0kH2jj4OXlYL44HICCj0CeEqMeM4/uDOHYabiMEehp/S2WtT
QAPs1wtUtVBfiH81rKSgorBDVpMfBsE+NKNjztSci1231G9FC40nkVTodFjq0iDo
NUKI4LSpMJxzQHVLn4zbkr4Ve4l/FVQZjDxk/lKirdeg2JCobSyO39/LqpR3dGEH
WNW4sbn+6i4FlPyicfUr0wflSEiQiEV8YX8nzRBT5uTw+4oOA/JQxgbn/NxRkMM6
ikdoB54Qel1otiKYpi3aCRYu0G+ERK0+hUTo8QYsbRCKgbtEcA+IkndLl/ES9eNZ
rwfQpCjwev5Yq4bWgZr+DGy108mJIyJ+jZr9DZcV6yygODW334VFRoiUNSqlVrJ4
vmBEAV+rJwdkINi65dk6TPgCbTzFskDbBSWb3TI6RNPUqB6sTamH2+3Jdsw6C0Lp
GbKjW4pJWYSvHSl1JcmjsyE6dEF8dA/5tv5gyDL+348ds1BvlEFUFaJiwnc+4XEQ
XRtiLEkceD5VQ7IX6a15
=/v3c
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Aug_2012_11_10_13_+1000_IqHcACf7uskDD6qf--
