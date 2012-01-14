Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2ANSQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 13:16:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61948 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115Ab2ANSQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 13:16:36 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: Jesse Gross <jesse@nicira.com>, "David S. Miller" <davem@davemloft.net>,
        dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devendra.aaru@gmail.com
Subject: [PATCH 1/1] remove version.h includes in net/openvswitch/
Date: Sat, 14 Jan 2012 23:46:21 +0530
Message-Id: <1326564981-7142-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove version.h includes in net/openswitch/ as reported by make versioncheck.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 net/openvswitch/datapath.c           |    1 -
 net/openvswitch/datapath.h           |    1 -
 net/openvswitch/vport-internal_dev.c |    1 -
 net/openvswitch/vport.c              |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 9a27251..d9d01cb 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -36,7 +36,6 @@
 #include <linux/rcupdate.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
-#include <linux/version.h>
 #include <linux/ethtool.h>
 #include <linux/wait.h>
 #include <asm/system.h>
diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
index 5b9f884..c73370c 100644
--- a/net/openvswitch/datapath.h
+++ b/net/openvswitch/datapath.h
@@ -25,7 +25,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/u64_stats_sync.h>
-#include <linux/version.h>
 
 #include "flow.h"
 
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index 8fc28b8..322b8d2 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -23,7 +23,6 @@
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
 #include <linux/skbuff.h>
-#include <linux/version.h>
 
 #include "datapath.h"
 #include "vport-internal_dev.h"
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 7f0ef37..6c066ba 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -27,7 +27,6 @@
 #include <linux/rcupdate.h>
 #include <linux/rtnetlink.h>
 #include <linux/compat.h>
-#include <linux/version.h>
 
 #include "vport.h"
 #include "vport-internal_dev.h"
-- 
1.7.1

