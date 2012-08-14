Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2HNRyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 13:54:41 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55648 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab2HNRxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 13:53:17 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 31/31] arm64: MAINTAINERS update
Date: Tue, 14 Aug 2012 18:52:32 +0100
Message-Id: <1344966752-16102-32-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.9.111.gf3fb0
In-Reply-To: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 14 Aug 2012 17:54:58.0322 (UTC) FILETIME=[EB55E720:01CD7A45]
X-MC-Unique: 112081418531513201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q7EHvQen017329

This patch updates the MAINTAINERS file for the AArch64 Linux kernel
port.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 94b823f..6d7c5f4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1204,6 +1204,12 @@ S:	Maintained
 F:	arch/arm/mach-pxa/z2.c
 F:	arch/arm/mach-pxa/include/mach/z2.h
 
+ARM64 PORT (AARCH64 ARCHITECTURE)
+M:	Catalin Marinas <catalin.marinas@arm.com>
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	arch/arm64/
+
 ASC7621 HARDWARE MONITOR DRIVER
 M:	George Joseph <george.joseph@fairview5.com>
 L:	lm-sensors@lm-sensors.org

