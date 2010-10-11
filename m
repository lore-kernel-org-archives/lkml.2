Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0JKJFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:05:24 -0400
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:40787 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab0JKJFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:05:18 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv3 6/7] HSI: Add HSI API documentation
Date: Mon, 11 Oct 2010 12:06:27 +0300
Message-Id: <1286787988-29013-7-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1286787988-29013-1-git-send-email-carlos.chinea@nokia.com>
References: <1286787988-29013-1-git-send-email-carlos.chinea@nokia.com>
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
index feca075..28ab783 100644
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

