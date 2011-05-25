Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab1EYTl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:41:27 -0400
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:44515 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752428Ab1EYTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:41:25 -0400
From: Roland Dreier <roland@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH] MAINTAINERS: Remove Joe Eykholt from Cisco fnic maintainers
Date: Wed, 25 May 2011 12:41:19 -0700
Message-Id: <1306352479-15409-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Joe is no longer working at Cisco and his @cisco.com email bounces.
Presumably he is no longer maintaining fnic either.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8df8d2d..4eb44b4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1763,7 +1763,6 @@ F:	include/linux/clk.h
 
 CISCO FCOE HBA DRIVER
 M:	Abhijeet Joglekar <abjoglek@cisco.com>
-M:	Joe Eykholt <jeykholt@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
