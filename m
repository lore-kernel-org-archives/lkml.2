Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692Ab1IBMZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 08:25:00 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57861 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047Ab1IBMY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 08:24:57 -0400
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC 2/2] ARM: Add VIRTUALIZATION configuration menu and virtio options
Date: Fri,  2 Sep 2011 13:24:17 +0100
Message-Id: <1314966257-7503-3-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
References: <1314966257-7503-1-git-send-email-pawel.moll@arm.com>
X-OriginalArrivalTime: 02 Sep 2011 12:24:23.0768 (UTC) FILETIME=[3FADE580:01CC696B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds menuconfig VIRTUALIZATION to ARM Kconfig
and includes virtio Kconfig in it.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 arch/arm/Kconfig |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3269576..426f330 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2101,4 +2101,20 @@ source "security/Kconfig"
 
 source "crypto/Kconfig"
 
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	default n
+	---help---
+	  Say Y here to get to see options for using your Linux host to run other
+	  operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if VIRTUALIZATION
+
+source drivers/virtio/Kconfig
+
+endif # VIRTUALIZATION
+
 source "lib/Kconfig"
-- 
1.6.3.3

