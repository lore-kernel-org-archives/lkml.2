Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab0ENUff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:35:35 -0400
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:33766 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab0ENUfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:35:33 -0400
X-MXL-Hash: 4bedb415656e388a-d213e54029a037ded0010287321a607c64f125cb
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "john@johnmccutchan.com" <john@johnmccutchan.com>,
       "rlove@rlove.org" <rlove@rlove.org>,
       "eparis@parisplace.org" <eparis@parisplace.org>
Date: Fri, 14 May 2010 15:35:21 -0500
Subject: [PATCH] inotify_user.c: make local symbol static
Thread-Topic: [PATCH] inotify_user.c: make local symbol static
Thread-Index: AcrzpPj8jFB5JAntQmOLg2ELPGCFMw==
Message-ID: <0D753D10438DA54287A00B0270842697636F0530C8@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=t6T0zWA06uIA:10 a=0qYQvVkOOIcA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=qhvANl0glaz90f+3g7Keqg==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=tg_WFcpRAAAA:8 a=TPhl1QgxAAAA:8 a=77d_1CzMA]
X-AnalysisOut: [AAA:8 a=2JnYpa40o4YAnwqvz6IA:9 a=U7NAYwx3CeaDjI6Q_VDEu2K5P]
X-AnalysisOut: [-gA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=Gi4hu8TlFacA:1]
X-AnalysisOut: [0 a=IhvSSKzWGJYA:10 a=w2G1Yk43JnIA:10 a=cVU5B57R_jJqPBC5:2]
X-AnalysisOut: [1 a=x8b8-mfWstgIKVBh:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4EKZjaS029458

The symbol inotify_max_user_watches is not used outside this
file and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: John McCutchan <john@johnmccutchan.com>
Cc: Robert Love <rlove@rlove.org>
Cc: Eric Paris <eparis@parisplace.org>

---

diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
index e46ca68..9c676a6 100644
--- a/fs/notify/inotify/inotify_user.c
+++ b/fs/notify/inotify/inotify_user.c
@@ -46,7 +46,7 @@
 /* these are configurable via /proc/sys/fs/inotify/ */
 static int inotify_max_user_instances __read_mostly;
 static int inotify_max_queued_events __read_mostly;
-int inotify_max_user_watches __read_mostly;
+static int inotify_max_user_watches __read_mostly;
 
 static struct kmem_cache *inotify_inode_mark_cachep __read_mostly;
 struct kmem_cache *event_priv_cachep __read_mostly;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
