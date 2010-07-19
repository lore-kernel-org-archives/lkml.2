Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966943Ab0GSVjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:39:43 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40076 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966890Ab0GSViz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:38:55 -0400
Message-Id: <20100719213854.884746203@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 19 Jul 2010 16:32:41 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 23/25] GRU - update driverr version
References: <20100719213651.362618144@sgi.com>
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
 

