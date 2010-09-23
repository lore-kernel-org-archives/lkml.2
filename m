Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab0IWD1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:27:05 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46853 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab0IWD1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:27:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-09-22 - build error in drivers/staging/zram
In-Reply-To: Your message of "Wed, 22 Sep 2010 16:12:09 PDT."
             <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201009222343.o8MNh9Mp023931@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285212366_4396P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Sep 2010 23:26:06 -0400
Message-ID: <56264.1285212366@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020208.4C9AC8CF.011D,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285212366_4396P
Content-Type: text/plain; charset=us-ascii

On Wed, 22 Sep 2010 16:12:09 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-09-22-16-11 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Looks like zram-free-percpu-data-on-module-exit.patch has issues:

  CC [M]  drivers/staging/zram/zram_drv.o
drivers/staging/zram/zram_drv.c: In function 'zram_reset_device':
drivers/staging/zram/zram_drv.c:500:2: error: incompatible type for argument 1 of 'free_percpu'
include/linux/percpu.h:153:13: note: expected 'void *' but argument is of type 'struct zram_stats'
make[3]: *** [drivers/staging/zram/zram_drv.o] Error 1


--==_Exmh_1285212366_4396P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMmsjOcC3lWbTT17ARAv75AKCj3kcRM/vnrqNEdVp0yxrerHv8BgCgp5GO
p8nQX4NcEbMRyxr6++52VOk=
=NUDr
-----END PGP SIGNATURE-----

--==_Exmh_1285212366_4396P--

