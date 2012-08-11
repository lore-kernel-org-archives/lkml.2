Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab2HKUcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 16:32:52 -0400
Received: from h219-110-095-176.catv01.itscom.jp ([219.110.95.176]:49265 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754946Ab2HKUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 16:32:35 -0400
X-Greylist: delayed 1500 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Aug 2012 16:32:27 EDT
From: Masatake YAMATO <yamato@redhat.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masatake YAMATO <yamato@redhat.com>
Subject: [PATCH v2 07/15] packet: declaring packet protocols has its own proc entry
Date: Sun, 12 Aug 2012 05:07:10 +0900
Message-Id: <1344715638-22997-7-git-send-email-yamato@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring packet protocols has its own proc entry.

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 net/packet/af_packet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ceaca7c..6a0e47c 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2564,6 +2564,7 @@ static struct proto packet_proto = {
 	.name	  = "PACKET",
 	.owner	  = THIS_MODULE,
 	.obj_size = sizeof(struct packet_sock),
+	.has_own_proc_entry= 1,
 };
 
 /*
-- 
1.7.11.2

