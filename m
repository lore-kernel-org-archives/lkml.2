Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab1BKVwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:52:47 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:51184 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab1BKVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:52:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: akpm@linux-foundation.org, Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-02-10-16-26 uploaded
In-Reply-To: Your message of "Thu, 10 Feb 2011 16:26:36 PST."
             <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201102110100.p1B10sDx029244@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1297461155_5044P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Feb 2011 16:52:35 -0500
Message-ID: <53491.1297461155@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020205.4D55AFA6.0032,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1297461155_5044P
Content-Type: text/plain; charset=us-ascii

On Thu, 10 Feb 2011 16:26:36 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2011-02-10-16-26 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

CONFIG_ZCACHE=m dies a horrid death:

  MODPOST 257 modules
ERROR: "xv_malloc" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_new_pool" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_put" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_destroy_pool" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "xv_free" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "xv_get_object_size" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_get" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_flush_object" [drivers/staging/zcache/zcache.ko] undefined!
ERROR: "tmem_flush_page" [drivers/staging/zcache/zcache.ko] undefined!
make[1]: *** [__modpost] Error 1

Looks like none of those have EXPORT_SYMBOL on them.


--==_Exmh_1297461155_5044P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNVa+jcC3lWbTT17ARAqUeAJ9PLoPrw+ZOUe8hL90Xa3ZfHnkNuQCfbkQP
kdW3CG+FiiGg8FrWeZC8tfU=
=QNea
-----END PGP SIGNATURE-----

--==_Exmh_1297461155_5044P--

