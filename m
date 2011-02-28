Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab1CATh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:37:26 -0500
Received: from 206.83.70.71.ptr.us.xo.net ([206.83.70.71]:52545 "EHLO
	king.tilera.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1CAThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:37:20 -0500
Message-Id: <201103011934.p21JYc1m010301@farm-0010.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 28 Feb 2011 13:35:16 -0500
Subject: [PATCH] arch/tile: export <asm/hardwall.h> to userspace
To: linux-kernel@vger.kernel.org
In-Reply-To: <201103011931.p21JVtqp010237@farm-0010.internal.tilera.com>
X-OriginalArrivalTime: 01 Mar 2011 19:34:38.0342 (UTC) FILETIME=[B3F18A60:01CBD847]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should have been as part of the initial hardwall submission to
LKML but was overlooked.  The header provides the ioctl definitions for
manipulating the hardwall fd, so needs to be available to userspace.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 3b8f55b..849ab2f 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm
 
 header-y += ucontext.h
+header-y += hardwall.h
-- 
1.6.5.2

