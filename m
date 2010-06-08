Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab0FHNY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 09:24:56 -0400
Received: from mx1.tander.ru ([81.30.112.106]:34099 "EHLO gw.tander.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754934Ab0FHNYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 09:24:55 -0400
Message-ID: <4C0E443F.7070204@gw.tander.ru>
Date: Tue, 08 Jun 2010 17:23:11 +0400
From: =?UTF-8?B?0J3QtdCy0LXQvdGH0LDQvdC90YvQuSDQkNC70LXQutGB0LDQvdC00YA=?= 
	<nevenchannyy@gw.tander.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100523 Lightning/1.0b2pre Thunderbird/3.0.4 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Cleanup mmzone.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7f4ab448f88ae2d2bcb3d5f00e85300446d6495a
Author: Alexander Nevenchannyy <a.nevenchannyy@gmail.com>
Date:   Tue Jun 8 15:45:52 2010 +0400

    [PATCH] Cleanup mmzone.h
    
    get_zone_counts() was dropped from kernel tree, see:
http://www.mail-archive.com/mm-commits@vger.kernel.org/msg07313.html
    but it's have prototype in header file. So cleanup them.
    
    Author:    Alexander Nevenchannyy <a.nevenchannyy@gmail.com>
        modified:   include/linux/mmzone.h

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index b4d109e..9ed9c45 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -651,8 +651,6 @@ typedef struct pglist_data {
 #include <linux/memory_hotplug.h>
 
 extern struct mutex zonelists_mutex;
-void get_zone_counts(unsigned long *active, unsigned long *inactive,
-                       unsigned long *free);
 void build_all_zonelists(void *data);
 void wakeup_kswapd(struct zone *zone, int order);
 int zone_watermark_ok(struct zone *z, int order, unsigned long mark,

