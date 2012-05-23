Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202Ab2EWCfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:35:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab2EWCfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:35:11 -0400
Date: Wed, 23 May 2012 12:35:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: bad merge in the block tree
Message-Id: <20120523123507.16cdad139c84e48abb7ad7f5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_May_2012_12_35_07_+1000_kPP8HuB3.ogQN7rQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_May_2012_12_35_07_+1000_kPP8HuB3.ogQN7rQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Commit 21731057017b ("Merge branch 'for-3.5/drivers' into for-next") has
left a conflict marker in Documentation/feature-removal-schedule.txt ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_May_2012_12_35_07_+1000_kPP8HuB3.ogQN7rQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvEzbAAoJEECxmPOUX5FEJGcP/iV06YcmpQmeCSlZvIYQlrIL
pVgjDnz3NmiHaH51f0CYT5gt/UhVPidsV1z/2nhEZJS3/S9QE9u5/0zKFCCQDKbr
iErBCp9o2ymQjRShd8cfeR2cQYsuQIRhWtBYlDjxSjOYLnlU8HTe/PNROjVk1F83
/AhMuX3X2Ni9zzqsIR5Vsml/yFKGcTHQzQS/t0igY+e2vM44clYEmpghluKmKp9I
QuKrYRDZDmNyTcWsxAsIaokqGQBG/aWkaAH/U5py/j3/BwArpXChsOA95LVwPd9g
EzIygxZ8lYBsTImt2K2iUPllZpAdjfYmaLxUZPx3+mFYY4X2SWLj0vH/X7722bO+
jl3/0tatVBGEiz1uoGGPeo8H50hXkSfbRMPG9nWhCZBjl4bVmQHOGkiN5E0ucZp2
JuimCgAY/WxXQrC92RzHxLOxqJHW4yaQrzizlHdakb7E6/i2JMEG/VXOR671DpsL
RCG6wVsDX0aM7O9pHinKvmpuNe6bnLRkW/KzCz9LkcrGxKfEhqrwn4KCyiuikgO0
I7s6NiDBw+wks1trMfBfF3agTiM1ibDXEiNOk9oEsJDZZwaIWNMdo42qQKNRts1S
mvaihqjx6oWMWPTAIkMz0i7/68SLlnuaEusajFuZdTibM7bYJkNXuvBvopVPcavs
5TB9NUNy6doSdeTUmKrJ
=3td9
-----END PGP SIGNATURE-----

--Signature=_Wed__23_May_2012_12_35_07_+1000_kPP8HuB3.ogQN7rQ--
