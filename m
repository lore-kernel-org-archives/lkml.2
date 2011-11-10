Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933565Ab1KJCbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:31:16 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:34143 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1KJCbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:31:15 -0500
Date: Thu, 10 Nov 2011 13:31:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20111110133106.12e519d17f6a28adfee3b883@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_Nov_2011_13_31_06_+1100_gQs2wxnThmbr=CRy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Nov_2011_13_31_06_+1100_gQs2wxnThmbr=CRy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

mm/oom_kill.c: In function 'select_bad_process':
mm/oom_kill.c:326:5: error: implicit declaration of function 'thaw_process'

Caused by commit 944e192db53c ("freezer: rename thaw_process() to
__thaw_task() and simplify the implementation").

I have used the pm tree from next-20111109 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_Nov_2011_13_31_06_+1100_gQs2wxnThmbr=CRy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOuzdqAAoJEECxmPOUX5FELm8P/3M67GPKCTr+2YlmY0HilldS
ifLfrra4cAJQcV8FF7GU0oad7tgGMKpcJUVWgkingQzgLDGkXBwBncjVfhz1fNas
7O/u4Zd6zAUM+GsK77X/txAlw6WJJwQQDW3xmcjFX+XH5ZRow3/q5+BSZyu9eXbH
/FAYWP4Yj89OEeM6x0TrIA3nOnzlTdvtFN17SR0tNg2n04kRPqW8m4S8W0QFR2in
xaAIKTGHDJKvvUsiEMzdtQaj54eXt0yAEzRitGSAjc6FAjPCAE5xBVR3bOcncfmf
oAKsK9cr87Ulcfh+fKMY1zogOMxq0WBDwVzinDeNJ1cYzAQ40BIZKERxvaVfpseb
A/Tr2Ou7UIudckdTZqffYI3wy9D37JPbxEwxeMMMmrmAuPOGgcyelHI2qIIlVuyg
iyX+0GmREQjTXctNte3sp0o8q3xAQ+Ihp7BGPGeQbbtp6paso8lZ/rT96c4bxcTn
LTvoSGI1HMbNCkNghf88O002J/BsiozcyYyVFqWk/WoPc/qOxsGC3On4/tPvLJXu
DBFKGlpuFzmFVeK50J5rc6qxZ2wGvy3CjARsr0jCsLQ8j6jrID6FBGVX3ADePtP9
ecMCZ8k5/OBCkAlQpXwH8qPFvhQ/g/JHFG06w8So4Jps5cmao7QkNkbpb0j4gGAo
vZ2MUDYVAsaSir6Vbxdz
=LIRJ
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Nov_2011_13_31_06_+1100_gQs2wxnThmbr=CRy--
