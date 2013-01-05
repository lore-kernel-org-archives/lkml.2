Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab3AEFLZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 00:11:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab3AEFLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 00:11:23 -0500
From: Jason Wang <jasowang@redhat.com>
To: gregkh@linuxfoundation.org, kys@microsoft.com, haiyangz@microsoft.com,
        linux-kernel@vger.kernel.org
Cc: thozza@redhat.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH] tools: fix a typo in hv_set_ifconfig.sh
Date: Sat,  5 Jan 2013 13:03:06 +0800
Message-Id: <1357362186-5258-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 tools/hv/hv_set_ifconfig.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
index 3e9427e..daf7ec0 100755
--- a/tools/hv/hv_set_ifconfig.sh
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -65,4 +65,4 @@ cp $1 /etc/sysconfig/network-scripts/
 interface=$(echo $1 | awk -F - '{ print $2 }')
 
 /sbin/ifdown $interface 2>/dev/null
-/sbin/ifup $interfac 2>/dev/null
+/sbin/ifup $interface 2>/dev/null
-- 
1.7.1

