Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2K2EYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:24:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53142 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2K2EYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:24:15 -0500
Date: Thu, 29 Nov 2012 15:24:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the driver-core tree with the tip tree
Message-Id: <20121129152411.5333767f38065751b4723663@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_24_11_+1100_AYlMF/RLvHABQH1o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_24_11_+1100_AYlMF/RLvHABQH1o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
lib/Makefile between commit e6459606b04e ("lib: Add early cpio decoder")
from the tip tree and commit 610141ee651c ("lib: kobject_uevent is no
longer dependant on CONFIG_HOTPLUG") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/Makefile
index e91b9df,66787b9..0000000
--- a/lib/Makefile
+++ b/lib/Makefile
@@@ -12,7 -12,7 +12,7 @@@ lib-y :=3D ctype.o string.o vsprintf.o cm
  	 idr.o int_sqrt.o extable.o \
  	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
  	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
- 	 is_single_threaded.o plist.o decompress.o earlycpio.o
 -	 is_single_threaded.o plist.o decompress.o kobject_uevent.o
++	 is_single_threaded.o plist.o decompress.o earlycpio.o kobject_uevent.o
 =20
  lib-$(CONFIG_MMU) +=3D ioremap.o
  lib-$(CONFIG_SMP) +=3D cpumask.o

--Signature=_Thu__29_Nov_2012_15_24_11_+1100_AYlMF/RLvHABQH1o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtuNrAAoJEECxmPOUX5FEFf8QAKSrkuHeYlMs/58n1LZH9XdZ
nXYzPPk1yuARXqwBXtNGQO+3i5VEQ0uVN+AI8uuGeUIi3x7GSHpSWNmyeUopahZ+
Chmrx+zj9UMK29F1zs46HKSgNqPmwFQHcTO/R8munoXs7hEoAwylPx4vFXMgElxZ
B91YjKUQg0mB9OPUKzbsWDQW/H6LLmT5SFRD6Jz0Y8v56eDI14+v4b16pq/8ZCO+
TBrqgtgJfI1hvzAtiI16a5OtQby6RSYlE883fP8gRqU5zuaV6fVPxjFOnUCTIW5l
j5NZztig9KmLJBC0mN+yaoaDPg92z0U5hpZkQfFLFVfbPG5W9lR9qIYcYstkXqft
rPN/br2QFGO5G9pF936DzF0LHZGbRFyuTxdt+0rBYU6TO02Zu+nDZLDUMyrWwDJN
tiv5g4M0vcBBEYzW5VjO8OTloNpAETt1COeQJcnhQmsE+Pv1R3jI1NDwQ+zjxX7D
vrti7vazisiNKa9DlyOYtu5PlfsgcbbArKV6dpHh+Za4CrSl/gUiIuJn2sQZbxON
A35ig2Heute+fJhK8sCAvBmzLHx+yABGAEQMKCWywlZ02GC/odlO/htizUruVS9d
sVpzBlIh8VLGWz3M9Tn6GnJXeE8A4n+sBsDgFgTbtHNo7Y3BjKhfJCI3HL4FglR0
1Vw4eTc/t0CLwYpycJEz
=7G/T
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_24_11_+1100_AYlMF/RLvHABQH1o--
