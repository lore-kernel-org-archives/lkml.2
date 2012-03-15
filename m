Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab2COOVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:21:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:21400 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab2COOU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:20:58 -0400
From: "Rajak, Rishikesh Kumar (FEL/PQSi)" <rishikesh.rajak@hp.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "ltp-list@lists.sourceforge.net" <ltp-list@lists.sourceforge.net>,
        "vapier@gentoo.org" <vapier@gentoo.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "risrajak@linux.vnet.ibm.com" <risrajak@linux.vnet.ibm.com>
Subject: RE: [LTP] [PATCH] MAINTAINERS: update the maintain-ship of LTP
Thread-Topic: [LTP] [PATCH] MAINTAINERS: update the maintain-ship of LTP
Thread-Index: AQHNArXAvCKeGhzLKEqkr2/5N9WKlpZrZ1ig
Date: Thu, 15 Mar 2012 14:19:56 +0000
Message-ID: <80145D4278C2654ABC4879063FB2FFA9530ACB12@G4W3231.americas.hpqcorp.net>
References: <1331820621-10095-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1331820621-10095-1-git-send-email-gaowanlong@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.216.12.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wanlong,

Review-By: Rishikesh K Rajak <rishikesh.rajak@hp.com>

No issue with me. But still I am closely watching this place though my responsibilities have changed.

Regards
Rishi

-----Original Message-----
From: Wanlong Gao [mailto:gaowanlong@cn.fujitsu.com]
Sent: Thursday, March 15, 2012 7:40 PM
To: akpm@linux-foundation.org
Cc: ltp-list@lists.sourceforge.net; vapier@gentoo.org; linux-kernel@vger.kernel.org; risrajak@linux.vnet.ibm.com
Subject: [LTP] [PATCH] MAINTAINERS: update the maintain-ship of LTP

The maintain-ship of LTP is out of date, so update it.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Cyril Hrubis <chrubis@suse.cz>
Signed-off-by: Caspar Zhang <caspar@casparzhang.com>
---
 MAINTAINERS |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 95e4e43..3e10e6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4173,12 +4173,14 @@ F:      Documentation/hwmon/ltc4261
 F:     drivers/hwmon/ltc4261.c

 LTP (Linux Test Project)
-M:     Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
-M:     Garrett Cooper <yanegomi@gmail.com>
+M:     Shubham Goyal <shubham@linux.vnet.ibm.com>
 M:     Mike Frysinger <vapier@gentoo.org>
-M:     Subrata Modak <subrata@linux.vnet.ibm.com>
+M:     Cyril Hrubis <chrubis@suse.cz>
+M:     Caspar Zhang <caspar@casparzhang.com>
+M:     Wanlong Gao <gaowanlong@cn.fujitsu.com>
 L:     ltp-list@lists.sourceforge.net (subscribers-only)
 W:     http://ltp.sourceforge.net/
+T:     git git://github.com/linux-test-project/ltp.git
 T:     git git://ltp.git.sourceforge.net/gitroot/ltp/ltp-dev
 S:     Maintained

--
1.7.10.rc1


------------------------------------------------------------------------------
This SF email is sponsosred by:
Try Windows Azure free for 90 days Click Here
http://p.sf.net/sfu/sfd2d-msazure
_______________________________________________
Ltp-list mailing list
Ltp-list@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/ltp-list
