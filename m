Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935138Ab2C3Wvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:51:42 -0400
Received: from 206.83.70.73.ptr.us.xo.net ([206.83.70.73]:41825 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934986Ab2C3VGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:06:10 -0400
Message-Id: <201203302105.q2UL58RS006305@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 30 Mar 2012 15:29:40 -0400
Subject: [PATCH] arch/tile: stop mentioning the "kvm" subdirectory
In-Reply-To: <4F761E1C.80808.com>
References: <4F761E1C.80808.com>
To: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
X-OriginalArrivalTime: 30 Mar 2012 21:05:08.0429 (UTC) FILETIME=[C9B24FD0:01CD0EB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It causes "make clean" to fail, for example.  Once we have KVM support
complete, we'll reinstate the subdir reference.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/tile/Makefile b/arch/tile/Makefile
index 5e4d3b9..9520bc5 100644
--- a/arch/tile/Makefile
+++ b/arch/tile/Makefile
@@ -54,8 +54,6 @@ libs-y		+= $(LIBGCC_PATH)
 # See arch/tile/Kbuild for content of core part of the kernel
 core-y		+= arch/tile/
 
-core-$(CONFIG_KVM) += arch/tile/kvm/
-
 ifdef TILERA_ROOT
 INSTALL_PATH ?= $(TILERA_ROOT)/tile/boot
 endif
-- 
1.6.5.2

