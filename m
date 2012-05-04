Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab2EDQEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:04:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab2EDQEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:04:20 -0400
Date: Fri, 4 May 2012 12:04:17 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: CPU frequency drivers MAINTAINERS update
Message-ID: <20120504160417.GA421@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove myself as cpufreq maintainer.
x86 driver changes can go through the regular x86/ACPI trees.
ARM driver changes through the ARM trees.
cpufreq core changes are rare these days, and can just go to lkml/direct.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b81b261..fe89a16 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1968,10 +1968,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ti/cpmac.c
 
 CPU FREQUENCY DRIVERS
-M:	Dave Jones <davej@redhat.com>
 L:	cpufreq@vger.kernel.org
-W:	http://www.codemonkey.org.uk/projects/cpufreq/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
 S:	Maintained
 F:	drivers/cpufreq/
 F:	include/linux/cpufreq.h
