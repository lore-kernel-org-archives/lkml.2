Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1E0Xi3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:38:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab1E0Xi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:38:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=t9MI019uMlqPkWCZuEeqKWRpahKGuTU4S0pawlam8yWfEcFpFB13oGUNcsV3YvZiTz
         MsO2IkwZo12tBuErOfA/d3s/zOvm+8T6cQ1l7dV0EpJ9WwS0HMUiGC4b3oswh63wjqRL
         WY74qdkOYcJW3DEH1S8Qox+/kLfPVWlyFUu8M=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] staging: tty: fixed some whitespace coding style issues
Date: Sat, 28 May 2011 01:38:18 +0200
Message-Id: <1306539498-4606-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some whitespace coding style issues.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/tty/cd1865.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tty/cd1865.h b/drivers/staging/tty/cd1865.h
index 8c2ad65..48df113 100644
--- a/drivers/staging/tty/cd1865.h
+++ b/drivers/staging/tty/cd1865.h
@@ -32,7 +32,7 @@
 #define SX_ID           0x10
 
 /* Definitions for Cirrus Logic CL-CD186x 8-port async mux chip */
- 
+
 #define CD186x_NCH       8       /* Total number of channels                */
 #define CD186x_TPC       16      /* Ticks per character                     */
 #define CD186x_NFIFO	 8	 /* TX FIFO size                            */
@@ -95,7 +95,7 @@
 
 
 /* Global Interrupt Channel Register (R/W) */
- 
+
 #define GICR_CHAN       0x1c    /* Channel Number Mask                     */
 #define GICR_CHAN_OFF   2       /* Channel Number shift                    */
 
-- 
1.7.5.1

