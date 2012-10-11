Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab2JKQSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:18:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33039 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2JKQSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:18:14 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] arm64: Automatically generate UAPI stat.h and unistd.h headers
Date: Thu, 11 Oct 2012 17:18:03 +0100
Message-Id: <1349972285-22830-3-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
References: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
X-OriginalArrivalTime: 11 Oct 2012 16:18:11.0421 (UTC) FILETIME=[021CA0D0:01CDA7CC]
X-MC-Unique: 112101117181303801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9BGJGqA011867

This headers simply include the corresponding asm-generic files, they
can be automatically generated.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/uapi/asm/Kbuild   |  5 +++--
 arch/arm64/include/uapi/asm/stat.h   | 16 ----------------
 arch/arm64/include/uapi/asm/unistd.h | 16 ----------------
 3 files changed, 3 insertions(+), 34 deletions(-)
 delete mode 100644 arch/arm64/include/uapi/asm/stat.h
 delete mode 100644 arch/arm64/include/uapi/asm/unistd.h

diff --git a/arch/arm64/include/uapi/asm/Kbuild b/arch/arm64/include/uapi/asm/Kbuild
index ca5b65f..d459ddf 100644
--- a/arch/arm64/include/uapi/asm/Kbuild
+++ b/arch/arm64/include/uapi/asm/Kbuild
@@ -12,6 +12,7 @@ header-y += setup.h
 header-y += sigcontext.h
 header-y += siginfo.h
 header-y += signal.h
-header-y += stat.h
 header-y += statfs.h
-header-y += unistd.h
+
+generic-y += stat.h
+generic-y += unistd.h
diff --git a/arch/arm64/include/uapi/asm/stat.h b/arch/arm64/include/uapi/asm/stat.h
deleted file mode 100644
index eeb702e..0000000
--- a/arch/arm64/include/uapi/asm/stat.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (C) 2012 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include <asm-generic/stat.h>
diff --git a/arch/arm64/include/uapi/asm/unistd.h b/arch/arm64/include/uapi/asm/unistd.h
deleted file mode 100644
index 1caadc2..0000000
--- a/arch/arm64/include/uapi/asm/unistd.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (C) 2012 ARM Ltd.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.  If not, see <http://www.gnu.org/licenses/>.
- */
-#include <asm-generic/unistd.h>

