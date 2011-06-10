Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1FJNmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:42:50 -0400
Received: from smtp.nokia.com ([147.243.1.48]:39389 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab1FJNmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:42:37 -0400
From: Carlos Chinea <carlos.chinea@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Subject: [RFC PATCHv5 6/7] HSI: Add HSI API documentation
Date: Fri, 10 Jun 2011 16:38:43 +0300
Message-Id: <1307713124-3946-7-git-send-email-carlos.chinea@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
References: <1307713124-3946-1-git-send-email-carlos.chinea@nokia.com>
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
index b638e50..5f70f73 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -437,4 +437,21 @@ X!Idrivers/video/console/fonts.c
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
1.7.1

