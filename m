Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758490Ab2GFVHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 17:07:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42509 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298Ab2GFVHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:07:46 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 36/36] AArch64: MAINTAINERS update
Date: Fri,  6 Jul 2012 22:06:17 +0100
Message-Id: <1341608777-12982-37-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 06 Jul 2012 21:07:42.0026 (UTC) FILETIME=[61BADAA0:01CD5BBB]
X-MC-Unique: 112070622064706001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id q66L7xCA005339

This patch updates the MAINTAINERS file for the AArch64 Linux kernel
port.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index eb22272..50699f5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -192,6 +192,12 @@ S:	Supported
 F:	Documentation/scsi/aacraid.txt
 F:	drivers/scsi/aacraid/
 
+AARCH64 ARCHITECTURE
+M:	Catalin Marinas <catalin.marinas@arm.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/aarch64/
+
 ABIT UGURU 1,2 HARDWARE MONITOR DRIVER
 M:	Hans de Goede <hdegoede@redhat.com>
 L:	lm-sensors@lm-sensors.org

