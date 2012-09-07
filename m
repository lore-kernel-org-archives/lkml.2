Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab2IGPZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:25:33 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62893 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2IGPZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:17 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/10] drivers/media/dvb-core/dvb_demux.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:44 +0200
Message-Id: <1347031488-26598-6-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/media/dvb-core/dvb_demux.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -u -p a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
--- a/drivers/media/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb-core/dvb_demux.c
@@ -424,12 +424,12 @@ static void dvb_dmx_swfilter_packet(stru
 				printk(KERN_INFO "TS speed %llu Kbits/sec \n",
 						div64_u64(speed_bytes,
 							speed_timedelta));
-			};
+			}
 
 			demux->speed_last_time = cur_time;
 			demux->speed_pkts_cnt = 0;
-		};
-	};
+		}
+	}
 
 	if (buf[1] & 0x80) {
 		dprintk_tscheck("TEI detected. "
@@ -451,9 +451,9 @@ static void dvb_dmx_swfilter_packet(stru
 						buf[3] & 0xf);
 
 			demux->cnt_storage[pid] = ((buf[3] & 0xf) + 1)&0xf;
-		};
+		}
 		/* end check */
-	};
+	}
 
 	list_for_each_entry(feed, &demux->feed_list, list_head) {
 		if ((feed->pid != pid) && (feed->pid != 0x2000))

