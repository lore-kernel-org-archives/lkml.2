Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab1IWMsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:48:47 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:52941 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab1IWMsm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:48:42 -0400
thread-index: Acx57wy6T6YXmelHQUyYE//7IuwkjA==
Content-Transfer-Encoding: 8BIT
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
From: Tero Kristo <t-kristo@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv9 13/18] TEMP: 4430sdp: use common serial init with mux support
Date: Fri, 23 Sep 2011 15:46:21 +0300
Message-ID: <1316781986-30642-14-git-send-email-t-kristo@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
References: <1316781986-30642-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Temporary testing related patch, not meant for integration.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index c7cef44..f1151e8 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -737,17 +737,7 @@ static struct omap_board_data serial4_data __initdata = {
 
 static inline void board_serial_init(void)
 {
-	struct omap_board_data bdata;
-	bdata.flags	= 0;
-	bdata.pads	= NULL;
-	bdata.pads_cnt	= 0;
-	bdata.id	= 0;
-	/* pass dummy data for UART1 */
-	omap_serial_init_port(&bdata);
-
-	omap_serial_init_port(&serial2_data);
-	omap_serial_init_port(&serial3_data);
-	omap_serial_init_port(&serial4_data);
+	omap_serial_init();
 }
 #else
 #define board_mux	NULL
-- 
1.7.4.1


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. Kotipaikka: Helsinki
 

