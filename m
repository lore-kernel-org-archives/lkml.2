Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab1BWUJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:09:16 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54775 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1BWUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:09:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: linux-next still missing patch for zcache modular Kconfig/build issue
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1298491740_5041P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 23 Feb 2011 15:09:00 -0500
Message-ID: <21508.1298491740@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4D65695D.00D1,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1298491740_5041P
Content-Type: text/plain; charset=us-ascii

I know this is a known and solved problem with CONFIG_ZCACHE=m I hit a while back:

  Building modules, stage 2.
  MODPOST 258 modules
ERROR: "xv_malloc" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_new_pool" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_put" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_destroy_pool" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "xv_free" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "xv_get_object_size" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_get" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_flush_object" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_flush_page" [drivers/staging/zcache/zcache.ko] undefined!

The patch for this isn't in the linux-next tree I pulled yesterday - what happened to it?


--==_Exmh_1298491740_5041P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNZWlccC3lWbTT17ARAltfAKCsvedFj5BVpT+8G64/3p2l7CPVdgCfd/GW
9xS2WGiWr8kgPpuTAYRbw1s=
=y6Jb
-----END PGP SIGNATURE-----

--==_Exmh_1298491740_5041P--

