Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1FAWOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:14:25 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64602 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab1FAWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ls58bpQy1F9N2vkh0b+BFu51PPGOvzgXDax7aopLSXeLZ8s6/+5E9wRwSmog2zZqPK
         f1frYAc9sXZUc5Bcd1okChaxm739E73HCtLlmD4IG/QVhR6K0obqqFwZ+hlZqRbb2l8h
         AEy9vr0pLBNWs/RdiannUntLYZpMPCD5wggjE=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de, vinod.koul@intel.com, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chihau Chau <chihau@gmail.com>
Subject: [PATCH] staging: intel_sst: replacing spaces by tabs
Date: Wed,  1 Jun 2011 18:13:19 -0400
Message-Id: <1306966399-31567-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a code style issue patch that replaces spaces by tabs.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/intel_sst/intelmid.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/intel_sst/intelmid.h b/drivers/staging/intel_sst/intelmid.h
index ca881b7..9607361 100644
--- a/drivers/staging/intel_sst/intelmid.h
+++ b/drivers/staging/intel_sst/intelmid.h
@@ -143,11 +143,11 @@ struct mad_stream_pvt {
 };
 
 enum mad_drv_status {
-    INIT = 1,
-    STARTED,
-    RUNNING,
-    PAUSED,
-    DROPPED,
+	INIT = 1,
+	STARTED,
+	RUNNING,
+	PAUSED,
+	DROPPED,
 };
 
 enum mad_pmic_status {
-- 
1.7.5.2

