Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0LJQFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:05:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:55879 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487Ab0LJQFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:05:45 -0500
Message-ID: <4D024FD5.2090507@kernel.org>
Date: Fri, 10 Dec 2010 17:05:41 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: Add percpu allocator entry
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Dec 2010 16:05:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add me and Christoph Lameter as maintainers for the percpu memory
allocator.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
---
Let's increase the chance of proper review for percpu memory stuff.
I'll push this through percpu#for-next.  Thanks.

 MAINTAINERS |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1a1c27b..cb2ce5b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4602,6 +4602,15 @@ S:	Maintained
 F:	crypto/pcrypt.c
 F:	include/crypto/pcrypt.h

+PER-CPU MEMORY ALLOCATOR
+M:	Tejun Heo <tj@kernel.org>
+M:	Christoph Lameter <cl@linux-foundation.org>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/percpu*.h
+F:	mm/percpu*.c
+F:	arch/*/include/asm/percpu.h
+
 PER-TASK DELAY ACCOUNTING
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
-- 
1.7.1


