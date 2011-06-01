Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab1FAR7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:59:19 -0400
Received: from mail.perches.com ([173.55.12.10]:2372 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1FAR7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:59:18 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>
Subject: [PATCH 2/6] MAINTAINERS: Update CPU FREQUENCY patterns
Date: Wed,  1 Jun 2011 10:59:10 -0700
Message-Id: <a293e86eee2db8d9a90c82160974a2b9b5d13eb7.1306950701.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306950701.git.joe@perches.com>
References: <cover.1306950701.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bb0a56ecc4ba ("[CPUFREQ] Move x86 drivers to drivers/cpufreq/")
moved the files, remove the old pattern.

cc: Dave Jones <davej@redhat.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ae06910..5d43f2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1889,7 +1889,6 @@ L:	cpufreq@vger.kernel.org
 W:	http://www.codemonkey.org.uk/projects/cpufreq/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
-F:	arch/x86/kernel/cpu/cpufreq/
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
 
-- 
1.7.5.rc3.dirty

