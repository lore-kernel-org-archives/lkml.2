Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab0EGPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 11:16:29 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49554 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab0EGPQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 11:16:26 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv2 6/7] HSI: Add HSI API documentation
Date: Fri,  7 May 2010 18:18:36 +0300
Message-Id: <1273245517-30712-7-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
References: <1273245517-30712-1-git-send-email-carlos.chinea@nokia.com>
X-OriginalArrivalTime: 07 May 2010 15:15:54.0187 (UTC) FILETIME=[2FB9F9B0:01CAEDF8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an entry for HSI in the device-drivers section of
the kernel documentation.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
---
 Documentation/DocBook/device-drivers.tmpl |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 1b2dd4f..92b763b 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -428,4 +428,21 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/i2c/i2c-core.c
   </chapter>
 
+  <chapter id="hsi">
+     <title>High Speed Synchronous Serial Interface (HSI)</title>
+
+     <para>
+	High Speed Synchronous Serial Interface (HSI) is a
+	serial interface mainly used for connecting application
+	engines (APE) with cellular modem engines (CMT) in cellular
+	handsets.
+
+	HSI provides multiplexing for up to 16 logical channels,
+	low-latency and full duplex communication.
+     </para>
+
+!Iinclude/linux/hsi/hsi.h
+!Edrivers/hsi/hsi.c
+  </chapter>
+
 </book>
-- 
1.5.6.5

