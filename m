Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab1HaUPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 16:15:54 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:36405 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1HaUPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 16:15:51 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: zcache config question...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1314821747_5176P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 31 Aug 2011 16:15:47 -0400
Message-ID: <54182.1314821747@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E5E9674.006F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1314821747_5176P
Content-Type: text/plain; charset=us-ascii

linux-next-20110831.

This config builds:

CONFIG_ZCACHE=y
CONFIG_ZRAM=m

but I'm not convinced it actually *should* be buildable?  I haven't gotten
brave enough to boot the resulting kernel and see what happens when
xv_malloc() gets called before zram.ko gets modprobed....

--==_Exmh_1314821747_5176P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOXpZzcC3lWbTT17ARAsHaAKDVomTxlq09/pMqefdbCrR2RK4SCwCghQSj
zVB/hgRtoiSwYG2ZX806sPI=
=Cww6
-----END PGP SIGNATURE-----

--==_Exmh_1314821747_5176P--

