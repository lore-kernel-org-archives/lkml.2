Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab0I2BZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 21:25:37 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:46895 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0I2BZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 21:25:36 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Cc: mm-commits@vger.kernel.org
Subject: Re: mmotm 2010-09-28-16-13 uploaded
In-Reply-To: Your message of "Tue, 28 Sep 2010 16:13:38 PDT."
             <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201009282344.o8SNiliN024981@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1285723534_8264P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Sep 2010 21:25:34 -0400
Message-ID: <139397.1285723534@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4CA2958F.01BB,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1285723534_8264P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Sep 2010 16:13:38 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-09-28-16-13 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Also needs this from Randy Dunlap:

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build error and config symbol comment:

drivers/hwmon/pkgtemp.c:413: error:'pkgtemp_cpu_notifier' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/hwmon/pkgtemp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20100928.orig/drivers/hwmon/pkgtemp.c
+++ linux-next-20100928/drivers/hwmon/pkgtemp.c
@@ -386,7 +386,7 @@ static int __cpuinit pkgtemp_cpu_callbac
 static struct notifier_block pkgtemp_cpu_notifier __refdata = {
 	.notifier_call = pkgtemp_cpu_callback,
 };
-#endif				/* !CONFIG_HOTPLUG_CPU */
+#endif				/* CONFIG_HOTPLUG_CPU */
 
 static int __init pkgtemp_init(void)
 {
@@ -408,9 +408,9 @@ static int __init pkgtemp_init(void)
 		err = -ENODEV;
 		goto exit_driver_unreg;
 	}
-#endif
-
+#else
 	register_hotcpu_notifier(&pkgtemp_cpu_notifier);
+#endif
 	return 0;
 
 #ifndef CONFIG_HOTPLUG_CPU


--==_Exmh_1285723534_8264P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFMopWOcC3lWbTT17ARAjCIAKDtPvk4Wd7b1zoFDaKyCj9nBPuPjwCeI28k
qyanNe7iVR4vlZVSArxc5Uw=
=1FgI
-----END PGP SIGNATURE-----

--==_Exmh_1285723534_8264P--

