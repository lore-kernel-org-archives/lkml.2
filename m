Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0K3WMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:12:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab0K3WMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:12:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: acme@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 2/2] perf: add memcpy to perf packaging
Date: Tue, 30 Nov 2010 17:12:13 -0500
Message-Id: <1291155133-3499-2-git-send-email-dzickus@redhat.com>
In-Reply-To: <1291155133-3499-1-git-send-email-dzickus@redhat.com>
References: <1291155133-3499-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There seems to be a new dependency on arch/*/lib/memcpy*.S when compiling
the perf tool.  Make sure that file is included in the MANIFEST when
creating the tarball.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/MANIFEST |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 8c7fc0c..c12659d 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -7,6 +7,7 @@ include/linux/stringify.h
 lib/rbtree.c
 include/linux/swab.h
 arch/*/include/asm/unistd*.h
+arch/*/lib/memcpy*.S
 include/linux/poison.h
 include/linux/magic.h
 include/linux/hw_breakpoint.h
-- 
1.7.3.2

