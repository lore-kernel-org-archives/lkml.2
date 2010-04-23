Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab0DWBlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:41:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:42181 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab0DWBlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:41:03 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-22-16-38 uploaded
In-Reply-To: Your message of "Fri, 23 Apr 2010 09:46:25 +0900."
             <20100423094625.70beb17a.kamezawa.hiroyu@jp.fujitsu.com>
From: Valdis.Kletnieks@vt.edu
References: <201004230006.o3N06DNO019315@imap1.linux-foundation.org>
            <20100423094625.70beb17a.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1271986847_5018P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Apr 2010 21:40:47 -0400
Message-ID: <10748.1271986847@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BD0FAA0.00EF,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1271986847_5018P
Content-Type: text/plain; charset=us-ascii

On Fri, 23 Apr 2010 09:46:25 +0900, KAMEZAWA Hiroyuki said:
> On Thu, 22 Apr 2010 16:38:55 -0700
> akpm@linux-foundation.org wrote:
> 
> > The mm-of-the-moment snapshot 2010-04-22-16-38 has been uploaded to

> > drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-ada
pter.patch
> 
> This patch can't be applied...
> maybe drivers/usb/net directory doesn't exist ??
> 
> Now I just skip this one. 

Looks more like a path error in the patch.

diff -puN drivers/usb/net/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter drivers/usb/net/kaweth.c
|--- a/drivers/usb/net/kaweth.c~drivers-usb-net-kawethc-add-device-allied-telesyn-at-usb10-usb-ethernet-adapter
|+++ a/drivers/usb/net/kaweth.c

However, there *is* a drivers/net/usb/kaweth.c and the patch applies once
you fix the paths.

kaweth-new-usb-id-07c9-b010-allied-telesyn-at-usb10.patch appears to be a
near-duplicate (correct path in diff, different comment.

--==_Exmh_1271986847_5018P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL0PqfcC3lWbTT17ARApFUAJ947N0lEUkRPTw9ztStuDqJvNe2LACgl3T0
+bT7JsSqbJ9AzmomttjZyYY=
=EBKL
-----END PGP SIGNATURE-----

--==_Exmh_1271986847_5018P--

