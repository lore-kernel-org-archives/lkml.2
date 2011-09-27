Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1I0KA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:00:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab1I0KA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:00:27 -0400
Subject: [PATCH] net: fix a typo in Documentation/networking/scaling.txt
To: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
From: Jason Wang <jasowang@redhat.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org
Date: Tue, 27 Sep 2011 18:03:55 +0800
Message-ID: <20110927100354.18039.92505.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 Documentation/networking/scaling.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/networking/scaling.txt b/Documentation/networking/scaling.txt
index 58fd741..8ce7c30 100644
--- a/Documentation/networking/scaling.txt
+++ b/Documentation/networking/scaling.txt
@@ -243,7 +243,7 @@ configured. The number of entries in the global flow table is set through:
 
 The number of entries in the per-queue flow table are set through:
 
- /sys/class/net/<dev>/queues/tx-<n>/rps_flow_cnt
+ /sys/class/net/<dev>/queues/rx-<n>/rps_flow_cnt
 
 == Suggested Configuration
 

