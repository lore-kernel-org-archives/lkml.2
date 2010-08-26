Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab0HZNWk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:22:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33109 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752079Ab0HZNV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:21:27 -0400
Message-Id: <20100826132126.574847625@sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 26 Aug 2010 08:20:00 -0500
From: steiner@sgi.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [Patch 23/25] GRU - update driverr version
References: <20100826131937.108920216@sgi.com>
Content-Disposition: inline; filename=uv_gru_version
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the GRU driver version to 1.0.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/grutables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:46.307537752 -0500
+++ linux/drivers/misc/sgi-gru/grutables.h	2010-06-09 08:11:50.819414779 -0500
@@ -165,7 +165,7 @@ extern unsigned int gru_max_gids;
 #define GRU_MAX_GRUS		(GRU_MAX_BLADES * GRU_CHIPLETS_PER_BLADE)
 
 #define GRU_DRIVER_ID_STR	"SGI GRU Device Driver"
-#define GRU_DRIVER_VERSION_STR	"0.85"
+#define GRU_DRIVER_VERSION_STR	"1.00"
 
 #define gru_random()    get_cycles()
 

